import 'package:bitriel_wallet/index.dart';

abstract class AppUsecases {

  Future<void> checkAccountExist();
  // Future<bool> checkBiometrics();
  Future<void> authenticateBiometric();
  Future<void> enableBiometric(bool switchValue);
  Future<void> readBio(BuildContext context);
  Future<void> authPopup(BuildContext context);
  Future<void> changePin();

}