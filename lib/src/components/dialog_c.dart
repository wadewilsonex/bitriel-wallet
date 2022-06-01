import 'package:wallet_apps/index.dart';

class DialogComponents {
  
  Future<void> seedDialog({BuildContext? context, String? contents, btn, bool? isDarkTheme}) async {
    return await showDialog(
      context: context!, 
      builder: (BuildContext context){
        return AlertDialog(
          title: MyText(
            text: "Mnemonic",
            fontWeight: FontWeight.bold,
            color: isDarkTheme == false ? AppColors.darkCard : AppColors.whiteHexaColor,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText(
                textAlign: TextAlign.left,
                text: AppString.screenshotNote,
                color: isDarkTheme == false ? AppColors.darkCard : AppColors.whiteHexaColor,
                bottom: paddingSize,
              ),

              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: hexaCodeToColor(AppColors.darkSecondaryText).withOpacity(0.3),
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                color: isDarkTheme! 
                  ? hexaCodeToColor(AppColors.darkCard)
                  : hexaCodeToColor(AppColors.whiteHexaColor),
                child: MyText(
                  text: contents,
                  textAlign: TextAlign.left,
                  fontSize: 25,
                  color: AppColors.secondarytext,
                  fontWeight: FontWeight.bold,
                  pLeft: 16,
                  right: 16,
                  top: 16,
                  bottom: 16,
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // await FlutterScreenshotSwitcher.enableScreenshots();
                Navigator.pop(context);
              },
              child: MyText(text: 'Close'),
            )
          ],
        );
    });
  }

  Future<void> dialogCustom({ required BuildContext? context, String? titles, String? contents, Widget? contents2, Image? image, String? textButton, btn, btn2, bool? isDarkTheme}) async {
    return await showDialog(
      context: context!, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          backgroundColor: hexaCodeToColor(AppColors.bluebgColor),
          title: titles != null ? MyText(
            text: titles,
            fontWeight: FontWeight.bold,
            color: AppColors.darkCard//isDarkTheme == false ? AppColors.darkCard : AppColors.whiteHexaColor,
          ) : Container(),
          buttonPadding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
          content: contents != null ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              image != null ? image : Container(),
              
              SizedBox(height: 30),
              MyText(
                text: contents,
                color: AppColors.bgdColor,
                pLeft: 16,
                right: 16,
                top: 16,
                bottom: 16,
              )
            ],
          ) : contents2,
          actions: [
            btn ?? Container(),

            btn2 ?? TextButton(
              onPressed: () async {
                // await FlutterScreenshotSwitcher.enableScreenshots();
                Navigator.pop(context);
              },
              child: MyGradientButton(
                edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                textButton: textButton,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () async {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        );
      }
    );
  }
}