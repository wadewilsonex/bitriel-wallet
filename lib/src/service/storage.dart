import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_apps/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:get_storage/get_storage.dart';

// ignore: avoid_classes_with_only_static_members
class StorageServices {
  static String? _decode;
  static SharedPreferences? _preferences;

  static const _storage = FlutterSecureStorage();

  static Future<String>? readSecure(String key) async {

    String? res = await _storage.read(key: key);
    return res ?? '';
  }

  static Future<void> writeSecure(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<void> writeSecureList(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<void> clearKeySecure(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clearSecure() async {
    await _storage.deleteAll();
  }

  static Future<void> clearStorage() async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences!.clear();
  }

  static Future<SharedPreferences> storeData(dynamic data, String path) async {
    try {

      _preferences = await SharedPreferences.getInstance();
      _decode = jsonEncode(data);
      
      await _preferences!.setString(path, _decode!);

    } catch (e){
      
      if (kDebugMode) {
        debugPrint("Error storeData $e");
      }
    }
    return _preferences!;
  }

  static Future<SharedPreferences> addMoreData(Map<String, dynamic> data, String path) async {
    List<Map<String, dynamic>> ls = [];
    _preferences = await SharedPreferences.getInstance();
    if (_preferences!.containsKey(path)) {
      final dataString = _preferences!.getString(path);

      ls = List<Map<String, dynamic>>.from(jsonDecode(dataString!) as List);
      ls.add(data);
    } else {
      ls.add(data);
    }

    _decode = jsonEncode(ls);
    await _preferences!.setString(path, _decode!);
    return _preferences!;
  }

  static Future<void> storeAssetData(BuildContext context) async {
    try {

      final contract = Provider.of<ContractProvider>(context, listen: false);

      contract.listContract = contract.listContract.where((element) {
        if(contract.listContract.indexOf(element) != 0 && element.id != 'bitcoin') {
          element.address = contract.ethAdd;
        }
        return true;
      }).toList();

      contract.addedContract = contract.addedContract.where((element) {
        element.address = contract.ethAdd;
        return true;
      }).toList();
      
      final lsContract = SmartContractModel.encode(contract.listContract);
      final adContract = SmartContractModel.encode(contract.addedContract);


      await _preferences!.setString(DbKey.listContract, jsonEncode(lsContract));
      await _preferences!.setString(DbKey.addedContract, jsonEncode(adContract));
    } catch (e) {
      
      if (kDebugMode) {
        debugPrint("Error storeAssetData $e");
      }
    }
  }

  static Future<SharedPreferences> addTxHistory(TxHistory txHistory, String key) async {
    final List<TxHistory> txHistoryList = [];
    _preferences = await SharedPreferences.getInstance();

    await StorageServices.fetchData('txhistory').then((value) {
      if (value != null) {
        for (final i in value) {
          txHistoryList.add(TxHistory(
            date: i['date'].toString(),
            symbol: i['symbol'].toString(),
            destination: i['destination'].toString(),
            sender: i['sender'].toString(),
            amount: i['amount'].toString(),
            org: i['fee'].toString(),
          ));
        }
        txHistoryList.add(txHistory);
      } else {
        txHistoryList.add(txHistory);
      }
    });

    await _preferences!.setString(key, jsonEncode(txHistoryList));

    return _preferences!;
  }

  static Future<void> saveEthContractAddr(String contractAddr) async {
    final List<String> contractAddrList = [];
    final res = await fetchData(DbKey.ethContractList);

    if (res != null) {
      contractAddrList.clear();
      for (final i in res) {
        contractAddrList.add(i.toString());
      }
      contractAddrList.add(contractAddr);
      await storeData(contractAddrList, DbKey.ethContractList);
    } else {
      contractAddrList.add(contractAddr);

      await storeData(contractAddrList, DbKey.ethContractList);
    }
  }

  static Future<void> removeEthContractAddr(String contractAddr) async {
    List contractAddrList = [];
    final res = await fetchData(DbKey.ethContractList);

    if (res != null) {
      contractAddrList = res as List;

      contractAddrList.removeWhere((element) => element == contractAddr);

      if (contractAddrList.isNotEmpty) {
        await StorageServices.storeData(contractAddrList, DbKey.ethContractList);
      } else {
        await removeKey(DbKey.ethContractList);
      }
    }
  }

  static Future<void> saveContractAddr(String contractAddr) async {
    final List<String> contractAddrList = [];
    final res = await fetchData(DbKey.contactList);

    if (res != null) {
      contractAddrList.clear();
      for (final i in res) {
        contractAddrList.add(i.toString());
      }
      contractAddrList.add(contractAddr);
      await storeData(contractAddrList, DbKey.contactList);
    } else {
      contractAddrList.add(contractAddr);

      await storeData(contractAddrList, DbKey.contactList);
    }
  }

  static Future<void> removeContractAddr(String contractAddr) async {
    List contractAddrList = [];
    final res = await fetchData(DbKey.contactList);

    if (res != null) {
      contractAddrList = res as List;

      contractAddrList.removeWhere((element) => element == contractAddr);

      if (contractAddrList.isNotEmpty) {
        await StorageServices.storeData(contractAddrList, DbKey.contactList);
      } else {
        await removeKey(DbKey.contactList);
      }
    }
  }

  // ignore: avoid_positional_boolean_parameters
  static Future<void> saveBool(String key, bool value) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences!.setBool(key, value);
  }

  static Future<bool>? readBool(String key) async {
    _preferences = await SharedPreferences.getInstance();
    final res = _preferences!.getBool(key);

    return res!;
  }

  // ignore: avoid_positional_boolean_parameters
  static Future<void> saveBio(bool enable) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences!.setBool(DbKey.bio, enable);
  }

  static Future<bool> readSaveBio() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getBool(DbKey.bio) ?? false;
  }

  static Future<SharedPreferences> setUserID(String data, String path) async {
    _preferences = await SharedPreferences.getInstance();
    _decode = jsonEncode(data);
    _preferences!.setString(path, _decode!);
    return _preferences!;
  }

  static Future<dynamic> fetchAsset(String path) async {
    try {

      _preferences = await SharedPreferences.getInstance();

      _decode = _preferences!.getString(path);

      if (_decode != null){

        final res = SmartContractModel.decode(_decode!);
        return res;
      }

    } catch (e) {
      
      if (kDebugMode) {
        debugPrint("Error fetchAsset $e");
      }
    }
    //return _preferences.getString(_path);
  }

  static Future<dynamic> fetchData(String path) async {
    _preferences = await SharedPreferences.getInstance();

    final data = _preferences!.getString(path);

    if (data == null) {
      return null;
    } else {
      return json.decode(data);
    }
  }

  static Future<void> removeKey(String path) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences!.remove(path);
  }

  static Future<Map?> getSeeds(String? seedType) async {
    _preferences = await SharedPreferences.getInstance();
    String? value = _preferences!.getString('wallet_seed_$seedType');
    if (value != null) {
      return jsonDecode(value);
    }
    return {};
  }
}

class KeyringStorage {
  static final _storage = () => GetStorage("polka_wallet_sdk");

  final keyPairs = [].val('keyPairs', getBox: _storage);
  final contacts = [].val('contacts', getBox: _storage);
  final ReadWriteValue<String?> currentPubKey = ''.val('currentPubKey', getBox: _storage);
  final encryptedRawSeeds = {}.val('encryptedRawSeeds', getBox: _storage);
  final encryptedMnemonics = {}.val('encryptedMnemonics', getBox: _storage);
}
