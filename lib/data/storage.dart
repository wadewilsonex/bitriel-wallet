import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// For the class flutter_secure_storage, it is better to create static functions. 
/// This is because the class is designed to be used as a singleton, meaning that there should only be one instance of the class in your application. 
/// If you create instance objects of the class, you will end up with multiple instances of the class, which can lead to problems
class SecureStorage {
  
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> writeData({String? key, String? encodeValue}) async {
    await _secureStorage.write(key: key!, value: encodeValue);
  }

  static Future<String?> readData({String? key}) async {
    return await _secureStorage.read(key: key!);
  }

  static Future<void> writeSecureList(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }
}