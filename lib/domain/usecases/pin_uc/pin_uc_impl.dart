import 'package:bitriel_wallet/index.dart';

class PinUsecaseImpl implements PinUsecase{

  PinModel pinModel = PinModel();

  final SecureStorageImpl secureStorageUCImpl = SecureStorageImpl();
  
  @override
  List<ValueNotifier<String>> init4Digits() {
    pinModel.currentPin = ["", "", "", ""];
    return pinModel.lsPINController = [
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier('')
    ];
  }

  @override
  List<ValueNotifier<String>> init6Digits() {
    pinModel.currentPin = ["", "", "", "", "", ""];
    return pinModel.lsPINController = [
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
    ];
  }

  @override
  void onPressedDigitOption(bool value) {
    clearAll();
    pinModel.is6gidit.value = !value;
  //   valueChange[0].value = !valueChange[0].value!;
  //   valueChange[0].value == true ? init4Digits() : init6Digits();
  }

  @override
  void clearAll() {
    for (int i = 0; i < pinModel.lsPINController.length; i++) {
      clearPin();
    }
  }

  @override
  void clearPin() {
    if (pinModel.pinIndex == 0) {
      pinModel.pinIndex = 0;
    } else if (pinModel.pinIndex == (pinModel.is6gidit.value == false ? 4 : 6)) {
      pinModel.lsPINController[pinModel.pinIndex-1].value = "";
      pinModel.pinIndex--;
    } else {
      pinModel.lsPINController[pinModel.pinIndex-1].value = "";
      pinModel.currentPin[pinModel.pinIndex - 1] = "";
      pinModel.pinIndex--;
    }
  }

  /// Start Open Finger Print Widget Authentication
  @override
  Future<void> authenticate(BuildContext context) async {

    bool authenticate = false;

    try {
      authenticate = await pinModel.localAuth.authenticate(
        localizedReason: '',
      );

      if (authenticate) {
        // Pop With Data For Refresh Menu 
        // if(!mounted) return;
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      }
    } on SocketException {
      await Future.delayed(const Duration(milliseconds: 300), () {});

      // AppServices.openSnackBar(globalkey!, e.message);
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
  

  /// Check User Had Set PassCode
  Future<void> passcodeAuth(String pin) async {

    // final res = await StorageServices.readSecure(DbKey.pin);

    // if (res == pin) {
    //   if(!mounted) return;
    //   Navigator.pushAndRemoveUntil(
    //     context, 
    //     Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    //     ModalRoute.withName('/')
    //   );
    // } else {
    //   clearAll();
    //   Vibration.vibrate(amplitude: 500);
    // }
  }


//   Future<void> readBackUpKey(String pin) async {

//     final res = await StorageServices.readSecure(DbKey.pin);

//     if(pinModel.pinLabel.toString() == "backup"){
//       if (res == pin) {
//         if(!mounted) return;
//         Navigator.of(context).pop();
//       } else {
//         clearAll();
//         Vibration.vibrate(amplitude: 500);
//       }
//     }
//   }

  @override
  Future<void> setPin(BuildContext context, String text) async {

    // This logic is to prevent PIN index less than zero
    if (pinModel.pinIndex == 0) {
      // Add Selected PIN into List PIN
      pinModel.lsPINController[pinModel.pinIndex].value = text;
      pinModel.pinIndex = 1;
    } 
    
    // This Logic is setup PIN by index
    // And aslo delte PIN by Index
    else if (pinModel.pinIndex < (pinModel.is6gidit.value == false ? 4 : 6)) {
      // Add Selected PIN into List PIN
      pinModel.lsPINController[pinModel.pinIndex].value = text;
      ++pinModel.pinIndex;

      if (pinModel.pinIndex == (pinModel.is6gidit.value == false ? 4 : 6)){
        
        String strPin = "";

        strPin = pinModel.lsPINController.map((e) {
          return e.value;
        }).toList().join();

        if (pinModel.pinLabel == PinCodeLabel.fromSplash) {
          dialogLoading(context);
          await passcodeAuth(strPin);
        } else {
          await setVerifyPin(context, strPin);
        }
      }
    }
  }

  Future<void> setVerifyPin(BuildContext context, String pin) async {
    
    if (pinModel.firstPin == null) {

      pinModel.firstPin = pin;

      clearAll();

      if (
        pinModel.pinLabel == PinCodeLabel.fromSendTx || 
        pinModel.pinLabel == PinCodeLabel.fromBackUp ||
        pinModel.pinLabel == PinCodeLabel.fromSignMessage
        ){
        Navigator.pop(context, pin);
      } else
      if (pinModel.pinLabel == PinCodeLabel.fromMenu) {
        Navigator.pop(context, true);
      }
      
      pinModel.isFirstPIN.value = false;
      
    } else {
      
      if (pinModel.firstPin == pin) {
        
        // await StorageServices.readSecure(DbKey.pin)!.then((value) async {
        //   if (value == ""){
        //     await StorageServices.writeSecure(DbKey.pin, pin);
        //   }
        // });

        clearAll();
        if (pinModel.pinLabel == PinCodeLabel.fromCreateSeeds){

          // ignore: use_build_context_synchronously
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const CreateWallet())
            // Transition(
            //   child: CreateSeeds(passCode: pin, newAcc: null,),
            //   transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            // )
          );
        } else if (pinModel.pinLabel == PinCodeLabel.fromImportSeeds){
          
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ImportWallet()) 
            // Transition(
            //   // ignore: missing_required_param
            //   child: ImportAcc(passCode: pin),
            //   transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            // )
          );
        }
        // else if (pinModel.pinLabel == PinCodeLabel.fromAccount){
        else {

          // ignore: use_build_context_synchronously
          Navigator.pop(context, pin);
        }

      } else {

        clearAll();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: MyTextConstant(text: "Pin does not match", textAlign: TextAlign.start, color2: Colors.white,))
        );
        Vibration.vibrate(amplitude: 500);
      }
    }
  }

  @override
  Future<void> clearVerifyPin(BuildContext context, String pin) async {

    if (pinModel.firstPin == null) {

      pinModel.firstPin = pin;

      clearAll();

      pinModel.isFirstPIN.value = false;

    } else {

      if (pinModel.firstPin == pin) {
        await secureStorageUCImpl.clearByKeySecure(DbKey.pin);
        // ignore: use_build_context_synchronously
        // Navigator.pop(context, false);
      } else {
        clearAll();
        Vibration.vibrate(amplitude: 500);
      }
    }
  }

  Future<void> authToHome(BuildContext context) async {
    
    // if (pinModel.pinLabel == PinCodeLabel.fromSplash) {
    //   final bio = await secureStorageUCImpl.readSaveBio();
    //   if (bio) {
    //     // ignore: use_build_context_synchronously
    //     await authenticate(context);
    //   }
    // }
  }
}