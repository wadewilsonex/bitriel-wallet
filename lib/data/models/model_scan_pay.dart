import 'package:flutter/material.dart';

class ModelScanPay {
  final formStateKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  /* Scan Pay */
  String? pin;
  String? asset;
  String? balance = "0";
  int assetValue = 0;
  String? responseWallet, responseAmount, responseMemo;
  String? loadingDot = "";
  String? hash;
  String? logo;

  bool isSuccessPin = false, isPay = false, enable = false;

  List portfolio = [];

  TextEditingController controlAmount = TextEditingController();
  TextEditingController controlMemo = TextEditingController();
  TextEditingController controlReceiverAddress = TextEditingController();

  FocusNode nodeAmount = FocusNode();
  FocusNode nodeMemo = FocusNode();
  FocusNode nodeReceiverAddress = FocusNode();
}
