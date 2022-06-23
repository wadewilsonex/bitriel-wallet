import 'package:in_app_update/in_app_update.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';

class Welcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomeState();
  }
}

class WelcomeState extends State<Welcome> {
  
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  bool? status;
  int? currentVersion;

  //var snackBar;

  @override
  void initState() {
    // inAppUpdate();
    AppServices.noInternetConnection(globalKey);
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
      key: globalKey,
      body: WelcomeBody(),
    );
  }
}
