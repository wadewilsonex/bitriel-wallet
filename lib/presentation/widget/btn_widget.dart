import 'package:bitriel_wallet/index.dart';

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
          color: isDarkMode ? Colors.transparent : hexaCodeToColor(AppColors.primary).withOpacity(0.50),
          width: 1,
        ) : null,
        borderRadius: BorderRadius.circular(8), 
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
            MyTextConstant(
              text: textButton!,
              color2: hexaCodeToColor(textColor!),
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