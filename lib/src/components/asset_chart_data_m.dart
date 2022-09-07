import 'package:flutter/material.dart';

class CryptoPairModel {
  final String? cryptoName;
  final String? cryptoBase;
  final String? exchangeCurrency;
  final Widget? cryptoIcon;

  CryptoPairModel({
    this.cryptoName,
    this.cryptoBase,
    this.exchangeCurrency,
    this.cryptoIcon,
  }
  );
}

