import 'package:bitriel_wallet/utils/app_utils/global.dart';
import 'package:bitriel_wallet/utils/themes/colors.dart';
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
  final List<String>? lsColor;
  final List<double>? lsColorOpacity;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const MyGradientButton({
    Key? key,
    this.child,
    this.textButton = "",
    this.lsColor = const ["#F27649", "#F28907"],
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
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            hexaCodeToColor(lsColor![0]).withOpacity(lsColorOpacity![0]),
            hexaCodeToColor(lsColor![1]).withOpacity(lsColorOpacity![1])
          ],
          begin: begin,
          end: end,
          stops: const [0.25, 0.75],
        ),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            // width: 100,
            // fontSize: fontSize,
            overflow: TextOverflow.ellipsis,
          ),
      ),
    );
  }
}
