import 'package:wallet_apps/index.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WelcomeState();
  }
}

class WelcomeState extends State<Welcome> {

  bool? status;
  int? currentVersion;

  //var snackBar;

  @override
  void initState() {
    // inAppUpdate();
    AppServices.noInternetConnection(context: context);
    super.initState();
  }
  
  // Future<void> inAppUpdate() async {
  //   AppUpdate appUpdate = AppUpdate();
  //   final result = await appUpdate.checkUpdate();
  //   if (result.availableVersionCode == 1){
  //     await appUpdate.performImmediateUpdate();
  //     await InAppUpdate.completeFlexibleUpdate();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      body: SafeArea(child: WelcomeBody()),
    );
  }
}
