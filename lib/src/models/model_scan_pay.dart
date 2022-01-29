import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModelScanPay {
  final formStateKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  /* Scan Pay */
  String? pin;
  String? asset;
  int? assetValue;
  String? responseWallet, responseAmount, responseMemo;
  String? loadingDot = "";
  double? estPrice = 0.0;
  int currency = 0;//["USD", "SEL"];

  bool isSuccessPin = false, isPay = false, enable = false;

  List portfolio = [];

  TextEditingController controlAmount = TextEditingController();
  TextEditingController controlMemo = TextEditingController();
  TextEditingController controlReceiverAddress = TextEditingController();

  FocusNode nodeAmount = FocusNode();
  FocusNode nodeMemo = FocusNode();
  FocusNode nodeReceiverAddress = FocusNode();
}
