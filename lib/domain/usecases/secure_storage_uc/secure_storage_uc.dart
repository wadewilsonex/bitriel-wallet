abstract class SecureStorageUsecase {

  Future<String>? readSecure(String key);

  Future<void>? writeSecure(String key, String value);

  Future<void> clearByKeySecure(String key);

  Future<void> clearAllSecure();

  Future<bool> isKeyAvailable(String key);
}