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
  
  const AppBarCustom({Key? key, 
    this.pLeft = 0,
    this.pTop = 0,
    this.pRight = 0,
    this.pBottom = 0,
    this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.color,
    this.onPressed,
    this.tile,
    this.globalKey,
  }) : super(key: key);

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
  final double? fontSize;

  const MyAppBar({
    Key? key, 
    this.pLeft = 0,
    this.pTop = 0,
    this.pRight = 0,
    this.pBottom = 0,
    this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    @required this.title,
    this.color,
    this.onPressed,
    this.tile,
    this.fontSize = 17,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Container(
        color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
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
                    Iconsax.arrow_left_2,
                    color: isDarkMode ? Colors.white : Colors.black,
                    size: 22.5.sp,
                  ),
                  onPressed: (){
                    onPressed!();
                  },
                ),
                MyText(
                  hexaColor: isDarkMode
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