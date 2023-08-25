abstract class AppUsecases {

  Future<void> checkAccountExist();
  // Future<bool> checkBiometrics();
  Future<void> authenticateBiometric();
  Future<void> enableBiometric(bool switchValue);
  Future<void> readBio();
  Future<void> authPopup();
  Future<void> changePin();

}