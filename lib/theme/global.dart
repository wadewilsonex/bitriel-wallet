// For Theme Initialize
// bool isDarkMode = true;

import 'package:awesome_select/awesome_select.dart';

bool isDarkMode = true;

// void setThemeValue(BuildContext context, bool value) {
//   Provider.of<ThemeProvider>(context, listen: false).setTheme = value;
//   isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDark;
//   print("setTheme $isDarkMode");
// } 


// Padding Size
const double paddingSize = 15.0;

List<S2Choice<String>> sldNetworkList = [
  S2Choice<String>(value: 'wss://rpc0.selendra.org', title: 'SELENDRA RPC0'),
  S2Choice<String>(value: 'wss://rpc1.selendra.org', title: 'SELENDRA RPC1'),
];