import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  Future<void> changeMode() async {
    
    isDark = true;//!isDark;

    // if (isDark) await StorageServices.storeData('dark', DbKey.themeMode);
    // else if (isDark == false) await StorageServices.removeKey(DbKey.themeMode);

    notifyListeners();
  }

  set setTheme(bool theme){
    isDark = theme;
    notifyListeners();
  }

  static final ThemeData lightTheme = ThemeData.light();
  static final ThemeData darkTheme = ThemeData.dark();
}
