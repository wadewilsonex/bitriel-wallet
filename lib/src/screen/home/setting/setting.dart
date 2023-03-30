import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/setting/body_setting.dart';
import 'package:wallet_apps/src/service/authen_s.dart';

import '../../../../../index.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  final MenuModel _menuModel = MenuModel();

  final LocalAuthentication _localAuth = LocalAuthentication();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  // Future<void> checkPasscode() async {
  //   final res = await StorageServices().readSecure(DbKey.passcode);
  //   if (res != '') {
  //     setState(() {
  //       _menuModel.switchPasscode = true;
  //     });
  //   }
  // }

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
        snackBar(context, "Your device doesn't have finger print! Set up to enable this feature");
      }
    } catch (e) {
      if(!mounted) return;
      await customDialog(context, 'Oops', e.toString());
    }
  }

  // void enablePassword(bool value, {String? data}) async {
    
  //   _menuModel.switchPasscode = !_menuModel.switchPasscode;
  //   if (_menuModel.switchPasscode){
  //     await StorageServices().writeSecure(DbKey.passcode, data!);
  //   } else {
  //     await StorageServices().clearKeySecure(DbKey.passcode);
  //   }
  //   // print("passcode: ${_menuModel.}")

  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    
    // _menuModel.globalKey = GlobalKey<ScaffoldState>();

    _initPackageInfo();

    readBio();
    checkAvailableBio();
    // checkPasscode();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BodySettingPage(
      packageInfo: _packageInfo,
      model: _menuModel,
      switchBio: switchBiometric,
    );
  }
}
