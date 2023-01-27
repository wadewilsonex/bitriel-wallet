import 'package:wallet_apps/index.dart';

const double height = 8.0;

const ldPadding = 1.5;

PreferredSizeWidget defaultAppBar({
  required BuildContext? context,
  required HomePageModel? homePageModel,
  required bool? pushReplacement
}) {
  return AppBar(
    backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
    elevation: 0,
    toolbarHeight: height.vmax,
    leadingWidth: 10.vmax,
    centerTitle: true,
    flexibleSpace: SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: ldPadding.vmax, right: ldPadding.vmax, top: 1.5.vmax),
        padding: EdgeInsets.symmetric(horizontal: 2.vmax),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(36.sp)),
          color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa),
          boxShadow: [
            BoxShadow(spreadRadius: 0, blurRadius: 4, offset: Offset(0, 2), color: Color.fromARGB(255, 126, 126, 126).withOpacity(0.5))
          ]
        ),
      ),
    ),
    leading: Container(
      margin: EdgeInsets.only(left: (ldPadding+1.5).vmax, top: 1.5.vmax),
      width: 5.vmax,
      height: 5.vmax,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          homePageModel!.globalKey!.currentState!.openDrawer();
        },
        icon: Icon(
          Iconsax.profile_circle, 
          color: isDarkMode 
            ? hexaCodeToColor(homePageModel!.activeIndex == 1 ? AppColors.whiteColorHexa : AppColors.whiteColorHexa) 
            : hexaCodeToColor(homePageModel!.activeIndex == 1 ? "#6C6565" : "#6C6565"),
          size: 22.sp,
        ),
      ),
    ),
    
    title: Container(
      height: 10.h,
      margin: const EdgeInsets.only(top: 10),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
    
          return Consumer<ApiProvider>(
          
            builder: (context, provider, child) {
              return GestureDetector(
                onTap: () async {
                  await HomeFunctional().changeNetwork(context: context, setState: setState);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    WidgetShimmer(
                      txt: provider.accountM.address, 
                      child: MyText(
                        text: provider.accountM.address == null ? "" : provider.accountM.address!.replaceRange(6, provider.accountM.address!.length - 6, "......."),
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center
                      ),
                    ),
              
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        MyText(text: "Selendra", hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor, fontSize: 2.2,),
              
                          Padding(
                          padding: EdgeInsets.only(left: 0.5.vmax),
                          child: Icon(Iconsax.arrow_down_1, size: 2.2.vmax, color: isDarkMode ? Colors.white : hexaCodeToColor("#5C5C5C"),),
                        )
                      ],
                    ),
                      
                  ],
                )
              );
            }
          );
    
        },
      ),
    ),
    actions: <Widget>[

      Container(
        margin: EdgeInsets.only(top: ldPadding.vmax, right: (ldPadding+2).vmax,),
        width: 5.vmax,
        height: 5.vmax,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Iconsax.scan,
            color: isDarkMode 
              ? hexaCodeToColor(homePageModel.activeIndex == 1 ? AppColors.whiteColorHexa : AppColors.whiteColorHexa) 
              : hexaCodeToColor(homePageModel.activeIndex == 1 ? "#6C6565" : "#6C6565"),
            size: 3.5.vmax,
          ),
          onPressed: () async {
            // final value = await Navigator.push(context, Transition(child: QrScanner(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
            // if (value != null){
            //   getReward!(value);
            // }
            
            await TrxOptionMethod.scanQR(
              context!,
              [],
              pushReplacement!,
            );
          },
        ),
      )
    ],
  );
}

PreferredSizeWidget secondaryAppBar({
  required BuildContext? context,
  required Widget? title,
  Widget? leading
}){
  return AppBar(
    toolbarHeight: 10.vmax,
    backgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
    iconTheme: IconThemeData(
      color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
    ),
    elevation: 0,
    bottomOpacity: 0,
    leadingWidth: 7.vmax,
    title: title,
    leading: leading ?? IconButton(
      onPressed: () {
        Navigator.of(context!).pop();
      },
      icon: Icon(
        Iconsax.arrow_left_2,
        color: isDarkMode ? Colors.white : Colors.black,
        size: 4.vmax,
      ),
    ),
  );
} 

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