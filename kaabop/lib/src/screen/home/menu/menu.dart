import 'package:wallet_apps/index.dart';

class Menu extends StatefulWidget {
  final Map<String, dynamic> _userData;

  const Menu(
    this._userData,
  );

  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu> {
  final MenuModel _menuModel = MenuModel();

  LocalAuthentication _localAuth = LocalAuthentication();

  /* Login Inside Dialog */
  bool isProgress = false,
      isFetch = false,
      isTick = false,
      isSuccessPin = false,
      isHaveWallet = false;

  /* InitState */
  @override
  void initState() {
    _menuModel.globalKey = GlobalKey<ScaffoldState>();
    //AppServices.noInternetConnection(_menuModel.globalKey);

    readBio();
    checkAvailableBio();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkAvailableBio() async {
    await StorageServices.fetchData('biometric').then(
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

  Future<bool> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await _localAuth.canCheckBiometrics;
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
    }

    return canCheckBiometrics;
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> switchBiometric(bool switchValue) async {
    final canCheck = await _checkBiometrics();

    if (canCheck == false) {
      snackBar(_menuModel.globalKey, "Your device doesn't have finger print");
    } else {
      if (switchValue) {
        await authenticateBiometric().then((values) async {
          //print('value 1: $values');
          if (_menuModel.authenticated) {
            setState(() {
              _menuModel.switchBio = switchValue;
            });
            await StorageServices.saveBio(_menuModel.switchBio);
          }
        });
      } else {
        await authenticateBiometric().then((values) async {
          if (_menuModel.authenticated) {
            setState(() {
              _menuModel.switchBio = switchValue;
            });
            await StorageServices.removeKey('bio');
          }
        });
      }
    }

    // await _localAuth.canCheckBiometrics.then((value) async {
    //   print(' valu: $value');
    //   // if (value == false) {
    //   //   snackBar(_menuModel.globalKey, "Your device doesn't have finger print");
    //   // } else {
    //   //   if (switchValue) {
    //   //     await authenticateBiometric(_localAuth).then((values) async {
    //   //       //print('value 1: $values');
    //   //       if (_menuModel.authenticated) {
    //   //         setState(() {
    //   //           _menuModel.switchBio = switchValue;
    //   //         });
    //   //         await StorageServices.saveBio(_menuModel.switchBio);
    //   //       }
    //   //     });
    //   //   } else {
    //   //     await authenticateBiometric(_localAuth).then((values) async {
    //   //       if (_menuModel.authenticated) {
    //   //         setState(() {
    //   //           _menuModel.switchBio = switchValue;
    //   //         });
    //   //         await StorageServices.removeKey('bio');
    //   //       }
    //   //     });
    //   //   }
    //   // }
    // });
  }

  Future<bool> authenticateBiometric() async {
    try {
      // Trigger Authentication By Finger Print
      // ignore: deprecated_member_use
      _menuModel.authenticated = await _localAuth.authenticateWithBiometrics(
        localizedReason: '',
        stickyAuth: true,
      );

      // ignore: empty_catches
    } on PlatformException {}

    return _menuModel.authenticated;
  }

  /* ----------------------Side Bar -------------------------*/

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: _menuModel.globalKey,
      child: SafeArea(
        child: Container(
            color: hexaCodeToColor(AppColors.bgdColor),
            child: SingleChildScrollView(
                child: MenuBody(
              userInfo: widget._userData,
              model: _menuModel,
              switchBio: switchBiometric,
            ))),
      ),
    );
  }
}