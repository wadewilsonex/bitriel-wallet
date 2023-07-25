import 'package:bitriel_wallet/index.dart';
import 'dart:ui';


/// Set useRootNavigator = false becuase we want dialog near visible navigator.
dialogLoading(BuildContext context, {String? animationAsset, String? content, bool isDismissable = true, bool useRootNavigator = false}) {
  return showDialog(
    barrierDismissible: isDismissable,
    useRootNavigator: useRootNavigator,
    context: context,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: progress(animationAsset: animationAsset, content: content)
      );
      // WillPopScope(
      //   onWillPop: () => Future(() => false),
      //   child: ,
      // );
    }
  );
}

/* Progress */
Widget progress({String? animationAsset, String? content}) {
  return Material(
    color: Colors.transparent,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Lottie.asset(
              animationAsset ?? "assets/animation/loading-block.json",
              repeat: true,
              // reverse: true,
            ),
            if (content == null)
            Container()
            else
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 16.0),
              child: MyTextConstant(
                text: content, 
                color2: hexaCodeToColor(AppColors.whiteColorHexa),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Future<void> dialogMessage(BuildContext context, String title, String contents, {required String txtButton,Widget? btn2, bool useRootNavigator = false}) async {
    await showDialog(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteHexaColor),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: MyTextConstant(
                text: title,
                fontWeight: FontWeight.w700,
                fontSize: 20, 
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0,),
              child: MyTextConstant(
                text: contents, 
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            actions: <Widget>[
              btn2 ?? Container(),
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: MyGradientButton(
                  textButton: txtButton,
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
