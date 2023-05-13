import 'package:wallet_apps/index.dart';

class AppStyle {
  static ThemeData myTheme(BuildContext context) {
    // Color color = hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightBg)
    return ThemeData(
      scaffoldBackgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
      appBarTheme: AppBarTheme(
        toolbarTextStyle: TextStyle(color: hexaCodeToColor(AppColors.appBarTextColor)),
        // color: Colors.transparent,
        iconTheme: IconThemeData(color: hexaCodeToColor(AppColors.appBarTextColor)),
        backgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg)
      ),

      /* Color All Text */
      // textTheme: TextTheme(bodyMedium: TextStyle(color: hexaCodeToColor(AppColors.textColor))),
      textTheme: TextTheme(bodyMedium: TextStyle(color: hexaCodeToColor(AppColors.darkGrey))),
      canvasColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightBg),
      drawerTheme: DrawerThemeData(backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightBg)),
      //cardColor: hexaCodeToColor(AppConfig.darkBlue50.toString()),

      // bottomAppBarTheme:
      //     BottomAppBarTheme(color: hexaCodeToColor(AppColors.cardColor)),
      // floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: hexaCodeToColor(AppColors.textColor)),
      fontFamily: "NotoSans",
      unselectedWidgetColor: Colors.white,
    );
  }
}