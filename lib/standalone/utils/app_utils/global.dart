import 'package:bitriel_wallet/standalone/utils/app_utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Color hexaCodeToColor(String hexaCode) {
  return Color(AppUtils.convertHexaColor(hexaCode));
}

// Padding Size
const double paddingSize = 15.0;

List sldNetworkList = [];

var logger = Logger();