// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:ui';
import 'package:pinput/pinput.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/get_wallet.m.dart';
import 'package:loading_indicator/loading_indicator.dart';
class Component {

  // For Pinput
  static double width = 50;
  static double height = 80;

  /* Show Pin Code For Fill Out */
  Future<String> dialogBox(BuildContext context) async {
    final String result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Material(
          color: Colors.transparent,
          child: FillPin(),
        );
      }
    );
    return result;
  }

  static void popScreen(BuildContext context) {
    Navigator.pop(context);
  }

  static Future messagePermission({BuildContext? context, String? content, void Function()? method}) async {
    await showDialog(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Align(
            child: Text("Message"),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(content!, textAlign: TextAlign.center),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: method,
              child: const Text('Setting'),
            ),
          ],
        );
      },
    );
  }

}

class MyFlatButton extends StatelessWidget {

  final String? textButton;
  final String? buttonColor;
  final String? textColor;
  final Widget? subChild;
  final FontWeight? fontWeight;
  final double? fontSize;
  final EdgeInsetsGeometry? edgeMargin;
  final EdgeInsetsGeometry? edgePadding;
  final bool? hasShadow;
  final Function? action;
  final double? width;
  final double? height;
  final bool? isTransparent;
  final bool? isBorder;
  final double? opacity;

  const MyFlatButton({
    Key? key, 
    this.textButton,
    this.subChild,
    this.buttonColor = AppColors.secondary,
    this.textColor = AppColors.whiteColorHexa,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 18,
    this.edgeMargin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.edgePadding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.hasShadow = false,
    this.width = double.infinity,
    this.height,
    this.isTransparent = false,
    this.isBorder,
    this.opacity = 1,
    @required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Container(
      padding: edgePadding,
      margin: edgeMargin,
      width: width,
      height: height,

      decoration: isTransparent! ? null : BoxDecoration(
        border: isBorder! ? Border.all(
          color: isDarkMode ? Colors.transparent : hexaCodeToColor(AppColors.primaryColor).withOpacity(0.50),
          width: 1,
        ) : null,
        borderRadius: BorderRadius.circular(size8), 
        boxShadow: [
          if (hasShadow!)
            BoxShadow(
              color: Colors.black54.withOpacity(0.3),
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: const Offset(2.0, 5.0),
            )
        ]
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          backgroundColor: isTransparent! ? Colors.transparent : hexaCodeToColor(buttonColor!).withOpacity(opacity!),
        ),
        onPressed: action == null ? null : (){
          action!();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyText(
              text: textButton!,
              hexaColor: textColor!,
              fontWeight: fontWeight!,
              fontSize: fontSize,
            ),
            
            subChild ?? Container()
          ],
        ),
      ),
    );
  }
}

class MyGradientButton extends StatelessWidget {

  final String? textButton;
  final Widget? child;
  final String? buttonColor;
  final String? textColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final EdgeInsetsGeometry? edgeMargin;
  final EdgeInsetsGeometry? edgePadding;
  final bool? hasShadow;
  final Function? action;
  final double? width;
  final double? height;
  final bool? isTransparent;
  final List<String>? lsColor;
  final List<double>? lsColorOpacity;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const MyGradientButton({
    Key? key, 
    this.child,
    this.textButton = "",
    this.lsColor = const [ "#F27649", "#F28907" ],
    this.lsColorOpacity = const [1, 1],
    this.buttonColor = AppColors.secondary,
    this.textColor = AppColors.whiteColorHexa,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 18,
    this.edgeMargin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.edgePadding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.hasShadow = false,
    this.width = double.infinity,
    this.height = 60,
    this.isTransparent = false,
    required this.begin,
    required this.end,
    @required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: edgePadding,
      margin: edgeMargin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 48.0,
            offset: const Offset(0.0, 2)
          )
        ],
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [hexaCodeToColor(lsColor![0]).withOpacity(lsColorOpacity![0]), hexaCodeToColor(lsColor![1]).withOpacity(lsColorOpacity![1])],
          begin: begin,
          end: end, 
          stops: const [0.25, 0.75],
        ),
      ),
      child: MaterialButton(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: action == null ? null : (){
          action!();
        },
        child: child ?? MyText(
          text: textButton!,
          hexaColor: textColor!,
          fontWeight: fontWeight!,
          // width: 100,
          fontSize: fontSize,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class MyText extends StatelessWidget {
  final String? text;
  final String? hexaColor;
  final Color? color2;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double? pTop;
  final double? pRight;
  final double? pBottom;
  final double? pLeft;
  final double? width;
  final double? height;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLine;

  const MyText({
    Key? key, 
    this.text,
    this.hexaColor,
    this.color2,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
    this.pLeft = 0,
    this.pRight = 0,
    this.pTop = 0,
    this.pBottom = 0,
    this.width,
    this.height,
    this.textAlign = TextAlign.center,
    this.overflow,
    this.maxLine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(left!, top!, right!, bottom!),
      padding: EdgeInsets.fromLTRB(pLeft!, pTop!, pRight!, pBottom!),
      child: SizedBox(
        width: width,
        height: height,
        child: Text(
          text!,
          style: TextStyle(
            fontWeight: fontWeight,
            color: AppUtils.colorSelector(isDark: isDarkMode, hexaColor: hexaColor, enumColor: color2),
            fontSize: fontSize!
          ),
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLine,
        ),
      ),
    );
    // Consumer<ThemeProvider>(
    //   builder: (context, themePro, widget) {
    //     return 
    //   }
    // );
  }
}

Widget myText2(
  BuildContext context,
  {
    String? text,
    String? hexaColor,
    Color? color2,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLine
  }
){
  return Text(
    text!,
    style: TextStyle(
      fontWeight: fontWeight,
      color: AppUtils.colorSelector(isDark: isDarkMode, hexaColor: hexaColor, enumColor: color2),
      fontSize: fontSize!
    ),
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLine,
  );
  // Consumer<ThemeProvider>(
  //   builder: (context, themePro, widget) {
  //     return 
  //   }
  // );
}

class MyLogo extends StatelessWidget {
  final String? logoPath;
  final String? color;
  final double? width;
  final double? height;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  const MyLogo(
    {Key? key, 
    @required this.logoPath,
    this.color = "#FFFFFF",
    this.width = 60,
    this.height = 60,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(left!, top!, right!, bottom!),
      child: SvgPicture.asset(
        logoPath!,
        width: width,
        height: height,
        color: hexaCodeToColor(color!),
      ),
    );
  }
}

class MyCircularImage extends StatelessWidget {
  final String? boxColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String? imagePath;
  final double? width;
  final double? height;
  final double? imageWidth;
  final double? imageHeight;
  final bool? enableShadow;
  final BoxDecoration? decoration;
  final Color? colorImage;

  const MyCircularImage(
      {Key? key, 
      this.boxColor = AppColors.secondary,
      this.margin = const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
      this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
      this.imagePath,
      this.width,
      this.height,
      this.imageWidth,
      this.imageHeight,
      this.enableShadow,
      this.decoration,
      this.colorImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      padding: padding,
      decoration: decoration,
      child: SvgPicture.asset(
        imagePath!,
        color: colorImage,
        width: imageWidth,
        height: imageHeight,
      ),
    );
  }
}

class BodyScaffold extends StatelessWidget {
  
  final double? left, top, right, bottom;
  final Widget? child;
  final double? width;
  final double? height;
  final ScrollPhysics? physic;
  final bool? isSafeArea;
  final ScrollController? scrollController;

  const BodyScaffold({
    Key? key, 
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 16,
    this.child,
    this.height,
    this.width,
    this.physic,
    this.isSafeArea = true,
    this.scrollController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return SingleChildScrollView(
      physics: physic,
      controller: scrollController,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        // color: AppUtils.backgroundTheme(),
        // isDarkMode
        //   ? Color(AppUtils.convertHexaColor(AppColors.darkBgd))
        //   : Color(AppUtils.convertHexaColor("#F5F5F5")),
        padding: EdgeInsets.fromLTRB(left!, top!, right!, bottom!),
        child: isSafeArea! ? SafeArea(child: child!) : child,
      )
    );
  }
}

class MyIconButton extends StatelessWidget {

  final String? title;
  final bool? isActive;
  final Widget? child;
  final String? icon;
  final double? iconSize;
  final Function? onPressed;
  final String? txtColor;
  // final EdgeInsetsGeometry padding;

  const MyIconButton({
    Key? key, 
    this.title,
    this.isActive = false,
    this.child,
    this.icon,
    this.iconSize,
    this.txtColor,
    // this.padding = const EdgeInsets.all(0),
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: (){
        onPressed!();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child ?? SvgPicture.asset(
            '${AppConfig.iconsPath}$icon',
            width: iconSize ?? 24,
            height: iconSize ?? 24,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          const SizedBox(height: 5),
          MyText(
            text: title,
            hexaColor: txtColor,
            fontWeight: isActive! ? FontWeight.w600 : FontWeight.normal,
          )
        ],
      )
    );
  }
}

class MyRowHeader extends StatelessWidget {
  const MyRowHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 1.5),
                alignment: Alignment.centerLeft,
                child: const MyText(text: "Your assets")),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: MyText(text: "QTY"),
            ),
          ),
        ],
      ),
    );
  }
}


/* Trigger Snack Bar Function */
void snackBar(BuildContext context, String contents) {
  final snackbar = SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(contents),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

class MyPinput extends StatelessWidget {

  final bool? obscureText;
  final GetWalletModel? getWalletM;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;

  const MyPinput({
    Key? key, 
    this.obscureText = true,
    this.getWalletM,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Pinput(
      obscureText: obscureText!,
      focusNode: focusNode,
      controller: controller,
      length: 4,
      obscuringCharacter: '⚪',
      // selectedFieldDecoration: getWalletM!.pinPutDecoration.copyWith(
      //   color: Colors.grey.withOpacity(0.5),
      //   border: Border.all(
      //     color: Colors.grey,
      //   )
      // ),
      errorPinTheme: PinTheme(
        width: Component.width, height: Component.height, 
        decoration: getWalletM!.pinPutDecoration.copyWith(border: Border.all(color: Colors.red), color: Colors.grey[350])
      ),
      focusedPinTheme: PinTheme(
        width: Component.width, height: Component.height, 
        decoration: getWalletM!.pinPutDecoration.copyWith(border: Border.all(color: Colors.blue), color: Colors.grey[350])
      ),
      submittedPinTheme: PinTheme(
        width: Component.width, height: Component.height, 
        decoration: getWalletM!.pinPutDecoration.copyWith(border: Border.all(color: Colors.green), color: Colors.grey[350])
      ),
      followingPinTheme: PinTheme(
        width: Component.width, height: Component.height, 
        decoration: getWalletM!.pinPutDecoration.copyWith(border: Border.all(color: Colors.grey), color: Colors.grey[350])
      ),
      // eachFieldConstraints: getWalletM!.boxConstraint,
      // textStyle: consSt TextStyle(fontSize: 18, color: Colors.white),
      onChanged: (String value){
        // debugPrint("On changed $value");
        // onChanged!(value);
      },
      onCompleted: onCompleted,
      // onSubmitted: onSubmit,
    );
  }
}
