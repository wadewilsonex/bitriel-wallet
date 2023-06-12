import 'package:bitriel_wallet/application/utils/app_utils/app_utils.dart';
import 'package:flutter/material.dart';

Color hexaCodeToColor(String hexaCode) {
  return Color(AppUtils.convertHexaColor(hexaCode));
}

// Padding Size
const double paddingSize = 15.0;

List sldNetworkList = [];
