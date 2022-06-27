import 'dart:ui';

import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';

class DialogComponents {
  
  Future<void> seedDialog({BuildContext? context, String? contents, btn, bool? isDarkTheme}) async {
    return await showDialog(
      context: context!, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          backgroundColor: hexaCodeToColor(AppColors.darkBgd),
          title: MyText(
            fontSize: 20,
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
                  // side: BorderSide(
                  //   width: 1
                  // ),
                  borderRadius: BorderRadius.circular(10),
                ),
                color: isDarkTheme! 
                  ? Colors.white.withOpacity(0.06)
                  : hexaCodeToColor(AppColors.whiteHexaColor),
                child: MyText(
                  text: contents,
                  textAlign: TextAlign.left,
                  fontSize: 18,
                  color: AppColors.secondarytext,
                  fontWeight: FontWeight.bold,
                  pLeft: 16,
                  right: 16,
                  top: 16,
                  bottom: 16,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Consumer<ReceiveWalletProvider>(
                  builder: (context, provider, widget){
                    return GestureDetector(
                      onTap: (){
                  
                        Clipboard.setData(
                          ClipboardData(text: contents),
                        );
                        /* Copy Text */
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Seeds is copied'),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.copy, color: hexaCodeToColor(AppColors.lowWhite), size: 15.sp,),
                          
                          SizedBox(width: 2.w,),
                          MyText(
                            text: "Copy address",
                            color: AppColors.lowWhite,
                          )
                        ],
                      ),
                    );
                  }
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

  Future<void> dialogCustom({ required BuildContext? context, String? titles, String? contents, Widget? contents2, LottieBuilder? lottie, Image? image, String? textButton, btn, btn2, bool? isDarkTheme}) async {
    return await showDialog(
      context: context!, 
      builder: (BuildContext context){
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            backgroundColor: hexaCodeToColor(AppColors.bluebgColor),
            title: titles != null ? MyText(
              text: titles,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColorHexa//isDarkTheme == false ? AppColors.darkCard : AppColors.whiteHexaColor,
            ) : Container(),
            buttonPadding: btn2 != null ? EdgeInsets.only(left: 24, right: 24, bottom: 24) : EdgeInsets.zero,
            content: contents != null ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
        
                lottie != null ? lottie : Container(),
                
                lottie != null ? SizedBox(height: 3.h) : Container(),
                
                image != null ? image : Container(),
                
                image != null ? SizedBox(height: 3.h) : Container(),
                MyText(
                  text: contents,
                  // fontSize: 17,
                  color: AppColors.whiteColorHexa, 
                )
              ],
            ) : contents2,
            actions: [
              btn ?? Container(),
        
              btn2 ?? TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)
                ),
                onPressed: () async {
                  // await FlutterScreenshotSwitcher.enableScreenshots();
                  Navigator.pop(context);
                },
                child: MyText(
                  text: "Close",
                  color: AppColors.lowWhite
                ),
              )
            ],
          ),
        );
      }
    );
  }
}

void messageToast(){

        
  // MotionToast.success(
  //   title:  Text("Success"),
  //   description:  Text("Scan had connected"),
  //   layoutOrientation: ORIENTATION.ltr,
  //   animationType: ANIMATION.fromLeft, width:  300,
  //   position: MOTION_TOAST_POSITION.top,
  // ).show(context);
}