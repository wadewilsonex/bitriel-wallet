import 'package:bitriel_wallet/domain/usecases/pin_uc/pin_uc_impl.dart';
import 'package:bitriel_wallet/index.dart';
// import 'package:vibration/vibration.dart';
// import 'package:wallet_apps/constants/db_key_con.dart';
// import 'package:wallet_apps/presentation/components/pincode/body_pin.dart';
// import 'package:wallet_apps/presentation/screen/home/home/home.dart';
// import 'package:wallet_apps/presentation/screen/auth/seeds/create_seeds/create_seeds.dart';

enum PinCodeLabel {
  fromSplash,
  fromCreateSeeds,
  fromImportSeeds,
  fromSendTx,
  fromMenu,
  fromChangePin,
  fromBackUp,
  fromAccount,
  fromSignMessage
}

class Pincode extends StatefulWidget {

  final PinCodeLabel? label;
  final bool? isAppBar;
  const Pincode({
    Key? key, 
    this.isAppBar = false, 
    this.label
  }) : super(key: key);
  //static const route = '/passcode';

  @override
  PincodeState createState() => PincodeState();
}

class PincodeState extends State<Pincode> {

//   dynamic res;
//   List<ValueNotifier<String>> lsControl = [
//     ValueNotifier(''),
//     ValueNotifier(''),
//     ValueNotifier(''),
//     ValueNotifier(''),
//     ValueNotifier(''),
//     ValueNotifier(''),
//   ];

  PinUsecaseImpl pinUsecaseImpl = PinUsecaseImpl();

  final localAuth = LocalAuthentication();

//   int pinIndex = 0;

//   String? firstPin;

//   // ValueNotifier<bool>? valueChange[1].value<bool>(true);

//   // bool? valueChange.value[0] = false;

//   /// [0] = is4Digit;
//   /// 
//   /// [1] = isFirstPin
//   List<ValueNotifier<bool?>> valueChange = [
//     ValueNotifier(false),
//     ValueNotifier(true)
//   ];

//   List<String> currentPin = ["", "", "", "", "", ""];
  
//   List<ValueNotifier<String>>  init4Digits() {
//     currentPin = ["", "", "", ""];
//     return lsControl = [
//       ValueNotifier(''),
//       ValueNotifier(''),
//       ValueNotifier(''),
//       ValueNotifier('')
//     ];
//   }

//   List<ValueNotifier<String>> init6Digits() {
//     currentPin = ["", "", "", "", "", ""];
//     return lsControl = [
//       ValueNotifier(''),
//       ValueNotifier(''),
//       ValueNotifier(''),
//       ValueNotifier(''),
//       ValueNotifier(''),
//       ValueNotifier(''),
//     ];
//   }

//   @override
//   void initState() {
//     // StorageServices.readSecure(DbKey.pin)!.then((value) => res = value);
//     // authToHome();
//     super.initState();
//   }

//   @override
//   void dispose(){

//     clearAll();
//     valueChange[1].value = true;

//     super.dispose();
//   }

//   void clearPin() {
//     if (pinIndex == 0) {
//       pinIndex = 0;
//     } else if (pinIndex == (valueChange[0].value! ? 4 : 6)) {
//       lsControl[pinIndex-1].value = "";
//       pinIndex--;
//     } else {
//       lsControl[pinIndex-1].value = "";
//       currentPin[pinIndex - 1] = "";
//       pinIndex--;
//     }
//   }

//   Future<void> pinIndexSetup(String text) async {
//     if (pinIndex == 0) {
//       // Add Selected PIN into List PIN
//       lsControl[pinIndex].value = text;
//       pinIndex = 1;
//     } 
//     else if (pinIndex < (valueChange[0].value! ? 4 : 6)) {
//       // Add Selected PIN into List PIN
//       lsControl[pinIndex].value = text;
//       ++pinIndex;

//       if (pinIndex == (valueChange[0].value! ? 4 : 6)){
        
//         String strPin = "";

//         strPin = lsControl.map((e) {
//           return e.value;
//         }).toList().join();

//         if (widget.label == PinCodeLabel.fromSplash) {
//           dialogLoading(context);
//           await passcodeAuth(strPin);
//         } else {
//           await setVerifyPin(strPin);
//         }
//       }
//     }
//   }

//   Future<void> clearVerifyPin(String pin) async {
//     if (firstPin == null) {
//       firstPin = pin;

//       clearAll();

//       valueChange[1].value = false;
//     } else {
//       if (firstPin == pin) {
//         await StorageServices.clearKeySecure(DbKey.pin);
//         // Navigator.pop(context, false);
//       } else {
//         clearAll();
//         Vibration.vibrate(amplitude: 500);
//       }
//     }
//   }

//   Future<void> setVerifyPin(String pin) async {
//     print("setVerifyPin");
//     if (firstPin == null) {

//       firstPin = pin;

//       clearAll();

//       if (
//         widget.label == PinCodeLabel.fromSendTx || 
//         widget.label == PinCodeLabel.fromBackUp ||
//         widget.label == PinCodeLabel.fromSignMessage
//         ){
//         Navigator.pop(context, pin);
//       } else
//       if (widget.label == PinCodeLabel.fromMenu) {
//         Navigator.pop(context, true);
//       }
      
//       print("valueChange[1].value ${valueChange[1].value}");
//       valueChange[1].value = false;
      
//     } else {
      
//       if (firstPin == pin) {
//         await StorageServices.readSecure(DbKey.pin)!.then((value) async {
//           if (value == ""){
//             await StorageServices.writeSecure(DbKey.pin, pin);
//           }
//         });

//         clearAll();
//         if (widget.label == PinCodeLabel.fromCreateSeeds){

//           if(!mounted) return;
//           Navigator.push(
//             context, 
//             Transition(
//               child: CreateSeeds(passCode: pin, newAcc: null,),
//               transitionEffect: TransitionEffect.RIGHT_TO_LEFT
//             )
//           );
//         } else if (widget.label == PinCodeLabel.fromImportSeeds){
          
//           if(!mounted) return;
//           Navigator.push(
//             context, 
//             Transition(
//               // ignore: missing_required_param
//               child: ImportAcc(passCode: pin),
//               transitionEffect: TransitionEffect.RIGHT_TO_LEFT
//             )
//           );
//         }
//         else if (widget.label == PinCodeLabel.fromAccount){

//           // ignore: use_build_context_synchronously
//           Navigator.pop(context, pin);
//         } 
//         else {
//           if(!mounted) return;
//           Navigator.pop(context, true);
//         }

//       } else {
//         clearAll();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: MyTextConstant(text: "Pin does not match", textAlign: TextAlign.start, color2: Colors.white,))
//         );
//         Vibration.vibrate(amplitude: 500);
//       }
//     }
//   }

//   void clearAll() {
//     for (int i = 0; i < lsControl.length; i++) {
//       clearPin();
//     }
//   }

//   Future<void> authToHome() async {
    
//     if (widget.label.toString() == "fromSplash") {
//       final bio = await StorageServices.readSaveBio();
//       if (bio) {
//         await authenticate();
//       }
//     }
//   }



  @override
  Widget build(BuildContext context) {
    return Container();
//     return PincodeBody(
//       label: widget.label, 
//       valueChange: valueChange,
//       lsControl: lsControl, 
//       pinIndexSetup: pinIndexSetup, 
//       clearPin: clearPin,
//       onPressedDigit: onPressedDigit
//     );
  }
}