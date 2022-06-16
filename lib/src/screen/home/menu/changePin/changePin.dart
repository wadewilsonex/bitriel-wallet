import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:vibration/vibration.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/components/passcode/body_passcode.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/create_seeds/create_seeds.dart';

class ChangePin extends StatefulWidget {
  //static const route = '/passcode';

  @override
  ChangePinState createState() => ChangePinState();
}

class ChangePinState extends State<ChangePin> {

  String titleStatus = "Old PassCode";
  String subStatus = "Please fill your old passcode";

  List<String> lsMessage = [
    'Old PassCode',
    'New PassCode',
    'Invalid PassCode',
    "Please fill correct passcode",
    'Please fill your old passcode',
    'Please fill your new passcode',
  ];

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

  String? oldPass;
  String? newPass;

  bool? isFirst;

  bool? is4digits = false;
  bool? isNewPass = false;

  List<String> currentPin = ["", "", "", "", "", ""];

  @override
  void initState() {
    titleStatus = lsMessage[0];
    subStatus = lsMessage[4];
    StorageServices().readSecure(DbKey.passcode)!.then((value) => res = value);
    isFirst = true;
    super.initState();
  }

  @override
  void dispose(){

    clearAll();
    isFirst = false;

    super.dispose();
  }
  
  void init4Digits() {
    currentPin = ["", "", "", ""];
    List<TextEditingController> lsControl = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];
  }

  void init6Digits() {
    currentPin = ["", "", "", "", "", ""];
    List<TextEditingController> lsControl = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];
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

        dialogLoading(context);

        String str = '';

        lsControl.forEach((element) {
          str+= element.text;
        });
        
        // if (widget.label == PassCodeLabel.fromSplash) {
        //   dialogLoading(context);
        //   await passcodeAuth(strPin);
        // } else {
          
        await setVerifyPin(str);
        //   // await clearVerifyPin(strPin);
        // }
      }
    }
  }

  Future<void> clearVerifyPin(String pin) async {
    if (oldPass == null) {
      oldPass = pin;

      clearAll();

      setState(() {
        isFirst = false;
      });
    } else {
      if (oldPass == pin) {
        await StorageServices().clearKeySecure(DbKey.passcode);
        // Navigator.pop(context, false);
      } else {
        clearAll();
        Vibration.vibrate(amplitude: 500);
      }
    }
  }

  Future<void> setVerifyPin(String pin) async {
    if (oldPass == null) {
      await Provider.of<ApiProvider>(context, listen: false).apiKeyring.checkPassword(Provider.of<ApiProvider>(context, listen: false).getKeyring.keyPairs[0], pin).then((bool? value) {
        Navigator.pop(context);
        if (value == true){

          oldPass = pin;
          titleStatus = lsMessage[1];
          subStatus = lsMessage[5];

          setState(() {
            isNewPass = true;
            isFirst = false;
          });
        } else {
          Vibration.vibrate(amplitude: 500);
          titleStatus = lsMessage[2];
          subStatus = lsMessage[3];

          setState(() { });
        }
        clearAll();
      });
      
    } else {
      newPass = pin;

      await _changePin();

      // if (oldPass == newPass) {

      //   // await StorageServices().writeSecure(DbKey.passcode, pin);

      //   clearAll();
      //   // else if (widget.label == "fromMenu"){
      //   //   if(res == null){
              
      //   //   }
      //   //   else{ 
      //   //     await StorageServices().clearKeySecure(DbKey.passcode);
      //   //     Navigator.pop(context, true);
      //   //   }
      //   // }

      // } else {
      //   clearAll();
      // }
    }
  }

  void clearAll() {
    for (int i = 0; i < lsControl.length; i++) {
      clearPin();
    }
  }

  void onPressedDigit() {
    setState(() {
      clearAll();
      is4digits = !is4digits!;
      is4digits == true ? init4Digits() : init6Digits();
    });
  }
  
  void onSubmitChangePin() async{
    await submitChangePin();
  }

  Future<void> submitChangePin() async {
    // if (_accountModel.oldPassController.text.isNotEmpty && _accountModel.newPassController.text.isNotEmpty) {
    //   await _changePin(_accountModel.oldPassController.text, _accountModel.newPassController.text);
    // }
  }

  Future<void> _changePin() async {

    // setState(() {
    //   _accountModel.loading = true;
    // });
    dialogLoading(context);
    final res = await Provider.of<ApiProvider>(context, listen: false);
    await res.apiKeyring.changePassword(res.getKeyring, oldPass!, newPass);

    // Close Loading
    Navigator.pop(context);
    await DialogComponents().dialogCustom(
      context: context,
      contents: "You have successfully change passcode",
      textButton: "Complete",
      image: Image.asset("assets/icons/success.png", width: 20.w, height: 10.h),
      btn2: MyGradientButton(
        edgeMargin: const EdgeInsets.only(left: 20, right: 20),
        textButton: "Complete",
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        action: () async {
          Navigator.pop(context);
        },
      )
    );

    oldPass = null;
    newPass = null;
    isFirst = true;
    clearAll();

    // Close Dialog
    Navigator.pop(context);

    // Close PassCode Screen
    Navigator.pop(context);
    // _accountModel.oldPassController.text = '';
    // _accountModel.newPassController.text = '';
    // _accountModel.oldNode.requestFocus();
  }
  
  @override
  Widget build(BuildContext context) {
    return PasscodeBody(
      titleStatus: titleStatus,
      subStatus: subStatus,
      label: PassCodeLabel.fromChangePin, 
      isFirst: isFirst, 
      lsControl: lsControl, 
      pinIndexSetup: pinIndexSetup, 
      clearPin: clearPin,
      isNewPass: isNewPass,
      is4digits: is4digits,  
      onPressedDigit: onPressedDigit
    );
    // Scaffold(
    //   key: globalkey,
    //   body: SizedBox(
    //     height: MediaQuery.of(context).size.height,
    //     child: Column(
    //       children: <Widget>[
    //       ],
    //     ),
    //   ),
    // );
  }
}