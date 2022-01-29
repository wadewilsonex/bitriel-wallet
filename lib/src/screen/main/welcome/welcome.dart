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
    AppServices.noInternetConnection(globalKey);
    StorageServices.fetchAsset(DbKey.listContract).then((value) {
      print("Welcome ls contract $value");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: BodyScaffold(
        isSafeArea: true,
        bottom: 0,
        child: WelcomeBody(),
      ),
    );
  }
}
