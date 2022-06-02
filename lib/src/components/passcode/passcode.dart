import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:vibration/vibration.dart';
import 'package:wallet_apps/src/components/passcode/body_passcode.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/create_seeds/create_seeds.dart';


class Passcode extends StatefulWidget {

  final String? label;
  final bool? isAppBar;
  const Passcode({this.isAppBar = false, required this.label});
  //static const route = '/passcode';

  @override
  _PasscodeState createState() => _PasscodeState();
}

class _PasscodeState extends State<Passcode> {

  dynamic res;
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

    StorageServices().readSecure(DbKey.passcode)!.then((value) => res = value);
    authToHome();
    _isFirst = true;
    super.initState();
  }

  void clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 6) {
      lsControl[pinIndex-1].text = "";
      pinIndex--;
    } else {
      lsControl[pinIndex-1].text = "";
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  @override
  void dispose(){

    clearAll();
    _isFirst = false;

    print("Dispose");
    super.dispose();
  }

  Future<void> pinIndexSetup(String text) async {
    if (pinIndex == 0) {
      // Add Selected PIN into List PIN
      lsControl[pinIndex].text = text;
      pinIndex = 1;
    } else if (pinIndex < 6) {
      // Add Selected PIN into List PIN
      lsControl[pinIndex].text = text;
      ++pinIndex;

      if (pinIndex == 6){
        
        String strPin = "";

        for (int i = 0; i < lsControl.length; i++){
          strPin += lsControl[i].text;
        }
        
        if (widget.label == "fromSplash") {
          dialogLoading(context);
          await passcodeAuth(strPin);
        } else {
          
          await setVerifyPin(strPin);
          // await clearVerifyPin(strPin);
        }
      }
    }
  }

  Future<void> clearVerifyPin(String pin) async {
      print("clearVerifyPin");
    if (firstPin == null) {
      firstPin = pin;

      clearAll();
      setState(() {
        _isFirst = false;
      });
    } else {
      print("firstPin == pin ${firstPin == pin}");
      if (firstPin == pin) {
        await StorageServices().clearKeySecure(DbKey.passcode);
        // Navigator.pop(context, false);
      } else {
        clearAll();
        Vibration.vibrate(amplitude: 500);
      }
    }
  }

  Future<void> setVerifyPin(String pin) async {
    print("setVerifyPin");
    if (firstPin == null) {
      firstPin = pin;

      clearAll();
      setState(() {
        _isFirst = false;
      });
    } else {
      if (firstPin == pin) {

        await StorageServices().writeSecure(DbKey.passcode, pin);

        clearAll();
        if (widget.label == "fromHome" || widget.label == "fromSplash"){
          Navigator.pop(context, true);
        } else if (widget.label == "fromCreateSeeds"){

          Navigator.push(
            context, 
            Transition(
              child: CreateSeeds(),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            )
          );
        } else if (widget.label == "fromImportSeeds"){

          Navigator.push(
            context, 
            Transition(
              child: ImportAcc(),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            )
          );
        }
      } else {
        clearAll();
        Vibration.vibrate(amplitude: 500);
      }
    }
  }

  void clearAll() {
    for (int i = 0; i < lsControl.length; i++) {
      clearPin();
    }
  }

  Future<void> authToHome() async {
    if (widget.label == "fromSplash") {
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
      Navigator.pushAndRemoveUntil(
        context, 
        Transition(child: HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
        ModalRoute.withName('/')
      );
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                  child: PasscodeBody(label: widget.label, isFirst: _isFirst, lsControl: lsControl, pinIndexSetup: pinIndexSetup, clearPin: clearPin,)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
