import 'package:wallet_apps/index.dart';

class AppRouting {
  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    /* Login Screen */
    '/': (context) => Welcome(),
    //Menu({}, _packageInfo, (){}),
    /* Home Screen */
    // '/dashboardScreen': (context) => Home(),
    // '/getWalletScreen': (context) => GetWalletWidget(),
    // '/settingScreen': (context) => SettingWidget(),
    /* Verify User Screen */
    '/add_profile_screen': (context) => AddUserInfo(),
    '/addDocumentScreen': (context) => AddDocuments(),
    '/forgotPasswordScreen': (context) => ForgetPassword()
  };
}
