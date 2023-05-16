import 'package:wallet_apps/index.dart';
import 'package:vibration/vibration.dart';
import 'package:wallet_apps/presentation/components/dialog_c.dart';
import 'package:wallet_apps/presentation/components/pincode/body_pin.dart';
import 'package:wallet_apps/constants/db_key_con.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

class ChangePin extends StatefulWidget {
  final KeyPairData? acc;

  const ChangePin({Key? key, required this.acc}) : super(key: key);

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
  List<ValueNotifier<String>> lsControl = [
    ValueNotifier(""),
    ValueNotifier(""),
    ValueNotifier(""),
    ValueNotifier(""),
    ValueNotifier(""),
    ValueNotifier("")
  ];

  final localAuth = LocalAuthentication();

  int pinIndex = 0;

  String? oldPass;
  String? newPass;

  // ValueNotifier<bool>? isFirst = ValueNotifier<bool>(true);

  /// [0] = is4Digit;
  /// 
  /// [1] = isFirstPin
  ValueNotifier<List<bool?>> valueChange = ValueNotifier([
    false,
    true
  ]);

  bool? isNewPass = false;

  List<String> currentPin = ["", "", "", "", "", ""];

  ApiProvider? _apiProvider;

  @override
  void initState() {
    
    titleStatus = lsMessage[0];
    subStatus = lsMessage[4];
    _apiProvider = Provider.of<ApiProvider>(context, listen: false);
    StorageServices.readSecure(DbKey.pin)!.then((value) => res = value);
    super.initState();
  }

  @override
  void dispose(){

    clearAll();
    valueChange.value[1] = true;

    super.dispose();
  }
  
  List<ValueNotifier<String>> init4Digits() {
    currentPin = ["", "", "", ""];
    return [
      ValueNotifier(""),
      ValueNotifier(""),
      ValueNotifier(""),
      ValueNotifier(""),
    ];
  }

  List<ValueNotifier<String>> init6Digits() {
    currentPin = ["", "", "", "", "", ""];
    return [
      ValueNotifier(""),
      ValueNotifier(""),
      ValueNotifier(""),
      ValueNotifier(""),
      ValueNotifier(""),
      ValueNotifier(""),
    ];
  }

  void clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == (valueChange.value[0]! ? 4 : 6)) {
      lsControl[pinIndex-1].value = "";
      pinIndex--;
    } else {
      lsControl[pinIndex-1].value = "";
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  Future<void> pinIndexSetup(String text) async {
    if (pinIndex == 0) {
      // Add Selected PIN into List PIN
      lsControl[pinIndex].value = text;
      pinIndex = 1;
    } else if (pinIndex < (valueChange.value[0]! ? 4 : 6)) {
      // Add Selected PIN into List PIN
      lsControl[pinIndex].value = text;
      ++pinIndex;

      if (pinIndex == (valueChange.value[0]! ? 4 : 6)){

        dialogLoading(context);

        String str = '';

        for (var element in lsControl) {
          str+= element.value;
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

      valueChange.value[1] = false;
    } else {
      if (oldPass == pin) {
        await StorageServices.clearKeySecure(DbKey.pin);
        // Navigator.pop(context, false);
      } else {
        clearAll();
        Vibration.vibrate(amplitude: 500);
      }
    }
  }

  Future<void> setVerifyPin(String pin) async {
    if (oldPass == null) {
      await Provider.of<ApiProvider>(context, listen: false).getSdk.api.keyring.checkPassword(widget.acc!, pin).then((bool? value) {
        Navigator.pop(context);
        if (value == true){

          oldPass = pin;
          titleStatus = lsMessage[1];
          subStatus = lsMessage[5];

          isNewPass = true;
          valueChange.value[1] = false;
          
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

      //   // await StorageServices.writeSecure(DbKey.passcode, pin);

      //   clearAll();
      //   // else if (widget.label == "fromMenu"){
      //   //   if(res == null){
              
      //   //   }
      //   //   else{ 
      //   //     await StorageServices.clearKeySecure(DbKey.passcode);
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
    valueChange.value[0] = !valueChange.value[0]!;
    valueChange.value[0] == true ? init4Digits() : init6Digits();
    // setState(() {
      clearAll();
    // });
  }
  
  void onSubmitChangePin() async{
    await submitChangePin();
  }

  Future<void> submitChangePin() async {
    // if (_accountModel.oldPassController.value.isNotEmpty && _accountModel.newPassController.value.isNotEmpty) {
    //   await _changePin(_accountModel.oldPassController.value, _accountModel.newPassController.value);
    // }
  }

  Future<void> _changePin() async {
    
    dialogLoading(context);
    final res = Provider.of<ApiProvider>(context, listen: false);
    final AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    await res.getSdk.api.keyring.changePassword(res.getKeyring, res.getKeyring.current, oldPass!, newPass);

    await _updatePkWithNewPass();

    // Close Loading
    if(!mounted) return;
    Navigator.pop(context);
    await DialogComponents().dialogCustom(
      context: context,
      contents: "You have successfully change PIN",
      textButton: "Complete",
      image: Image.file(File("${appProvider.dirPath}/icons/success.png"), width: 20, height: 10),
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
    valueChange.value[1] = true;
    clearAll();

    // Close Dialog
    if(!mounted) return;
    Navigator.pop(context);

    // Close PassCode Screen
    Navigator.pop(context);
    
  }

  Future<void> _updatePkWithNewPass() async {
    try {

      // Get Seeds From Decrypt
      final seeds = await _apiProvider!.getKeyring.store.getDecryptedSeed(widget.acc!.pubKey, oldPass);

      // Get Private Key _resPk
      final resPk = await _apiProvider!.getPrivateKey(seeds!['seed']);

      // Re-Encrypt Private Key
      final res = await _apiProvider!.encryptPrivateKey(resPk, newPass!);
      
      await StorageServices.writeSecure(DbKey.private, res);

      await StorageServices.writeSecure(DbKey.pin, newPass!);
      // final _encrypt = await Provider.of<ApiProvider>(context, listen: false).getPrivateKey(seeds['seed']);


    } catch (e){
      
      if (kDebugMode) {
        
      }
    } 
  }
  
  @override
  Widget build(BuildContext context) {
    return PincodeBody(
      titleStatus: titleStatus,
      subStatus: subStatus,
      label: PinCodeLabel.fromChangePin, 
      // isFirst: isFirst, 
      // is4digits: is4digits,  
      // lsControl: lsControl, 
      pinIndexSetup: pinIndexSetup, 
      clearPin: clearPin,
      isNewPass: isNewPass,
      onPressedDigit: onPressedDigit
    );
  }
}