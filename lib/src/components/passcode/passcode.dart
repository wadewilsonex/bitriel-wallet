import 'package:wallet_apps/index.dart';
import 'package:vibration/vibration.dart';
import 'package:wallet_apps/src/components/passcode/body_passcode.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/seeds/create_seeds/create_seeds.dart';

enum PassCodeLabel {
  fromSplash,
  fromCreateSeeds,
  fromImportSeeds,
  fromSendTx,
  fromMenu,
  fromChangePin,
  fromBackUp
}

class Passcode extends StatefulWidget {

  final PassCodeLabel? label;
  final bool? isAppBar;
  const Passcode({
    Key? key, 
    this.isAppBar = false, 
    this.label
  }) : super(key: key);
  //static const route = '/passcode';

  @override
  PasscodeState createState() => PasscodeState();
}

class PasscodeState extends State<Passcode> {

  dynamic res;
  List<TextEditingController> lsControl = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final localAuth = LocalAuthentication();

  GlobalKey<ScaffoldState>? globalkey;

  int pinIndex = 0;

  String? firstPin;

  bool? isFirst;

  bool? is4digits = false;

  List<String> currentPin = ["", "", "", "", "", ""];
  
  List<TextEditingController>  init4Digits() {
    currentPin = ["", "", "", ""];
    return lsControl = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];
  }

  List<TextEditingController>  init6Digits() {
    currentPin = ["", "", "", "", "", ""];
    return lsControl = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];
  }

  @override
  void initState() {
    StorageServices().readSecure(DbKey.passcode)!.then((value) => res = value);
    authToHome();
    isFirst = true;
    super.initState();
  }

  void clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == (is4digits! ? 4 : 6)) {
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
    isFirst = false;

    super.dispose();
  }

  Future<void> pinIndexSetup(String text) async {
    if (pinIndex == 0) {
      // Add Selected PIN into List PIN
      lsControl[pinIndex].text = text;
      pinIndex = 1;
    } else if (pinIndex < (is4digits! ? 4 : 6)) {
      // Add Selected PIN into List PIN
      lsControl[pinIndex].text = text;
      ++pinIndex;

      if (pinIndex == (is4digits! ? 4 : 6)){
        
        String strPin = "";

        for (int i = 0; i < lsControl.length; i++){
          strPin += lsControl[i].text;
        }
        
        if (widget.label == PassCodeLabel.fromSplash) {
          dialogLoading(context);
          await passcodeAuth(strPin);
        } else {
          await setVerifyPin(strPin);
        }
      }
    }
  }

  Future<void> clearVerifyPin(String pin) async {
    if (firstPin == null) {
      firstPin = pin;

      clearAll();

      setState(() {
        isFirst = false;
      });
    } else {
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
    if (firstPin == null) {
      firstPin = pin;

      clearAll();
      setState(() {
        isFirst = false;
      });

      if (widget.label == PassCodeLabel.fromSendTx || widget.label == PassCodeLabel.fromBackUp){
        Navigator.pop(context, pin);
      }
      if (widget.label == PassCodeLabel.fromMenu) {
        Navigator.pop(context, true);
      }
      
      if (mounted) {
        setState(() {
          isFirst = false;
        });
      }
      
    } else {
      if (firstPin == pin) {
        await StorageServices().readSecure(DbKey.passcode)!.then((value) async {
          if (value == ""){
            await StorageServices().writeSecure(DbKey.passcode, pin);
          }
        });

        clearAll();
        if (widget.label == PassCodeLabel.fromCreateSeeds){

          if(!mounted) return;
          Navigator.push(
            context, 
            Transition(
              child: const CreateSeeds(),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            )
          );
        } else if (widget.label == PassCodeLabel.fromImportSeeds){
          
          if(!mounted) return;
          Navigator.push(
            context, 
            Transition(
              child: const ImportAcc(),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            )
          );
        } else {
          if(!mounted) return;
          Navigator.pop(context, true);
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
    if (widget.label.toString() == "fromSplash") {
      final bio = await StorageServices.readSaveBio();
      if (bio) {
        await authenticate();
      }
    }
  }

  Future<void> readBackUpKey(String pin) async {
    final res = await StorageServices().readSecure(DbKey.passcode);

    if(widget.label.toString() == "backup"){
      if (res == pin) {
        if(!mounted) return;
        Navigator.of(context).pop();
      } else {
        clearAll();
        Vibration.vibrate(amplitude: 500);
      }
    }
  }


  // Check User Had Set PassCode
  Future<void> passcodeAuth(String pin) async {
    final res = await StorageServices().readSecure(DbKey.passcode);

    if (res == pin) {
      if(!mounted) return;
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
        if(!mounted) return;
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
            title: const Align(
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

  void onPressedDigit() {
    setState(() {
      clearAll();
      is4digits = !is4digits!;
      is4digits == true ? init4Digits() : init6Digits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PasscodeBody(
      label: widget.label, 
      isFirst: isFirst, 
      lsControl: lsControl, 
      pinIndexSetup: pinIndexSetup, 
      clearPin: clearPin,
      is4digits: is4digits,  
      onPressedDigit: onPressedDigit
    );
  }
}