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

  Future<void> customDialog(BuildContext context, String title, String contents, {required String txtButton,Widget? btn2}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteHexaColor),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: MyText(
                text: title,
                fontWeight: FontWeight.w700,
                fontSize: 20, 
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0,),
              child: MyText(
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
    String? textButton, btn, btn2,
    bool? barrierDismissible = true,
    bool? onWillPop = true
  }) async {
    return await showDialog(
      context: context!, 
      barrierDismissible: barrierDismissible!,
      builder: (BuildContext context){
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: WillPopScope(
            onWillPop: () {
              return Future.value(onWillPop);
            },
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
          ),
        );
      }
    );
  }
}



Future<void> seedVerifyLaterDialog(BuildContext context, Function? submit) async {

  bool isCheck = false;
  
  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateWidget) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: hexaCodeToColor(AppColors.whiteColorHexa),
            content: SizedBox(
              // height: MediaQuery.of(context).size.height / 2.6,
              width: MediaQuery.of(context).size.width * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Lottie.asset(
                        "assets/animation/warning-shield.json",
                        repeat: true,
                      ),
                    ),
                    const MyText(
                      text: 'Verify you Seed Phrase later?',
                      fontSize: 20,
                      top: 10,
                      bottom: 25,
                      fontWeight: FontWeight.bold,
                    ),
  
                    Theme(
                      data: ThemeData(),
                      child: CheckboxListTile(
                        title: const MyText(
                          text: "I understand that if I lose my Secret Seed Phrase I will not be able to access my wallet",
                          textAlign: TextAlign.start,
                        ),
                        activeColor: hexaCodeToColor(AppColors.primaryColor),
                        value: isCheck,
                        onChanged: (newValue) {
                          setStateWidget(() {
                            isCheck = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),

                    MyFlatButton(
                      isTransparent: true,
                      buttonColor: AppColors.greenColor,
                      textColor: isCheck == false ? AppColors.greyCode : AppColors.primaryColor,
                      textButton: "Yes, Verify Later",
                      action: () {
                        isCheck == false ? null : submit!();
                      },
                    ),

                    const SizedBox(height: 10,),

                    MyGradientButton(
                      textButton: "No, Verify Now",
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      action: (){
                        Navigator.pop(context);
                      }
                    )

                  ],
                ),
              ),
            )
          );
        }
      );
    },
  );
}