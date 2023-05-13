import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/components/pie_chart.dart';
import 'package:wallet_apps/constants/ui_helper.dart';
import 'package:wallet_apps/data/provider/receive_wallet_p.dart';
import 'package:wallet_apps/presentation/screen/home/home/home.dart';
import 'dialog_c.dart';

/* -----------------------------------Variable--------------------------------------------------- */
/* Size */
const double size1 = 1.0;
const double size2 = 2.0;
const double size4 = 4.0;
const double size5 = 5.0;
const double size8 = 8.0;
const double size10 = 10.0;
const double size17 = 17.0;
const double size34 = 34.0;
const double size15 = 15.0;
const double size18 = 18.0;
const double size28 = 28.0;
const double size50 = 50.0;
const double size80 = 80.0;

/* Background Left & Right Size */
const double leftRight40 = 40.0;

/* -----------------------------------Box Border and Shadow Style--------------------------------------------------- */
Color hexaCodeToColor(String hexaCode) {
  return Color(AppUtils.convertHexaColor(hexaCode));
}

/* ------------------Input Decoration--------------------- */

OutlineInputBorder errorOutline() {
  /* User Error Input Outline Border */
  return const OutlineInputBorder(borderSide: BorderSide(color: Colors.red));
}

/* Button shadow */
BoxShadow shadow(BuildContext context,
  { Color? hexaCode, 
    double? blurRadius, 
    double? spreadRadius, 
    Offset? offset}) {
   
  return BoxShadow(
    color: hexaCode ?? (isDarkMode
        ? hexaCodeToColor(AppColors.darkBgd)
        : Colors.grey.withOpacity(0.2)),
    blurRadius: blurRadius ?? 6.0,
    spreadRadius: spreadRadius ?? 2.0,
    offset: offset ?? const Offset(0.5, 2.0),
  );
}

Future<void> txDetailDialog(BuildContext context, TxHistory txHistory) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(
          child: MyText(
          text: 'Transaction Detail',
          fontWeight: FontWeight.bold,
        )),
        content: SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const MyText(
                    text: 'Date: ',
                    fontSize: 14.0,
                  ),
                  Expanded(
                      child: MyText(
                    text: txHistory.date,
                    textAlign: TextAlign.start,
                    fontSize: 14.0,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              Row(
                children: [
                  const MyText(
                    text: 'Destination: ',
                    fontSize: 14.0,
                  ),
                  Expanded(
                      child: MyText(
                    text: txHistory.destination,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14.0,
                  )),
                ],
              ),
              Row(
                children: [
                  const MyText(
                    text: 'Sender: ',
                    fontSize: 14.0,
                  ),
                  Expanded(
                      child: MyText(
                    text: txHistory.sender,
                    textAlign: TextAlign.start,
                    fontSize: 14.0,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              Row(
                children: [
                  const MyText(
                    text: 'Organization: ',
                    fontSize: 14.0,
                  ),
                  Expanded(
                      child: MyText(
                    text: txHistory.org,
                    textAlign: TextAlign.start,
                    fontSize: 14.0,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              Row(
                children: [
                  const MyText(
                    text: 'Amount: ',
                    fontSize: 14.0,
                  ),
                  Expanded(
                    child: MyText(
                      text: txHistory.amount,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/* ----------------------------------- Bottom App Bar ----------------------------------- */

/* Loading Progress */
Widget centerLoading() {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      valueColor: AlwaysStoppedAnimation(hexaCodeToColor(AppColors.primaryColor))
    ),
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
              child: MyText(
                text: content, 
                hexaColor: AppColors.whiteColorHexa,
              ),
            ),
          ],
        )
      ],
    ),
  );
}

dialogLoading(BuildContext context, {String? animationAsset, String? content}) {
  return showDialog(
    barrierDismissible: true,
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

Widget textDisplay(String text, TextStyle textStyle) {
  return Text(
    text,
    style: textStyle,
  );
}

/* ---------------------------------Camera and Gallery------------------------------------------------ */

/* QR Code Generate Function */
Widget qrCodeGenerator(BuildContext context, String wallet, String logoName, GlobalKey keyQrShare, {double width = 45, bool embeddedImage = true}) {
  return Consumer<AppProvider>(
    builder: (context, pro, wg) {
      return SizedBox(
        width: width.w,
        child: QrImage(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          embeddedImage: embeddedImage == true ? FileImage(File('${pro.dirPath}/logo/bitirel-logo-circle.png')) : null,
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: Size(25.sp, 25.sp),
          ),
          eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle, color: Colors.black),
          dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: Colors.black),
          data: wallet,
        ),
      );
    }
  );
}

Widget qrCodeProfile(String wallet, String logoName, GlobalKey keyQrShare) {
  return QrImage(
    padding: EdgeInsets.zero,
    backgroundColor: Colors.white,
    embeddedImage: FileImage(File(logoName)),
    embeddedImageStyle: QrEmbeddedImageStyle(
      size: const Size(50, 50),
    ),
    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle, color: Colors.black),
    dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: Colors.black),
    // version: QrVersions.auto,
    data: wallet,
  );
}

Widget disableNativePopBackButton(Widget child) {
  return WillPopScope(
    onWillPop: () => Future(() => false),
    child: child,
  );
}

Future<void> underContstuctionAnimationDailog({required BuildContext? context}){
  return DialogComponents().dialogCustom(
    context: context,
    contentPadding: EdgeInsets.zero,
    contents: "Under Construction",
    textButton: "OK",
    // image: Image.asset("assets/icons/success.png", width: 20.w, height: 10.h),
    lottie: Lottie.asset(
      "assets/animation/under-construction.json",
      repeat: true,
      reverse: true,
      height: 25.h,
    ),
    btn2: MyGradientButton(
      textButton: "OK",
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      action: () async {
        Navigator.pop(context!);
      },
    )
  );
}

Widget textRowWidget(BuildContext context, String leadingText, String trailingText, {bool isCopy = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0,),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Expanded(
          child: MyText(
            text: leadingText,
            textAlign: TextAlign.start,
          ),
        ),

        // SizedBox(width: 20,),
        // Expanded(child: Container()),
        Expanded(
          child: MyText(
            text: trailingText,
            hexaColor: AppColors.blackColor,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.end,
          ),
        ),

        isCopy == true ? Padding(
          padding: const EdgeInsets.only(left: 4),
          child: InkWell(
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: trailingText),
              );
              /* Copy Text */
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Copied to Clipboard"),
                ),
              );
            },
            child: Icon(
              Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor)
            ),
          ),
        ) : Container(),
        
      ],
    ),
  );
}

Widget tfPasswordWidget(TextEditingController? password, String? title, {bool obscureText = true, double? borderSize = 1, Function? onSubmit}) {
  return TextFormField(
    obscureText: obscureText,
    controller: password,
    onFieldSubmitted: (String value) {
      if (onSubmit != null) onSubmit();
    },
    style: TextStyle(
      color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,),
    ),
    decoration: InputDecoration(

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(width: borderSize!, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor),),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(width: borderSize, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(width: borderSize, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor)),
      ),

      hintText: title,
      hintStyle: TextStyle(
        fontSize: 18,
        color: hexaCodeToColor("#AAAAAA"),
      ),

      prefixStyle: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.orangeColor), fontSize: 18.0),
      
      /* Prefix Text */
      filled: true,
      fillColor: Colors.white//hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.lightColorBg),

    ),
    validator: (val){
      if(val != password!.text) {
        return 'Password not match';
      }
      return null;
    }
  );
}