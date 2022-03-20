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

  Future<void> dialogCustom({BuildContext? context, String? title, String? contents, btn, bool? isDarkTheme}) async {
    return await showDialog(
      context: context!, 
      builder: (BuildContext context){
        return AlertDialog(
          title: MyText(
            text: title,
            fontWeight: FontWeight.bold,
            color: isDarkTheme == false ? AppColors.darkCard : AppColors.whiteHexaColor,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              MyText(
                text: contents,
                color: AppColors.blackColor,
                pLeft: 16,
                right: 16,
                top: 16,
                bottom: 16,
              )
            ],
          ),
          actions: [
            btn ?? Container(),

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
}