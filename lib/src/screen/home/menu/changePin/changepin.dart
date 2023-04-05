import 'package:wallet_apps/index.dart';
import 'package:vibration/vibration.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/components/passcode/body_passcode.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

class ChangePin extends StatefulWidget {
  const ChangePin({Key? key}) : super(key: key);

  //static const route = '/passcode';

  @override
  ChangePinState createState() => ChangePinState();
}

class ChangePinState extends State<ChangePin> {

  String titleStatus = "Old PIN";
  String subStatus = "Please fill your old PIN";

  List<String> lsMessage = [
    'Old PIN',
    'New PIN',
    'Invalid PIN',
    "Please fill correct PIN",
    'Please fill your old PIN',
    'Please fill your new PIN',
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

  ApiProvider? _apiProvider;

  @override
  void initState() {
    
    titleStatus = lsMessage[0];
    subStatus = lsMessage[4];
    _apiProvider = Provider.of<ApiProvider>(context, listen: false);
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
  
  List<TextEditingController> init4Digits() {
    currentPin = ["", "", "", ""];
    return [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];
  }

  List<TextEditingController> init6Digits() {
    currentPin = ["", "", "", "", "", ""];
    return [
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

        for (var element in lsControl) {
          str+= element.text;
        }
        
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
      await Provider.of<ApiProvider>(context, listen: false).getSdk.api.keyring.checkPassword(Provider.of<ApiProvider>(context, listen: false).getKeyring.keyPairs[0], pin).then((bool? value) {
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
    final res = Provider.of<ApiProvider>(context, listen: false);
    await res.getSdk.api.keyring.changePassword(res.getKeyring, res.getKeyring.current, oldPass!, newPass);

    await _updatePkWithNewPass();

    // Close Loading
    if(!mounted) return;
    Navigator.pop(context);
    await DialogComponents().dialogCustom(
      context: context,
      contents: "You have successfully change PIN",
      textButton: "Complete",
      image: Image.asset("assets/icons/success.png", width: 20, height: 10),
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
    if(!mounted) return;
    Navigator.pop(context);

    // Close PassCode Screen
    Navigator.pop(context);
    // _accountModel.oldPassController.text = '';
    // _accountModel.newPassController.text = '';
    // _accountModel.oldNode.requestFocus();
  }

  Future<void> _updatePkWithNewPass() async {
    try {

      // await StorageServices().writeSecure(DbKey.passcode, newPass!);
      // Get Seeds From Decrypt
      final seeds = await KeyringPrivateStore([_apiProvider!.isMainnet ? AppConfig.networkList[0].ss58MN! : AppConfig.networkList[0].ss58!]).getDecryptedSeed(_apiProvider!.getKeyring.keyPairs[0].pubKey, oldPass);

      // Get Private Key _resPk
      final resPk = await _apiProvider!.getPrivateKey(seeds!['seed']);

      // Re-Encrypt Private Key
      final res = await _apiProvider!.encryptPrivateKey(resPk, newPass!);
      
      await StorageServices().writeSecure(DbKey.private, res);

      await StorageServices().writeSecure(DbKey.passcode, newPass!);
      // final _encrypt = await Provider.of<ApiProvider>(context, listen: false).getPrivateKey(seeds['seed']);


    } catch (e){
      
      if (kDebugMode) {
        print("Error _updatePkWithNewPass $e");
      }
    } 
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
  }
}