import 'package:pinput/pinput.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/get_wallet.m.dart';

class FillPin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FillPinState();
  }
}

class FillPinState extends State<FillPin> {

  final TextEditingController _pinPutController = TextEditingController();

  TextEditingController pinController = TextEditingController();

  final FocusNode _pinNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      // border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.grey.withOpacity(0.5)
    );
  }

  // BoxConstraints get boxConstraint {
  //   return const BoxConstraints(minWidth: 60, minHeight: 80);
  // }

  @override
  void initState() {
    _pinPutController.clear();
    _pinNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _pinPutController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: hexaCodeToColor(AppColors.darkBgd),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: MyText(
        top: 16,
        bottom: 16,
        text: "Fill your pin",
        color: AppColors.whiteHexaColor,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: hexaCodeToColor(AppColors.darkBgd),
            padding: const EdgeInsets.only(bottom: 20),
            child: MyPinput(
              getWalletM: GetWalletModel(),
              controller: _pinPutController,
              focusNode: _pinNode,
              onCompleted: (value) {
                Navigator.pop(context, value);
              },
            )
            // Pinput(
            //   obscureText: true,
            //   obscuringCharacter: '⚪',
            //   focusNode: _pinNode,
            //   controller: _pinPutController,
            //   length: 4,
            //   // eachFieldMargin: const EdgeInsets.only(left: 13),
            //   // selectedFieldDecoration: _pinPutDecoration.copyWith(
            //   //   color: Colors.grey.withOpacity(0.5),
            //   //   border: Border.all(color: Colors.grey),
            //   // ),
            //   errorPinTheme: PinTheme(
            //     width: Component.width, height: Component.height, 
            //     decoration: _pinPutDecoration.copyWith(border: Border.all(color: Colors.red))
            //   ),
            //   focusedPinTheme: PinTheme(
            //     width: Component.width, height: Component.height, 
            //     decoration: _pinPutDecoration.copyWith(border: Border.all(color: Colors.blue))
            //   ),
            //   submittedPinTheme: PinTheme(
            //     width: Component.width, height: Component.height, 
            //     decoration: _pinPutDecoration.copyWith(border: Border.all(color: Colors.green))
            //   ),
            //   followingPinTheme: PinTheme(
            //     width: Component.width, height: Component.height, 
            //     decoration: _pinPutDecoration.copyWith(border: Border.all(color: Colors.green))
            //   ),
            //   // eachFieldConstraints: boxConstraint,
            //   // textStyle: const TextStyle(fontSize: 18, color: Colors.white),
              
            // ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: MyText(text: "Close", color: AppColors.whiteHexaColor),
            ),
          )
        ],
      ),

    );
  }
}
