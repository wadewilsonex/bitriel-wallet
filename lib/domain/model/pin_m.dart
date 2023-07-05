import 'package:bitriel_wallet/index.dart';

class PinModel {
  dynamic res;
  List<ValueNotifier<String>> lsPINController = [
    ValueNotifier(''),
    ValueNotifier(''),
    ValueNotifier(''),
    ValueNotifier(''),
    ValueNotifier(''),
    ValueNotifier(''),
  ];

  final localAuth = LocalAuthentication();

  int pinIndex = 0;

  String? firstPin;

  // ValueNotifier<bool>? valueChange[1].value<bool>(true);

  // bool? valueChange.value[0] = false;

  /// [0] = is4Digit;
  /// 
  /// [1] = isFirstPin
  List<ValueNotifier<bool?>> valueChange = [
    ValueNotifier(false),
    ValueNotifier(true)
  ];

  List<String> currentPin = ["", "", "", "", "", ""];

  String titleStatus = "First PIN";
  String subTitleStatus = "Please fill out PIN";

  ValueNotifier<bool> is6gidit = ValueNotifier(true);
  ValueNotifier<bool> isFirstPIN = ValueNotifier(true);
  
  PinCodeLabel? pinLabel;
  
}