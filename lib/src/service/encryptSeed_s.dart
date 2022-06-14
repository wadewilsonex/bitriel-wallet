import 'package:aes_ecb_pkcs5_flutter/aes_ecb_pkcs5_flutter.dart';
import 'package:polkawallet_sdk/utils/index.dart';
import 'package:polkawallet_sdk/utils/localStorage.dart';

import 'package:polkawallet_sdk/api/apiTx.dart';
import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/service/tx.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:polkawallet_sdk/service/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

import 'package:get_storage/get_storage.dart';
import 'package:polkawallet_sdk/storage/localStorage.dart';

class EncryptSeed extends KeyringPrivateStore{

  final KeyringStorage _storage = KeyringStorage();
  final LocalStorage _storageOld = LocalStorage();
  final List<int> ss58List;

  Map<String, Map> _pubKeyAddressMap = {};
  Map<String, String> _iconsMap = {};
  Map<String, Map> _indicesMap = {};

  EncryptSeed(this.ss58List) : super(ss58List);

  @override
  String? get currentPubKey => _storage.currentPubKey.val;
  void setCurrentPubKey(String? pubKey) {
    _storage.currentPubKey.val = pubKey;
  }

  @override
  List get list {
    return _formatAccount(_storage.keyPairs.val.toList());
  }

  @override
  List get externals {
    final ls = _storage.contacts.val.toList();
    ls.retainWhere((e) => e['observation'] ?? false);
    return _formatAccount(ls);
  }

  @override
  List get contacts {
    return _formatAccount(_storage.contacts.val.toList());
  }

  @override
  Map<String, Map> get pubKeyAddressMap {
    return _pubKeyAddressMap;
  }

  @override
  List _formatAccount(List ls) {
    ls.forEach((e) {
      final networkSS58 = ss58.toString();
      if (_pubKeyAddressMap[networkSS58] != null &&
          _pubKeyAddressMap[networkSS58]![e['pubKey']] != null) {
        e['address'] = _pubKeyAddressMap[networkSS58]![e['pubKey']];
      }
      e['icon'] = _iconsMap[e['pubKey']];
      e['indexInfo'] = _indicesMap[e['address']];
    });
    return ls;
  }

  /// the [GetStorage] package needs to be initiated before use.
  @override
  Future<void> init() async {
    await GetStorage.init(sdk_storage_key);
    await _loadKeyPairsFromStorage();
  }

  /// load keyPairs form local storage to memory.
  Future<void> _loadKeyPairsFromStorage() async {
    final ls = await _storageOld.getAccountList();
    if (ls.length > 0) {
      ls.retainWhere((e) {
        // delete all storageOld data
        _storageOld.removeAccount(e['pubKey']);
        if (e['mnemonic'] != null || e['rawSeed'] != null) {
          e.remove('mnemonic');
          e.remove('rawSeed');
        }

        // retain accounts from storageOld
        final i = _storage.keyPairs.val.indexWhere((pair) {
          return pair['pubKey'] == e['pubKey'];
        });
        return i < 0;
      });
      final List pairs = _storage.keyPairs.val.toList();
      pairs.addAll(ls);
      _storage.keyPairs.val = pairs;

      // load current account pubKey
      final curr = await _storageOld.getCurrentAccount();
      if (curr != null && curr.isNotEmpty) {
        setCurrentPubKey(curr);
        _storageOld.setCurrentAccount('');
      }

      // and move all encrypted seeds to new storage
      _migrateSeeds();
    }
  }

  @override
  void updatePubKeyAddressMap(Map<String, Map> data) {
    _pubKeyAddressMap = data;
  }

  @override
  void updateIconsMap(Map<String, String> data) {
    _iconsMap.addAll(data);
  }

  @override
  void updateIndicesMap(Map<String, Map> data) {
    _indicesMap = data;
  }

  @override
  Future<void> addAccount(Map acc) async {
    final pairs = _storage.keyPairs.val.toList();
    // remove duplicated account and add a new one
    pairs.retainWhere((e) => e['pubKey'] != acc['pubKey']);
    pairs.add(acc);
    _storage.keyPairs.val = pairs;

    setCurrentPubKey(acc['pubKey']);
  }

  @override
  Future<void> addContact(Map acc) async {
    final ls = _storage.contacts.val.toList();
    ls.add(acc);
    _storage.contacts.val = ls;

    if (acc['observation'] ?? false) {
      setCurrentPubKey(acc['pubKey']);
    }
  }

  @override
  Future<void> updateAccount(Map acc, {bool isExternal: false}) async {
    if (isExternal) {
      updateContact(acc);
    } else {
      _updateKeyPair(acc);
    }
  }

  @override
  Future<void> _updateKeyPair(Map acc) async {
    final List pairs = _storage.keyPairs.val.toList();
    pairs.removeWhere((e) => e['pubKey'] == acc['pubKey']);
    pairs.add(acc);
    _storage.keyPairs.val = pairs;
  }

  @override
  Future<void> updateContact(Map acc) async {
    final ls = _storage.contacts.val.toList();
    ls.removeWhere((e) => e['pubKey'] == acc['pubKey']);
    ls.add(acc);
    _storage.contacts.val = ls;
  }

  @override
  Future<void> deleteAccount(String? pubKey) async {
    _deleteKeyPair(pubKey);

    final mnemonics = Map.of(_storage.encryptedMnemonics.val);
    mnemonics.removeWhere((key, _) => key == pubKey);
    _storage.encryptedMnemonics.val = mnemonics;
    final seeds = Map.of(_storage.encryptedRawSeeds.val);
    seeds.removeWhere((key, _) => key == pubKey);
    _storage.encryptedRawSeeds.val = seeds;
  }

  @override
  Future<void> _deleteKeyPair(String? pubKey) async {
    final List pairs = _storage.keyPairs.val.toList();
    pairs.removeWhere((e) => e['pubKey'] == pubKey);
    _storage.keyPairs.val = pairs;

    if (pairs.length > 0) {
      setCurrentPubKey(pairs[0]['pubKey']);
    } else if (externals.length > 0) {
      setCurrentPubKey(externals[0]['pubKey']);
    } else {
      setCurrentPubKey('');
    }
  }

  @override
  Future<void> deleteContact(String pubKey) async {
    final ls = _storage.contacts.val.toList();
    ls.removeWhere((e) => e['pubKey'] == pubKey);
    _storage.contacts.val = ls;
  }

  @override
  Future<void> encryptSeedAndSave(
      String? pubKey, seed, seedType, password) async {
    final String key = Encrypt.passwordToEncryptKey(password);
    final String encrypted = await FlutterAesEcbPkcs5.encryptString(seed, key);

    // read old data from storage-old
    dynamic stored = await (_storageOld.getSeeds(seedType));
    stored[pubKey] = encrypted;
    // and save to new storage
    if (seedType == KeyType.mnemonic.toString().split('.')[1]) {
      final mnemonics = Map.from(_storage.encryptedMnemonics.val);
      mnemonics.addAll(stored);
      _storage.encryptedMnemonics.val = mnemonics;
      return;
    }
    if (seedType == KeyType.rawSeed.toString().split('.')[1]) {
      final seeds = Map.from(_storage.encryptedRawSeeds.val);
      seeds.addAll(stored);
      _storage.encryptedRawSeeds.val = seeds;
    }
  }

  @override
  Future<void> updateEncryptedSeed(String? pubKey, passOld, passNew) async {
    final seed = await (getDecryptedSeed(pubKey, passOld));
    encryptSeedAndSave(pubKey, seed!['seed'], seed['type'], passNew);
  }

  @override
  Future<Map<String, dynamic>?> getDecryptedSeed(
      String? pubKey, password) async { 
    final key = Encrypt.passwordToEncryptKey(password);
    final mnemonic = _storage.encryptedMnemonics.val[pubKey];
    if (mnemonic != null) {
      final res = {'type': KeyType.mnemonic.toString().split('.')[1]};
      try {
        res['seed'] = await FlutterAesEcbPkcs5.decryptString(mnemonic, key);
      } catch (err) {
        // print(err);
      }
      return res;
    }
    final rawSeed = _storage.encryptedRawSeeds.val[pubKey];
    if (rawSeed != null) {
      final res = {'type': KeyType.rawSeed.toString().split('.')[1]};
      try {
        res['seed'] = await FlutterAesEcbPkcs5.decryptString(rawSeed, key);
      } catch (err) {
        // print(err);
      }
      return res;
    }
    return null;
  }

  @override
  Future<bool> checkSeedExist(KeyType keyType, String pubKey) async {
    switch (keyType) {
      case KeyType.mnemonic:
        return _storage.encryptedMnemonics.val[pubKey] != null;
      case KeyType.rawSeed:
        return _storage.encryptedRawSeeds.val[pubKey] != null;
      default:
        return false;
    }
  }

  @override
  Future<void> _migrateSeeds() async {
    final res = await Future.wait([
      _storageOld.getSeeds('mnemonic'),
      _storageOld.getSeeds('rawSeed'),
    ]);
    if (res[0]!.keys.length > 0) {
      final mnemonics = Map.of(_storage.encryptedMnemonics.val);
      mnemonics.addAll(res[0]!);
      _storage.encryptedMnemonics.val = mnemonics;
      _storageOld.setSeeds('mnemonic', {});
    }
    if (res[1]!.keys.length > 0) {
      final seeds = Map.of(_storage.encryptedRawSeeds.val);
      seeds.addAll(res[1]!);
      _storage.encryptedRawSeeds.val = seeds;
      _storageOld.setSeeds('rawSeed', {});
    }
  }
}