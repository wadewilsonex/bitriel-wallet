abstract class SecureStorageUC {

  Future<String>? readSecure(String key);

  Future<void>? writeSecure(String key, String value);

  Future<void> clearByKeySecure(String key);

  Future<void> clearAllSecure();
  
}