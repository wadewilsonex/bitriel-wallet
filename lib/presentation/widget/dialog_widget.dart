import 'package:bitriel_wallet/index.dart';
import 'dart:ui';

dialogLoading(BuildContext context, {String? animationAsset, String? content, bool isDismissable = true}) {
  return showDialog(
    barrierDismissible: isDismissable,
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