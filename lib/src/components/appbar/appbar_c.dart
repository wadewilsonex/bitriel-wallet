import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/shimmers/shimmer_c.dart';
import 'package:wallet_apps/src/screen/home/home/home_func.dart';

PreferredSizeWidget defaultAppBar({
  required BuildContext? context,
  required HomePageModel? homePageModel,
  required bool? pushReplacement
}) {
  return AppBar(
    backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
    elevation: 0,
    toolbarHeight: 10.h,
    leadingWidth: 15.w,
    centerTitle: true,
    flexibleSpace: SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: hexaCodeToColor("#E6E6E6")),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa)
        ),
      ),
    ),

    automaticallyImplyLeading: false,
    
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Consumer<ApiProvider>(

            builder: (context, provider, child) {
              return GestureDetector(
                  onTap: () async {
                    // homePageModel!.globalKey!.currentState!.openDrawer();
                    bottomSheetAddAccount(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: AvatarShimmer(
                      height: 45,
                      width: 45,
                      txt: provider.accountM.addressIcon,
                      child: randomAvatar(provider.accountM.addressIcon ?? ''),
                    ),
                  )
              );
            }
        ),

        const Spacer(),
        
        StatefulBuilder(
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

                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: WidgetShimmer(
                          txt: provider.accountM.address,
                          child: MyText(
                            text: provider.accountM.address == null ? "" : provider.accountM.address!.replaceRange(6, provider.accountM.address!.length - 6, "......."),
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          MyText(text: "SELENDRA", hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor, fontSize: 18,),

                            Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(Iconsax.arrow_down_1, size: 25, color: isDarkMode ? Colors.white : hexaCodeToColor("#5C5C5C"),),
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

        const Spacer(),

        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: IconButton(
              iconSize: 22.sp,
              icon: Icon(
                Iconsax.scan,
                color: isDarkMode
                    ? hexaCodeToColor(homePageModel!.activeIndex == 1 ? AppColors.whiteColorHexa : AppColors.whiteColorHexa)
                    : hexaCodeToColor(homePageModel!.activeIndex == 1 ? "#6C6565" : "#6C6565"),
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
          ),
        ),
      ],
    ),
  );
}

void bottomSheetAddAccount(BuildContext context) async{
  return showBarModalBottomSheet(
    backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical( 
        top: Radius.circular(25.0),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return ListView.builder(
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) {
          return Consumer<ApiProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  index == 0 ? const SizedBox(height: 25,) : Container(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                    child: MyText(
                      text: "Wallet $index",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color2: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(paddingSize),
                    child: Row(
                      children: [
                        AvatarShimmer(
                          txt: provider.accountM.addressIcon,
                          child: randomAvatar(provider.accountM.addressIcon ?? '',),
                        ),

                        const SizedBox(width: 10),
                  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: provider.accountM.name,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.start,
                            ),

                            MyText(
                              text: provider.accountM.address == null ? "" : provider.accountM.address!.replaceRange(6, provider.accountM.address!.length - 6, "......."),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              textAlign: TextAlign.start,
                              hexaColor: AppColors.greyCode,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          );
        }
      );
    }
  );
}

// class AppBarCustom extends StatelessWidget {
//   final double? pLeft;
//   final double? pTop;
//   final double? pRight;
//   final double? pBottom;
//   final EdgeInsetsGeometry? margin;
//   final Function? onPressed;
//   final Color? color;
//   final Widget? tile;
//   final GlobalKey<ScaffoldState>? globalKey;
  
//   const AppBarCustom({Key? key, 
//     this.pLeft = 0,
//     this.pTop = 0,
//     this.pRight = 0,
//     this.pBottom = 0,
//     this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
//     this.color,
//     this.onPressed,
//     this.tile,
//     this.globalKey,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       key: globalKey,
//       child: Container(
//         height: 65.0,
//         width: MediaQuery.of(context).size.width,
//         margin: margin,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               icon: Icon(
//                 Iconsax.profile_circle, 
//                 size: 25, 
//                 color: hexaCodeToColor(AppColors.whiteHexaColor)
//               ),
              
//               onPressed: () {

//               },
//             ),
            
//             IconButton(
//               icon: Icon(
//                 Iconsax.scan,
//                 size: 25,
//                 color: hexaCodeToColor(AppColors.whiteHexaColor),
//               ),
//               onPressed: () {
                
//               },
//             ),
//           ],
//         )
//       )
//     );
//   }
// }

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