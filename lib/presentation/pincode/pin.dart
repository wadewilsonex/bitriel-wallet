import 'package:bitriel_wallet/presentation/pincode/pin_body.dart';
import 'package:bitriel_wallet/presentation/widget/text_widget.dart';
import 'package:flutter/material.dart';

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
  const Pincode({Key? key, this.isAppBar = false, this.label})
      : super(key: key);
  //static const route = '/passcode';

  @override
  PincodeState createState() => PincodeState();
}

class PincodeState extends State<Pincode> {
  
  dynamic res;
  List<ValueNotifier<String>> lsControl = [
    ValueNotifier(''),
    ValueNotifier(''),
    ValueNotifier(''),
    ValueNotifier(''),
    ValueNotifier(''),
    ValueNotifier(''),
  ];

  // final localAuth = LocalAuthentication();

  GlobalKey<ScaffoldState>? globalkey;

  int pinIndex = 0;

  String? firstPin;

  // ValueNotifier<bool>? valueChange.value[1]<bool>(true);

  // bool? valueChange.value[0] = false;

  /// [0] = is4Digit;
  ///
  /// [1] = isFirstPin
  ValueNotifier<List<bool?>> valueChange = ValueNotifier([false, true]);

  List<String> currentPin = ["", "", "", "", "", ""];

  List<ValueNotifier<String>> init4Digits() {
    currentPin = ["", "", "", ""];
    return lsControl = [
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier('')
    ];
  }

  List<ValueNotifier<String>> init6Digits() {
    currentPin = ["", "", "", "", "", ""];
    return lsControl = [
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
    ];
  }

  @override
  void initState() {
    // StorageServices.readSecure(DbKey.pin)!.then((value) => res = value);
    authToHome();
    super.initState();
  }

  @override
  void dispose() {
    clearAll();
    valueChange.value[1] = true;

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == (valueChange.value[0]! ? 4 : 6)) {
      lsControl[pinIndex - 1].value = "";
      pinIndex--;
    } else {
      lsControl[pinIndex - 1].value = "";
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  Future<void> pinIndexSetup(String text) async {
    // if (pinIndex == 0) {
    //   // Add Selected PIN into List PIN
    //   lsControl[pinIndex].value = text;
    //   pinIndex = 1;
    // }
    // else
    // if (pinIndex < (valueChange.value[0]! ? 4 : 6)) {
    // Add Selected PIN into List PIN
    lsControl[pinIndex].value = text;
    ++pinIndex;

    //   if (pinIndex == (valueChange.value[0]! ? 4 : 6)){

    //     String strPin = "";

    //     strPin = lsControl.map((e) {
    //       return e.value;
    //     }).toList().join();

    //     if (widget.label == PinCodeLabel.fromSplash) {
    //       dialogLoading(context);
    //       await passcodeAuth(strPin);
    //     } else {
    //       await setVerifyPin(strPin);
    //     }
    //   }
    // }
  }

  Future<void> clearVerifyPin(String pin) async {
    if (firstPin == null) {
      firstPin = pin;

      clearAll();

      valueChange.value[1] = false;
    } else {
      if (firstPin == pin) {
        // await StorageServices.clearKeySecure(DbKey.pin);
        // Navigator.pop(context, false);
      } else {
        clearAll();
        // Vibration.vibrate(amplitude: 500);
      }
    }
  }

  Future<void> setVerifyPin(String pin) async {
    if (firstPin == null) {
      firstPin = pin;

      clearAll();

      if (widget.label == PinCodeLabel.fromSendTx ||
          widget.label == PinCodeLabel.fromBackUp ||
          widget.label == PinCodeLabel.fromSignMessage) {
        Navigator.pop(context, pin);
      } else if (widget.label == PinCodeLabel.fromMenu) {
        Navigator.pop(context, true);
      }

      valueChange.value[1] = false;
    } else {
      if (firstPin == pin) {
        // await StorageServices.readSecure(DbKey.pin)!.then((value) async {
        //   if (value == "") {
        //     await StorageServices.writeSecure(DbKey.pin, pin);
        //   }
        // });

        clearAll();
        if (widget.label == PinCodeLabel.fromCreateSeeds) {
          // if (!mounted) return;
          // Navigator.push(
          //     context,
          //     Transition(
          //         child: CreateSeeds(
          //           passCode: pin,
          //           newAcc: null,
          //         ),
          //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        } else if (widget.label == PinCodeLabel.fromImportSeeds) {
          if (!mounted) return;
          // Navigator.push(
          //     context,
          //     Transition(
          //         // ignore: missing_required_param
          //         child: ImportAcc(passCode: pin),
          //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        } else if (widget.label == PinCodeLabel.fromAccount) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context, pin);
        } else {
          if (!mounted) return;
          Navigator.pop(context, true);
        }
      } else {
        clearAll();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: MyTextConstant(
          text: "Pin does not match",
          textAlign: TextAlign.start,
          color2: Colors.white,
        )));
        // Vibration.vibrate(amplitude: 500);
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
      // final bio = await StorageServices.readSaveBio();
      // if (bio) {
      //   await authenticate();
      // }
    }
  }

  Future<void> readBackUpKey(String pin) async {
    // final res = await StorageServices.readSecure(DbKey.pin);

    if (widget.label.toString() == "backup") {
      if (res == pin) {
        if (!mounted) return;
        Navigator.of(context).pop();
      } else {
        clearAll();
        // Vibration.vibrate(amplitude: 500);
      }
    }
  }

  // Check User Had Set PassCode
  Future<void> passcodeAuth(String pin) async {
    // final res = await StorageServices.readSecure(DbKey.pin);

    if (res == pin) {
      if (!mounted) return;
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     Transition(
      //         child: const HomePage(),
      //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
      //     ModalRoute.withName('/'));
    } else {
      clearAll();
      // Vibration.vibrate(amplitude: 500);
    }
  }

  // Future<void> authenticate() async {
  //   bool authenticate = false;

  //   try {
  //     authenticate = await localAuth.authenticate(
  //       localizedReason: '',
  //     );

  //     if (authenticate) {
  //       // Pop With Data For Refresh Menu
  //       if (!mounted) return;
  //       Navigator.pop(context, true);
  //     }
  //   } on SocketException catch (e) {
  //     await Future.delayed(const Duration(milliseconds: 300), () {});
  //     // AppServices.openSnackBar(globalkey!, e.message);
  //   } catch (e) {
  //     await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10.0)),
  //           title: const Align(
  //             child: Text('Opps'),
  //           ),
  //           content: Padding(
  //             padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
  //             child: Text(e.toString()),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('Close'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  void onPressedDigit() {
    setState(() {
      clearAll();
      valueChange.value[0] = !valueChange.value[0]!;
      valueChange.value[0] == true ? init4Digits() : init6Digits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PincodeBody(
      label: widget.label,
      valueChange: valueChange,
      lsControl: lsControl,
      pinIndexSetup: pinIndexSetup,
      clearPin: clearPin,
      onPressedDigit: onPressedDigit
    );
  }
}
