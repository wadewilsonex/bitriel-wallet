import 'package:wallet_apps/index.dart';

class AppStyle {
  static ThemeData myTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: hexaCodeToColor(AppColors.darkBgd),//isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor("#F5F5F5"),
      appBarTheme: AppBarTheme(
        toolbarTextStyle: TextStyle(color: hexaCodeToColor(AppColors.appBarTextColor)),
        color: Colors.transparent,
        iconTheme: IconThemeData(color: hexaCodeToColor(AppColors.appBarTextColor))
      ),

      /* Color All Text */
      textTheme: TextTheme(bodyText2: TextStyle(color: hexaCodeToColor(AppColors.textColor))),
     
      fontFamily: "Prompt",
      unselectedWidgetColor: Colors.white,
    );
  }
}