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
            borderRadius: BorderRadius.circular(15)
          ),
          backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
          title: const MyText(
            fontSize: 22,
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
                fontSize: 17,
              ),

              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(
                  //   width: 1
                  // ),
                  borderRadius: BorderRadius.circular(10),
                ),
                color: isDarkMode
                  ? Colors.white.withOpacity(0.06)
                  : hexaCodeToColor(AppColors.whiteColorHexa),
                child: MyText(
                  text: contents,
                  textAlign: TextAlign.left,
                  fontSize: 18,
                  hexaColor: isDarkMode ? AppColors.secondary : AppColors.orangeColor,
                  fontWeight: FontWeight.bold,
                  pLeft: 16,
                  right: 16,
                  top: 16,
                  bottom: 16,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
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
                          Icon(Iconsax.copy, color: hexaCodeToColor(isDarkMode ? AppColors.lowWhite : AppColors.blackColor), size: 20,),
                          
                          const SizedBox(width: 2,),
                          MyText(
                            text: "Copy",
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
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
            Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: MyGradientButton(
                textButton: "Close",
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () => Navigator.pop(context),
              ),
            ),
          ],
        );
    });
  }

  Future dialogCustom({ 
    required BuildContext? context, 
    String? titles, 
    double? titlesFontSize = 18,
    EdgeInsetsGeometry? contentPadding = const EdgeInsets.fromLTRB(30.0, 25.0, 35.0, 35.0) , 
    String? contents, 
    double? contentsFontSize = 18,
    Widget? contents2, 
    LottieBuilder? lottie, 
    Image? image, 
    String? textButton, btn, btn2
  }) async {
    return await showDialog(
      context: context!, 
      builder: (BuildContext context){
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            contentPadding: contentPadding!,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa),
            title: titles != null ? MyText(
              text: titles,
              fontWeight: FontWeight.bold,
              fontSize: titlesFontSize,
            ) : Container(),
            buttonPadding: btn2 != null ? const EdgeInsets.only(left: 24, right: 24, bottom: 24) : EdgeInsets.zero,
            content: contents != null ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
        
                lottie ?? Container(),
                
                // lottie != null ? SizedBox(height: 3) : Container(),
                
                image ?? Container(),
                
                image != null ? const SizedBox(height: 3) : Container(),
                MyText(
                  text: contents,
                  fontSize: titlesFontSize,
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