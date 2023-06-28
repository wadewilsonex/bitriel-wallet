import 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';
import 'package:bitriel_wallet/standalone/utils/themes/colors.dart';
import 'package:bitriel_wallet/presentation/widget/text_widget.dart';
import 'package:flutter/material.dart';

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
  final double opacity;

  const MyGradientButton({
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
