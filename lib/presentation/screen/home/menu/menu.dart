import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/components/walletconnect_c.dart';
import 'package:wallet_apps/constants/db_key_con.dart';
import 'package:wallet_apps/data/service/authen_s.dart';

class Menu extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const Menu({
    Key? key, 
    this.userData
}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu> {
  final MenuModel _menuModel = MenuModel();

  final LocalAuthentication _localAuth = LocalAuthentication();

  /* InitState */
  @override
  void initState() {

    if (kDebugMode) {
    }
    Provider.of<WalletConnectProvider>(context, listen: false).setBuildContext = context;

    readBio();
    checkAvailableBio();
    checkPasscode();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkPasscode() async {
    final res = await StorageServices.readSecure(DbKey.pin);
    if (res != '') {
      setState(() {
        _menuModel.switchPasscode = true;
      });
    }
  }

  Future<void> checkAvailableBio() async {
    await StorageServices.fetchData(DbKey.biometric).then(
      (value) {
        if (value != null) {
          if (value['bio'] == true) {
            setState(() {
              _menuModel.switchBio = value['bio'] as bool;
            });
          }
        }
      },
    );
  }

  Future<void> readBio() async {
    await StorageServices.readSaveBio().then((value) {
      setState(() {
        _menuModel.switchBio = value;
      });
    });
  }

  Future<void> switchBiometric(BuildContext context, bool switchValue) async {
    
    final canCheck = await AppServices().checkBiometrics(context);
    try {
      // Avaible To
      if (canCheck) {
        await BioAuth().authenticateBiometric(_localAuth).then((values) async {
          
          _menuModel.authenticated = values;
          if (_menuModel.authenticated!) {
            _menuModel.switchBio = switchValue;
            await StorageServices.saveBio(_menuModel.switchBio);
          } else if (_menuModel.authenticated!) {
            _menuModel.switchBio = switchValue;
            await StorageServices.removeKey(DbKey.bio);
          }
          setState(() { });
        });
      } else {
        if(!mounted) return;
        snackBar(context, "Your device doesn't have finger debugPrint! Set up to enable this feature");
      }
    } catch (e) {
      if(!mounted) return;
      await DialogComponents().customDialog(context, 'Oops', e.toString(), txtButton: "Close",);
    }
  }

  void enablePassword(bool value, {String? data}) async {
    
    _menuModel.switchPasscode = !_menuModel.switchPasscode;
    if (_menuModel.switchPasscode){
      await StorageServices.writeSecure(DbKey.pin, data!);
    } else {
      await StorageServices.clearKeySecure(DbKey.pin);
    }
    // debugPrint("passcode: ${_menuModel.}")

    setState(() {});
  }

  void switchTheme(bool value) async {
    
    // Provider.of<ThemeProvider>(context, listen: false).setTheme = value;
    // await Provider.of<ThemeProvider>(context, listen: false).changeMode();
    // setState(() {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: MenuBody(
            userInfo: widget.userData,
            model: _menuModel,
            enablePassword: enablePassword,
            switchBio: switchBiometric,
            switchTheme: switchTheme,
          ),
        ),
      ),
    );
  }
}
