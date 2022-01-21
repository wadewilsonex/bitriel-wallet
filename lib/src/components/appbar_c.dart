import 'package:wallet_apps/index.dart';

class MyAppBar extends StatelessWidget {
  final double? pLeft;
  final double? pTop;
  final double? pRight;
  final double? pBottom;
  final EdgeInsetsGeometry? margin;
  final String? title;
  final Function? onPressed;
  final Color? color;
  final Widget? trailing;

  const MyAppBar({
    this.pLeft = 0,
    this.pTop = 0,
    this.pRight = 0,
    this.pBottom = 0,
    this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    @required this.title,
    this.color,
    this.onPressed,
    this.trailing
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return SafeArea(
      child: Container(
        height: 65.0,
        width: MediaQuery.of(context).size.width,
        margin: margin,
        decoration: BoxDecoration(
          color: isDarkTheme
            ? Colors.transparent//hexaCodeToColor(AppColors.lowGrey)
            : hexaCodeToColor(AppColors.whiteHexaColor),
          boxShadow: [shadow(context)]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  /* Menu Icon */

                  padding: const EdgeInsets.only(left: 16, right: 8),
                  iconSize: 40.0,
                  icon: Icon(
                    Platform.isAndroid
                        ? LineAwesomeIcons.arrow_left
                        : LineAwesomeIcons.angle_left,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    size: 36,
                  ),
                  onPressed: (){
                    onPressed!();
                  },
                ),
                MyText(
                  color: isDarkTheme
                    ? AppColors.whiteColorHexa
                    : AppColors.textColor,
                  text: title,
                  fontSize: 22,
                  fontWeight: FontWeight.w600
                ),
              ],
            ),
            trailing ?? Container()
          ],
        )
      )
    );
  }
}

class SendAppBar extends StatelessWidget {
  final double? pLeft;
  final double? pTop;
  final double? pRight;
  final double? pBottom;
  final EdgeInsetsGeometry? margin;
  final String? title;
  final Function? onPressed;
  final Color? color;
  final Widget? trailing;

  const SendAppBar({
    this.pLeft = 0,
    this.pTop = 0,
    this.pRight = 0,
    this.pBottom = 0,
    this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    @required this.title,
    this.color,
    this.onPressed,
    this.trailing
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return SafeArea(
      child: Container(
        height: 65.0,
        width: MediaQuery.of(context).size.width,
        margin: margin,
        decoration: BoxDecoration(
          color: isDarkTheme
            ? Colors.transparent//hexaCodeToColor(AppColors.lowGrey)
            : hexaCodeToColor(AppColors.whiteHexaColor),
          boxShadow: [shadow(context)]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              color: isDarkTheme
                ? AppColors.whiteColorHexa
                : AppColors.textColor,
              text: title,
              fontSize: 15,
            ),
            trailing ?? Container()
          ],
        )
      )
    );
  }
}