import 'package:crypto_font_icons/crypto_font_icons.dart';
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

// List<CryptoPairModel> cryptocurrencies = [
//   CryptoPairModel(
//     'Bitcoin',
//     'BTC',
//     'USD',
//     CryptoFontIcons.BTC,
//   ),
//   CryptoPairModel(
//     'Ethereum',
//     'ETH',
//     'USD',
//     CryptoFontIcons.ETH,
//   ),
// ];

