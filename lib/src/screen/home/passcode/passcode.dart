import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:vibration/vibration.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/passcode/body_passcode.dart';


class Passcode extends StatefulWidget {

  final String? isHome;
  final bool? isAppBar;
  const Passcode({this.isAppBar = false, this.isHome});
  //static const route = '/passcode';

  @override
  _PasscodeState createState() => _PasscodeState();
}

class _PasscodeState extends State<Passcode> {

  List<TextEditingController> lsControl = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  
  // final TextEditingController pinOneController = TextEditingController();

  // final TextEditingController pinTwoController = TextEditingController();

  // final TextEditingController pinThreeController = TextEditingController();

  // final TextEditingController pinFourController = TextEditingController();

  // final TextEditingController pinFiveController = TextEditingController();

  // final TextEditingController pinSixController = TextEditingController();

  final localAuth = LocalAuthentication();

  GlobalKey<ScaffoldState>? globalkey;

  int pinIndex = 0;

  String? firstPin;

  bool? _isFirst;

  List<String> currentPin = ["", "", "", "", "", ""];

  @override
  void initState() {
    authToHome();
    _isFirst = true;
    super.initState();
  }

  void clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 6) {
      setPin(pinIndex, "");
      pinIndex--;
    } else {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  Future<void> pinIndexSetup(String text) async {

    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 6) {
      pinIndex++;
    }

    setPin(pinIndex, text);
    currentPin[pinIndex - 1] = text;
    String strPin = "";

    for (int i = 0; i<currentPin.length; i++){
      strPin += currentPin[i];
    }
    
    print("pinIndex lengh $pinIndex");
    if (pinIndex == 6) {
      final res = await StorageServices().readSecure(DbKey.passcode);
      if (widget.isHome != null) {
        dialogLoading(context);
        await passcodeAuth(strPin);
      } else {
        if (res == '') {
          await setVerifyPin(strPin);
        } else {
          await clearVerifyPin(strPin);
        }
      }
    }
  }

  Future<void> clearVerifyPin(String pin) async {
    if (firstPin == null) {
      firstPin = pin;

      clearAll();
      setState(() {
        _isFirst = false;
      });
    } else {
      if (firstPin == pin) {
        await StorageServices().clearKeySecure(DbKey.passcode);
        Navigator.pop(context, false);
      } else {
        clearAll();
        Vibration.vibrate(amplitude: 500);
      }
    }
  }

  Future<void> setVerifyPin(String pin) async {
    if (firstPin == null) {
      firstPin = pin;

      clearAll();
      setState(() {
        _isFirst = false;
      });
    } else {
      if (firstPin == pin) {
        print ("Set pin");
        await StorageServices().writeSecure(DbKey.passcode, pin);
        Navigator.pop(context, true);
      } else {
        clearAll();
        Vibration.vibrate(amplitude: 500);
      }
    }
  }

  void clearAll() {
    for (int i = 0; i < 6; i++) {
      clearPin();
    }
  }

  void setPin(int n, String text) {
    switch (n) {
      case 1:
        lsControl[0].text = text;
        break;
      case 2:
        lsControl[1].text = text;
        break;
      case 3:
        lsControl[2].text = text;
        break;
      case 4:
        lsControl[3].text = text;
        break;
      case 5:
        lsControl[4].text = text;
        break;
      case 6:
        lsControl[5].text = text;
        break;
    }
  }

  Future<void> authToHome() async {
    if (widget.isHome != null) {
      final bio = await StorageServices.readSaveBio();
      if (bio) {
        await authenticate();
      }
    }
  }

  // Check User Had Set PassCode
  Future<void> passcodeAuth(String pin) async {
    final res = await StorageServices().readSecure(DbKey.passcode);

    if (res == pin) {
      Navigator.pushReplacementNamed(context, Home.route);
    } else {
      clearAll();
      Vibration.vibrate(amplitude: 500);
    }
  }

  Future<void> authenticate() async {
    bool authenticate = false;

    try {
      authenticate = await localAuth.authenticate(
        localizedReason: '',
        stickyAuth: true,
      );

      if (authenticate) {
        // Pop With Data For Refresh Menu 
        Navigator.pop(context, true);
      }
    } on SocketException catch (e) {
      await Future.delayed(const Duration(milliseconds: 300), () {});
      AppServices.openSnackBar(globalkey!, e.message);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: Text('Opps'),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text(e.toString()),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalkey,
      body: BodyScaffold(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              children: <Widget>[

                // Show AppBar Only In Landing Pages
                if(widget.isAppBar!) MyAppBar(
                  title: "Set Passcode",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ) 
                else Container(),
                
                Expanded(
                  child: PasscodeBody(isFirst: _isFirst, lsControl: lsControl, pinIndexSetup: pinIndexSetup, clearPin: clearPin,)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
