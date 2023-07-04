import 'package:bitriel_wallet/index.dart';

Widget myText2(
  BuildContext context,
  {
    String? text = '',
    // String? hexaColor,
    Color? color2 = Colors.black,
    double? fontSize = 14,
    FontWeight? fontWeight = FontWeight.normal,
    TextAlign? textAlign = TextAlign.center,
    TextOverflow? overflow = TextOverflow.visible
  }
){
  return Text(
    text!,
    style: TextStyle(
      fontWeight: fontWeight,
      color: color2,//AppUtils.colorSelector(isDark: isDarkMode, hexaColor: hexaColor, enumColor: color2),
      fontSize: fontSize!
    ),
    textAlign: textAlign,
    overflow: overflow
  );
  // Consumer<ThemeProvider>(
  //   builder: (context, themePro, widget) {
  //     return 
  //   }
  // );
}