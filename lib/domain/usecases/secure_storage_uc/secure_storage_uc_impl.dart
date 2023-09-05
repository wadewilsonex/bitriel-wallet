import 'package:bitriel_wallet/index.dart';

class SecureStorageImpl implements SecureStorageUsecase {

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<String>? readSecure(String key) async {

    String? res = await _storage.read(key: key);
    return res ?? '';
  }
  @override
  Future<void> writeSecure(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  Future<void> writeSecureList(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> clearByKeySecure(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> clearAllSecure() async {
    await _storage.deleteAll();
  }

  @override
  Future<bool> isKeyAvailable(String key) async {
    return await _storage.containsKey(key: key);
  }
}