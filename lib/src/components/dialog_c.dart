import 'dart:ui';

import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';

class DialogComponents {
  
  Future<void> seedDialog({BuildContext? context, String? contents, btn}) async {
    return await showDialog(
      context: context!, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.14.vmax)
          ),
          backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
          title: const MyText(
            fontSize: 2.9,
            text: "Mnemonic",
            fontWeight: FontWeight.bold,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              MyText(
                textAlign: TextAlign.left,
                text: AppString.screenshotNote,
                bottom: paddingSize,
              ),

              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(
                  //   width: 1
                  // ),
                  borderRadius: BorderRadius.circular(1.42.vmax),
                ),
                color: isDarkMode
                  ? Colors.white.withOpacity(0.06)
                  : hexaCodeToColor(AppColors.whiteColorHexa),
                child: MyText(
                  text: contents,
                  textAlign: TextAlign.left,
                  fontSize: 2.5,
                  hexaColor: isDarkMode ? AppColors.secondary : AppColors.orangeColor,
                  fontWeight: FontWeight.bold,
                  pLeft: 2.28.vmax,
                  right: 2.28.vmax,
                  top: 2.28.vmax,
                  bottom: 2.28.vmax,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 2.85.vmax),
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
                          Icon(Iconsax.copy, color: hexaCodeToColor(isDarkMode ? AppColors.lowWhite : AppColors.blackColor), size: 2.85.vmax,),
                          
                          SizedBox(width: 2.vmax,),
                          MyText(
                            text: "Copy",
                            top: 0.71.vmax,
                            hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.blackColor,
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
              child: MyText(
                text: 'Close',
                hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor,
              ),
            )
          ],
        );
    });
  }

  Future dialogCustom({ 
    required BuildContext? context, 
    String? titles, 
    double? titlesFontSize = 2.2,
    EdgeInsetsGeometry? contentPadding, 
    String? contents, 
    double? contentsFontSize = 2.2,
    Widget? contents2, 
    LottieBuilder? lottie, 
    Image? image, 
    String? textButton, btn, btn2
  }) async {
    print("1.vmax ${1.vmax}");
    if (contentPadding == null){
      contentPadding = EdgeInsets.all(3.4.vmax);
    }
    return await showDialog(
      context: context!, 
      builder: (BuildContext context){
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            contentPadding: contentPadding!,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.9.vmax)),
            ),
            backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa),
            title: titles != null ? MyText(
              text: titles,
              fontWeight: FontWeight.bold,
              fontSize: titlesFontSize,
            ) : Container(),
            buttonPadding: btn2 != null ? EdgeInsets.only(left: 3.4.vmax, right: 3.4.vmax, bottom: 3.4.vmax) : EdgeInsets.zero,
            content: contents != null ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
        
                lottie ?? Container(),
                
                // lottie != null ? SizedBox(height: 3.h) : Container(),
                
                image ?? Container(),
                
                image != null ? SizedBox(height: 3.vmax) : Container(),
                MyText(
                  text: contents,
                  fontSize: contentsFontSize,
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
                  hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.textColor, 
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