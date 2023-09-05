import 'package:bitriel_wallet/index.dart';
import 'package:logger/logger.dart';

Color hexaCodeToColor(String hexaCode) {
  return Color(AppUtils.convertHexaColor(hexaCode));
}

//Sizes
const double kSizeBottomNavigationBarHeight = 60.0;
const double kSizeBottomNavigationBarIconHeight = 25.0;

//Colors
const Color kColorBNBActiveTitleColor = Color.fromARGB(255, 66, 66, 66);
const Color kColorBNBDeactiveTitleColor = Color.fromARGB(255, 144, 144, 144);
Color kColorBNBBackground = hexaCodeToColor(AppColors.cardColor);

// Padding Size
const double paddingSize = 15.0;

List sldNetworkList = [];

var logger = Logger();