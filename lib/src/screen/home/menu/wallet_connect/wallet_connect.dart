import 'package:wallet_apps/src/components/walletconnect_c.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/menu/wallet_connect/body_walletconnect_page.dart';

class WalletConnectPage extends StatefulWidget {

  const WalletConnectPage({Key? key}) : super(key: key);

  @override
  WalletConnectPageState createState() => WalletConnectPageState();
}

class WalletConnectPageState extends State<WalletConnectPage> {

  bool? isChecked = false;
  bool? checkLogin = true;

  WalletConnectProvider? _wConnectC;
  
  final formKey = GlobalKey<FormState>();

  void handleRememberMe(bool? value) async {
    setState(() {
      isChecked = value;
    });
  }

  void isLogin() async {
    setState(() {
      checkLogin = false;
    });
  }

  void filterListWcSession() async {

    _wConnectC = Provider.of<WalletConnectProvider>(context, listen: false);
    _wConnectC!.setBuildContext = context;
    await StorageServices.fetchData("session").then((value) {
      
      _wConnectC!.fromJsonFilter(List<Map<String, dynamic>>.from(value));
    });
    
  }

  void killSession(int index) async {

    _wConnectC!.wcClient.killSession();
    
    _wConnectC!.lsWcClients.removeAt(index);
    
    List<Map<String, dynamic>> tmpWcSession = [];

    for (var element in _wConnectC!.lsWcClients) {
      tmpWcSession.add(element.toJson());
    }

    await StorageServices.storeData(tmpWcSession, DbKey.wcSession);
    _wConnectC!.afterKill();
  }

  @override
  void initState() {
    filterListWcSession();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WalletConnectBody(
      handleRememberMe: handleRememberMe,
      isChecked: isChecked,
      formKey: formKey,
      killSession: killSession,
    );
  }
}
