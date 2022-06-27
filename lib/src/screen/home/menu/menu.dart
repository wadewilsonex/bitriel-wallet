import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/walletConnect_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/service/authen_s.dart';

class Menu extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const Menu({
    this.userData
});

  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu> {
  final MenuModel _menuModel = MenuModel();

  final LocalAuthentication _localAuth = LocalAuthentication();

  /* Login Inside Dialog */
  bool isDarkTheme = false;

  /* InitState */
  @override
  void initState() {
    _menuModel.globalKey = GlobalKey<ScaffoldState>();

    Provider.of<WalletConnectComponent>(context, listen: false).setBuildContext = context;

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
    final res = await StorageServices().readSecure(DbKey.passcode);
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
      print("My bio $value");
      setState(() {
        _menuModel.switchBio = value;
      });
    });
  }

  // ignore: avoid_positional_boolean_parameters
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
        snackBar(context, "Your device doesn't have finger print! Set up to enable this feature");
      }
    } catch (e) {
      await customDialog(context, 'Oops', e.toString());
    }
  }

  void enablePassword(bool value, {String? data}) async {
    
    _menuModel.switchPasscode = !_menuModel.switchPasscode;
    if (_menuModel.switchPasscode){
      await StorageServices().writeSecure(DbKey.passcode, data!);
    } else {
      await StorageServices().clearKeySecure(DbKey.passcode);
    }
    // print("passcode: ${_menuModel.}")

    setState(() {});
  }

  /* ----------------------Side Bar -------------------------*/

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context, listen: false).isDark;
    return Drawer(
      key: _menuModel.globalKey,
      child: SafeArea(
        child: Container(
          color: isDarkTheme
            ? hexaCodeToColor(AppColors.darkBgd)
            : hexaCodeToColor(AppColors.lowWhite),
          child: SingleChildScrollView(
            child: MenuBody(
              userInfo: widget.userData,
              model: _menuModel,
              enablePassword: enablePassword,
              switchBio: switchBiometric
            ),
          ),
        ),
      ),
    );
  }
}
