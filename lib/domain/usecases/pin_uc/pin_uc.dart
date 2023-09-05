import 'package:bitriel_wallet/index.dart';

abstract class PinUsecase {
  List<ValueNotifier<String>> init4Digits();
  List<ValueNotifier<String>> init6Digits();
  void onPressedDigitOption(bool value);
  Future<void> setPin(BuildContext context, String text);

  void clearAll();
  void clearPin();
  
  Future<void> clearVerifyPin(BuildContext context, String pin);

  Future<void> authenticate(BuildContext context);
}