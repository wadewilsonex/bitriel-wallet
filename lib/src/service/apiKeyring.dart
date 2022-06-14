import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:polkawallet_sdk/service/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/service/encryptSeed_s.dart';
import 'package:polkawallet_sdk/api/types/addressIconData.dart';
import 'package:polkawallet_sdk/api/types/verifyResult.dart';
import 'package:polkawallet_sdk/webviewWithExtension/types/signExtrinsicParam.dart';
import 'package:wallet_apps/src/service/serviceKeyring.dart';

class MyApiKeyring extends ApiKeyring {

  final PolkawalletApi apiRoot;
  final ServiceKeyring service;
  MyApiKeyring(this.apiRoot, this.service) : super(apiRoot, service);

  // MyServiceKeyring setServiceKeyring(ServiceKeyring se){
  //   service.serviceRoot = se.serviceRoot;
  //   return service;
  // }

  @override
  Future<KeyPairData> addAccount(
    Keyring keyring, {
    required KeyType keyType,
    required Map acc,
    required String password,
  }) async {

    // save seed and remove it before add account
    if (keyType == KeyType.mnemonic || keyType == KeyType.rawSeed) {
      final String type = keyType.toString().split('.')[1];
      final String? seed = acc[type];
      if (seed != null && seed.isNotEmpty) {
        await EncryptSeed(keyring.store.ss58List).encryptSeedAndSave(acc['pubKey'], acc[type], type, password);
        acc.remove(type);
      }
    }

    // save keystore to storage
    await EncryptSeed(keyring.store.ss58List).addAccount(acc);

    await updatePubKeyIconsMap(keyring, [acc['pubKey']]);
    updatePubKeyAddressMap(keyring);
    updateIndicesMap(keyring, [acc['address']]);

    return KeyPairData.fromJson(acc as Map<String, dynamic>);
  }

  /// Generate a set of new mnemonic.
  @override
  Future<AddressIconDataWithMnemonic> generateMnemonic(int ss58,
      {CryptoType cryptoType = CryptoType.sr25519,
      String derivePath = '',
      String key = ''}) async {
    final mnemonicData = await service.generateMnemonic(ss58,
        cryptoType: cryptoType, derivePath: derivePath, key: key);
    return mnemonicData;
  }

  /// get address and avatar from mnemonic.
  @override
  Future<AddressIconData> addressFromMnemonic(int ss58,
      {CryptoType cryptoType = CryptoType.sr25519,
      String derivePath = '',
      required String mnemonic}) async {
    final addressInfo = await service.addressFromMnemonic(ss58,
        cryptoType: cryptoType, derivePath: derivePath, mnemonic: mnemonic);
    return addressInfo;
  }

  /// get address and avatar from rawSeed.
  @override
  Future<AddressIconData> addressFromRawSeed(int ss58,
      {CryptoType cryptoType = CryptoType.sr25519,
      String derivePath = '',
      required String rawSeed}) async {
    final addressInfo = await service.addressFromRawSeed(ss58,
        cryptoType: cryptoType, derivePath: derivePath, rawSeed: rawSeed);
    return addressInfo;
  }

  /// get address and avatar from KeyStore.
  @override
  Future<AddressIconData> addressFromKeyStore(int ss58,
      {required Map keyStore}) async {
    final addressInfo =
        await service.addressFromKeyStore(ss58, keyStore: keyStore);
    return AddressIconData.fromJson({
      'address': addressInfo[0][0],
      'svg': addressInfo[0][1],
    });
  }

  /// check mnemonic valid.
  @override
  Future<bool> checkMnemonicValid(String mnemonic) async {
    return service.checkMnemonicValid(mnemonic);
  }

  /// Import account from mnemonic/rawSeed/keystore.
  /// param [cryptoType] can be `sr25519`(default) or `ed25519`.
  /// throw error if import failed.
  /// return null if keystore password check failed.
  @override
  Future<Map?> importAccount(
    Keyring keyring, {
    required KeyType keyType,
    required String key,
    required String name,
    required String password,
    CryptoType cryptoType = CryptoType.sr25519,
    String derivePath = '',
  }) async {
    dynamic acc = await service.importAccount(
      keyType: keyType,
      key: key,
      name: name,
      password: password,
      cryptoType: cryptoType,
      derivePath: derivePath,
    );
    if (acc == null) {
      return null;
    }
    if (acc['error'] != null) {
      throw Exception(acc['error']);
    }

    return acc;
  }

  /// Add a contact.
  @override
  Future<KeyPairData> addContact(Keyring keyring, Map acc) async {
    dynamic pubKey = await (service.serviceRoot.account
        .decodeAddress([acc['address']]) as Future<Map<dynamic, dynamic>>);
    acc['pubKey'] = pubKey.keys.toList()[0];

    // save keystore to storage
    await EncryptSeed(keyring.store.ss58List).addContact(acc);

    await updatePubKeyAddressMap(keyring);
    await updatePubKeyIconsMap(keyring, [acc['pubKey']]);
    updateIndicesMap(keyring, [acc['address']]);

    return keyring.contacts.firstWhere((e) => e.pubKey == acc['pubKey']);
  }

  /// Every time we change the keyPairs, we need to update the
  /// pubKey-address map.
  @override
  Future<void> updatePubKeyAddressMap(Keyring keyring) async {
    final ls = EncryptSeed(keyring.store.ss58List).list.toList();
    ls.addAll(EncryptSeed(keyring.store.ss58List).contacts);
    // get new addresses from webView.
    final res = await service.getPubKeyAddressMap(ls, EncryptSeed(keyring.store.ss58List).ss58List);

    // set new addresses to Keyring instance.
    if (res != null && res[keyring.ss58.toString()] != null) {
      EncryptSeed(keyring.store.ss58List).updatePubKeyAddressMap(Map<String, Map>.from(res));
    }
  }

  /// This method query account icons and set icons to [EncryptSeed(keyring.store.ss58List)]
  /// so we can get icon of an account from [Keyring] instance.
  @override
  Future<void> updatePubKeyIconsMap(Keyring keyring, [List? pubKeys]) async {
    final List<String?> ls = [];
    if (pubKeys != null) {
      ls.addAll(List<String>.from(pubKeys));
    } else {
      ls.addAll(keyring.keyPairs.map((e) => e.pubKey).toList());
      ls.addAll(keyring.contacts.map((e) => e.pubKey).toList());
    }

    if (ls.length == 0) return;
    // get icons from webView.
    final res = await service.getPubKeyIconsMap(ls);
    // set new icons to Keyring instance.
    if (res != null) {
      final data = {};
      res.forEach((e) {
        data[e[0]] = e[1];
      });
      EncryptSeed(keyring.store.ss58List).updateIconsMap(Map<String, String>.from(data));
    }
  }

  /// This method query account indices and set data to [EncryptSeed(keyring.store.ss58List)]
  /// so we can get index info of an account from [Keyring] instance.
  @override
  Future<void> updateIndicesMap(Keyring keyring, [List? addresses]) async {
    final List<String?> ls = [];
    if (addresses != null) {
      ls.addAll(List<String>.from(addresses));
    } else {
      ls.addAll(keyring.allWithContacts.map((e) => e.address).toList());
    }

    if (ls.length == 0) return;
    // get account indices from webView.
    final res = await apiRoot.account.queryIndexInfo(ls);
    // set new indices to Keyring instance.
    if (res != null) {
      final data = {};
      res.forEach((e) {
        data[e['accountId']] = e;
      });
      EncryptSeed(keyring.store.ss58List).updateIndicesMap(Map<String, Map>.from(data));
      keyring.allAccounts;
    }
  }

  /// Decrypt and get the backup of seed.
  @override
  Future<SeedBackupData?> getDecryptedSeed(Keyring keyring, password) async {
    final Map? data = await EncryptSeed(EncryptSeed(keyring.store.ss58List).ss58List).getDecryptedSeed(keyring.current.pubKey, password);
    print("getDecryptedSeed $data");
    if (data == null) {
      return null;
    }
    if (data['seed'] == null) {
      data['error'] = 'wrong password';
    }
    return SeedBackupData.fromJson(data as Map<String, dynamic>);
  }

  /// delete account from storage
  @override
  Future<void> deleteAccount(Keyring keyring, KeyPairData account) async {
    if (account != null) {
      await EncryptSeed(EncryptSeed(keyring.store.ss58List).ss58List).deleteAccount(account.pubKey);
    }
  }

  /// check password of account
  @override
  Future<bool> checkPassword(KeyPairData account, String pass) async {
    try {

      final res = await service.checkPassword(account.pubKey, pass);
      print("checkPassword res $res");
      return res;
    } catch (e){
      return false;
    }
  }

  /// change password of account
  @override
  Future<KeyPairData?> changePassword(Keyring keyring, String passOld, passNew) async {
    final acc = keyring.current;
    // 1. change password of keyPair in webView
    final res = await service.changePassword(acc.pubKey, passOld, passNew);
    print("changePassword $res");
    if (res == null) {
      return null;
    }
    // 2. if success in webView, then update encrypted seed in local storage.
    EncryptSeed(keyring.store.ss58List).updateEncryptedSeed(acc.pubKey, passOld, passNew);

    // update json meta data
    service.updateKeyPairMetaData(res, acc.name);
    // update keyPair date in storage
    EncryptSeed(keyring.store.ss58List).updateAccount(res);
    return KeyPairData.fromJson(res as Map<String, dynamic>);
  }

  /// change name of account
  @override
  Future<KeyPairData> changeName(Keyring keyring, String name) async {
    final json = keyring.current.toJson();
    // update json meta data
    service.updateKeyPairMetaData(json, name);
    // update keyPair date in storage
    EncryptSeed(keyring.store.ss58List).updateAccount(json);
    return KeyPairData.fromJson(json);
  }

  /// Check if derive path is valid, return [null] if valid,
  /// and return error message if invalid.
  Future<String?> checkDerivePath(
      String seed, path, CryptoType cryptoType) async {
    String? res = await service.checkDerivePath(seed, path, cryptoType);
    return res;
  }

  /// Open a new webView for a DApp,
  /// sign extrinsic or msg for the DApp.
  @override
  Future<ExtensionSignResult?> signAsExtension(
      String password, SignAsExtensionParam param) async {
    final signature = await service.signAsExtension(password, param.toJson());
    if (signature == null) {
      return null;
    }
    final ExtensionSignResult res = ExtensionSignResult();
    res.id = param.id;
    res.signature = signature['signature'];
    return res;
  }

  @override
  Future<VerifyResult?> signatureVerify(
      String message, signature, address) async {
    final res = await service.signatureVerify(message, signature, address);
    if (res == null) {
      return null;
    }
    return VerifyResult.fromJson(
        Map<String, dynamic>.of(res as Map<String, dynamic>));
  }

}
