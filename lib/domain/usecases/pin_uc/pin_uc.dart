import 'package:bitriel_wallet/index.dart';

abstract class PinUsecase {
  List<ValueNotifier<String>> init4Digits();
  List<ValueNotifier<String>> init6Digits();
  void onPressedDigit();

  Future<void> authenticate(BuildContext context);
}