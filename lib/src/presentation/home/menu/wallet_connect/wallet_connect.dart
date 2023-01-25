import 'package:wallet_apps/src/components/walletconnect_c.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/presentation/home/menu/wallet_connect/body_walletconnect_page.dart';

class WalletConnectPage extends StatefulWidget {

  const WalletConnectPage({Key? key}) : super(key: key);

  @override
  WalletConnectPageState createState() => WalletConnectPageState();
}

class WalletConnectPageState extends State<WalletConnectPage> {

  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();
  bool? isChecked = false;
  bool? checkLogin = true;

  WalletConnectComponent? _wConnectC;
  
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

    _wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);
    _wConnectC!.setBuildContext = context;
    await StorageServices.fetchData("session").then((value) {
      
      _wConnectC!.fromJsonFilter(List<Map<String, dynamic>>.from(value));
    });
    
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
      emailInputController: emailInputController,
      passwordInputController: passwordInputController,
      handleRememberMe: handleRememberMe,
      isChecked: isChecked,
      formKey: formKey,
    );
  }
}
