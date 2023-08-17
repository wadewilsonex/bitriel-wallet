

import 'package:bitriel_wallet/index.dart';

class MyButton extends StatelessWidget {
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
  final double opacity;
  final double isTransparentOpacity;
  final double? borderWidth;

  const MyButton({
    Key? key,
    this.child,
    this.textButton = "",
    this.buttonColor = AppColors.primaryBtn,
    this.textColor = AppColors.white,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 20,
    this.edgeMargin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.edgePadding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.hasShadow = false,
    this.width = double.infinity,
    this.height = 50,
    this.isTransparent = false,
    this.opacity = 1,
    this.isTransparentOpacity = 1,
    this.borderWidth,
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
        borderRadius: BorderRadius.circular(50),
        color: isTransparent == true ? hexaCodeToColor(AppColors.lightGrey).withOpacity(isTransparentOpacity) : hexaCodeToColor(buttonColor!).withOpacity(opacity)
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: borderWidth == null ? BorderSide.none : BorderSide(width: borderWidth!, color: hexaCodeToColor(AppColors.primaryBtn))
        ),
        onPressed: action == null
          ? null
          : () {
              action!();
            },
        child: child ??
          MyTextConstant(
            text: textButton!,
            color2: Color(int.parse("0xFF${textColor!.replaceAll("#", '')}")),
            fontWeight: fontWeight!,
            fontSize: fontSize,
            overflow: TextOverflow.ellipsis,
          ),
      ),
    );
  }
}

class MyIconButton extends StatelessWidget {
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
  final double opacity;

  const MyIconButton({
    Key? key,
    this.child,
    this.textButton = "",
    this.buttonColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 20,
    this.edgeMargin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.edgePadding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.hasShadow = false,
    this.width = double.infinity,
    this.height = 50,
    this.isTransparent = false,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isTransparent == true ? hexaCodeToColor(AppColors.lightGrey) : hexaCodeToColor(buttonColor!).withOpacity(opacity)
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: action == null
          ? null
          : () {
              action!();
            },
        child: child ??
          MyTextConstant(
            text: textButton!,
            color2: Color(int.parse("0xFF${textColor!.replaceAll("#", '')}")),
            fontWeight: fontWeight!,
            fontSize: fontSize,
            overflow: TextOverflow.ellipsis,
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
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;

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
    this.begin,
    this.end,
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
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            hexaCodeToColor(lsColor![0]).withOpacity(lsColorOpacity![0]), hexaCodeToColor(lsColor![1]).withOpacity(lsColorOpacity![1])
          ],
          begin: begin ?? Alignment.centerLeft,
          end: end ?? Alignment.centerRight, 
          stops: const [0.25, 0.75],
        ),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: action == null ? null : (){
          action!();
        },
        child: child ?? MyTextConstant(
          text: textButton!,
          color2: Color(int.parse("0xFF${textColor!.replaceAll("#", '')}")),
          fontWeight: fontWeight!,
          // width: 100,
          // fontSize: fontSize,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}