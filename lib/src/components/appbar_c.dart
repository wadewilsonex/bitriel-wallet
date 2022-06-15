import 'package:wallet_apps/index.dart';

class AppBarCustom extends StatelessWidget {
  final double? pLeft;
  final double? pTop;
  final double? pRight;
  final double? pBottom;
  final EdgeInsetsGeometry? margin;
  final Function? onPressed;
  final Color? color;
  final Widget? tile;
  final GlobalKey<ScaffoldState>? globalKey;
  
  const AppBarCustom({
    this.pLeft = 0,
    this.pTop = 0,
    this.pRight = 0,
    this.pBottom = 0,
    this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.color,
    this.onPressed,
    this.tile,
    this.globalKey,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: globalKey,
      child: Container(
        height: 65.0,
        width: MediaQuery.of(context).size.width,
        margin: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Iconsax.profile_circle, 
                size: 25, 
                color: hexaCodeToColor(AppColors.whiteHexaColor)
              ),
              
              onPressed: () {

              },
            ),
            
            IconButton(
              icon: Icon(
                Iconsax.scan,
                size: 25,
                color: hexaCodeToColor(AppColors.whiteHexaColor),
              ),
              onPressed: () {
                
              },
            ),
          ],
        )
      )
    );
  }
}

class MyAppBar extends StatelessWidget {
  final double? pLeft;
  final double? pTop;
  final double? pRight;
  final double? pBottom;
  final EdgeInsetsGeometry? margin;
  final String? title;
  final Function? onPressed;
  final Color? color;
  final Widget? tile;
  double? fontSize;

  MyAppBar({
    this.pLeft = 0,
    this.pTop = 0,
    this.pRight = 0,
    this.pBottom = 0,
    this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    @required this.title,
    this.color,
    this.onPressed,
    this.tile,
    this.fontSize = 17
  }){
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return SafeArea(
      child: Container(
        // height: 65.0,
        width: MediaQuery.of(context).size.width,
        margin: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  /* Menu Icon */
                  iconSize: 40.0,
                  icon: Icon(
                    Platform.isAndroid
                        ? LineAwesomeIcons.arrow_left
                        : LineAwesomeIcons.angle_left,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    size: 22.5.sp,
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
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600
                ),
              ],
            ),
            tile ?? Container()
          ],
        )
      )
    );
  }
}