// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:ui';

import 'package:flutter_svg/svg.dart';
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
    final String _result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: FillPin(),
        );
      }
    );
    return _result;
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
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: method,
              child: const Text('Setting'),
            ),
          ],
        );
      },
    );
  }
  
  static Future<String> pinDialogBox(BuildContext context) async {
    /* Show Pin Code For Fill Out */
    final String _result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: FillPin(),
        );
      }
    );
    return _result;
  }

  static void dialog(BuildContext context, {String? contents}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Card(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  width: 60,
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation(
                              hexaCodeToColor(AppColors.secondary))),
                      contents != null
                          ? MyText(
                              top: 10,
                              left: 10,
                              right: 10,
                              bottom: 10,
                              text: contents,
                              fontSize: 16,
                              color: AppColors.blackColor,
                            )
                          : Container()
                    ],
                  )
                )
              )
            ],
          ),
        );
      },
    );
  }

}

class MyFlatButton extends StatelessWidget {
  final String? textButton;
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

  const MyFlatButton({
    this.textButton,
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
    @required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Container(
      padding: edgePadding,
      margin: edgeMargin,
      width: width,
      height: height,

      decoration: BoxDecoration(borderRadius: BorderRadius.circular(size8), 
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
      // ignore: deprecated_member_use
      child: FlatButton(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: action == null ? null : (){
          action!();
        },
        color: isTransparent! ? Colors.transparent : hexaCodeToColor(buttonColor!),
        disabledColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade400,
        focusColor: hexaCodeToColor(AppColors.secondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: MyText(
          text: textButton!,
          color: textColor!,
          fontWeight: fontWeight!,
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
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const MyGradientButton({
    this.child,
    this.textButton,
    this.lsColor = const [ "#F27649", "#F28907" ],
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
    required this.begin,
    required this.end,
    @required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Container(
      padding: edgePadding,
      margin: edgeMargin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [hexaCodeToColor(lsColor![0]), hexaCodeToColor(lsColor![1])],
          begin: begin,
          end: end, 
          stops: [0.25, 0.75],
        ),
        // color: action == null ? Colors.white.withOpacity(0.06) : null
      ),
      child: MaterialButton(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: child ?? MyText(
          text: textButton!,
          color: textColor!,
          fontWeight: fontWeight!,
        ),
        onPressed: action == null ? null : (){
          action!();
        },
      ),
    );
  }
}

class MyText extends StatelessWidget {
  final String? text;
  final String? color;
  final Color? color2;
  double? fontSize;
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

  MyText({
    this.text,
    this.color,
    this.color2,
    this.fontSize = 15,
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
  }){
    fontSize = fontSize!.sp;
  }

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
            color: color != null ? Color(AppUtils.convertHexaColor(color!)) : color2,
            fontSize: fontSize!
          ),
          textAlign: textAlign,
          overflow: overflow,
        ),
      ),
    );
  }
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
      {@required this.logoPath,
      this.color = "#FFFFFF",
      this.width = 60,
      this.height = 60,
      this.top = 0,
      this.right = 0,
      this.bottom = 0,
      this.left = 0});

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
      {this.boxColor = AppColors.secondary,
      this.margin = const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
      this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
      this.imagePath,
      this.width,
      this.height,
      this.imageWidth,
      this.imageHeight,
      this.enableShadow,
      this.decoration,
      this.colorImage});

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

  const BodyScaffold({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 16,
    this.child,
    this.height,
    this.width,
    this.physic,
    this.isSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return SingleChildScrollView(
      physics: physic,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        color: hexaCodeToColor(AppColors.darkBgd),
        // isDarkTheme
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
  final Widget? child;
  final String? icon;
  final double? iconSize;
  final Function? onPressed;
  final String? txtColor;
  // final EdgeInsetsGeometry padding;

  const MyIconButton({
    this.title,
    this.child,
    this.icon,
    this.iconSize,
    this.txtColor,
    // this.padding = const EdgeInsets.all(0),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
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
            AppConfig.iconsPath+'$icon',
            width: iconSize ?? 30,
            height: iconSize ?? 30,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          SizedBox(height: 5),
          MyText(
            text: title,
            color: txtColor,
            
          )
        ],
      )
    );
  }
}

class MyCusIconButton extends StatelessWidget {
  final String? icon;
  final double? iconSize;
  final Function? onPressed;
  final EdgeInsetsGeometry? padding;

  const MyCusIconButton({
    this.icon,
    this.iconSize = 30,
    this.padding = const EdgeInsets.all(0),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: GestureDetector(
        onTap: (){
          onPressed!();
        },
        child: Image.asset(icon!, width: 30, height: 30, color: Colors.white),
      ),
    );
  }
}

// class MyCircularChart extends StatelessWidget {
//   final String amount;
//   final GlobalKey<AnimatedCircularChartState> chartKey;
//   final EdgeInsetsGeometry margin;
//   final List<CircularSegmentEntry> listChart;
//   final Alignment alignment;
//   final double width;
//   final double height;

//   MyCircularChart(
//       {this.amount,
//       this.chartKey,
//       this.margin = const EdgeInsets.only(bottom: 24.0),
//       this.alignment,
//       this.width = 300.0,
//       this.height = 250.0,
//       this.listChart});

//   Widget build(BuildContext context) {
//     return Container(
//         margin: margin,
//         alignment: alignment,
//         child: AnimatedCircularChart(
//           holeRadius: 70.0,
//           key: chartKey,
//           duration: Duration(seconds: 1),
//           // startAngle: 125.0,
//           size: Size(width, height),
//           percentageValues: true,
//           // holeLabel: amount,
//           // labelStyle:TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, ),
//           edgeStyle: SegmentEdgeStyle.flat,
//           initialChartData: <CircularStackEntry>[
//             CircularStackEntry(
//               listChart,
//               rankKey: 'progress',
//             ),
//           ],
//           chartType: CircularChartType.Radial,
//         ));
//   }
// }

class MyRowHeader extends StatelessWidget {
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
                child: MyText(text: "Your assets")),
          ),
          Expanded(
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

class MyTabBar extends StatelessWidget {
  final List<Widget>? listWidget;
  final Function? onTap;

  const MyTabBar({@required this.listWidget, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.whiteHexaColor),
            borderRadius: BorderRadius.circular(8)),
        width: 125.0,
        height: 48,
        child: TabBar(
          unselectedLabelColor: hexaCodeToColor(AppColors.textColor),
          indicatorColor: hexaCodeToColor(AppColors.secondarytext),
          labelColor: hexaCodeToColor(AppColors.secondarytext),
          // labelStyle: TextStyle(fontSize: 30.0),
          tabs: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
              width: double.infinity,
              child: const Icon(
                LineAwesomeIcons.phone,
                size: 23.0,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              alignment: Alignment.center,
              child: const Icon(LineAwesomeIcons.envelope, size: 23.0),
            )
          ],
          onTap: (int? value){
            onTap!(value);
          },
        ),
      ),
    );
  }
}

Future<void> customDialog(BuildContext context, String title, String contents, {Widget? btn2}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: AlertDialog(
          backgroundColor: hexaCodeToColor(AppColors.bluebgColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Align(
            child: MyText(
              text: title,
              fontWeight: FontWeight.w600,
              color: AppColors.whiteColorHexa,
              fontSize: 18, 
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0,),
            child: MyText(
              text: contents, 
              color: AppColors.whiteColorHexa,
              textAlign: TextAlign.center
            ),
          ),
          actions: <Widget>[
            btn2 ?? Container(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: MyText(text: 'Close', color: AppColors.whiteColorHexa),
            ),
          ],
        ),
      );
    },
  );
}

/* Trigger Snack Bar Function */
void snackBar(BuildContext context, String contents) {
  final snackbar = SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(contents),
  );
  // ignore: deprecated_member_use
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
  // globalKey.currentState.showSnackBar(snackbar);
}

class MyPinput extends StatelessWidget {

  final bool? obscureText;
  final GetWalletModel? getWalletM;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;

  const MyPinput({
    this.obscureText = true,
    this.getWalletM,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width - 100,
      // margin: const EdgeInsets.only(bottom: 30),
      child: Pinput(
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
          // print("On changed $value");
          // onChanged!(value);
        },
        onCompleted: onCompleted,
        // onSubmitted: onSubmit,
      ),
    );
  }
}

class ThreeDotLoading extends StatelessWidget{

  final Indicator? indicator;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  ThreeDotLoading({this.indicator = Indicator.ballPulse, this.padding, @required this.width, @required this.height});

  Widget build(BuildContext context ){
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Container(
      padding: padding,
      width: width,
      height: height,
      child: LoadingIndicator(
        indicatorType: indicator!, /// Required, The loading type of the widget
        colors: [ isDark ? Colors.white : Colors.black],       /// Optional, The color collections
        strokeWidth: 1,                     /// Optional, The stroke of the line, only applicable to widget which contains line
        backgroundColor: Colors.transparent,      /// Optional, Background of the widget
        pathBackgroundColor: isDark ? Colors.black : Colors.white
      ),
    );
  }
}
