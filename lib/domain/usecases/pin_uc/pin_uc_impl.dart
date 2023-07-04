import 'package:bitriel_wallet/domain/usecases/pin_uc/pin_uc.dart';
import 'package:bitriel_wallet/index.dart';

class PinUsecaseImpl implements PinUsecase{

  PinModel pinModel = PinModel();
  
  @override
  List<ValueNotifier<String>> init4Digits() {
    pinModel.currentPin = ["", "", "", ""];
    return pinModel.lsControl = [
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier('')
    ];
  }

  @override
  List<ValueNotifier<String>> init6Digits() {
    pinModel.currentPin = ["", "", "", "", "", ""];
    return pinModel.lsControl = [
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
      ValueNotifier(''),
    ];
  }

  @override
  void onPressedDigit() {
    // setState(() {
    //   clearAll();
    //   valueChange[0].value = !valueChange[0].value!;
    //   valueChange[0].value == true ? init4Digits() : init6Digits();
    // });
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

//     if(widget.label.toString() == "backup"){
//       if (res == pin) {
//         if(!mounted) return;
//         Navigator.of(context).pop();
//       } else {
//         clearAll();
//         Vibration.vibrate(amplitude: 500);
//       }
//     }
//   }

}