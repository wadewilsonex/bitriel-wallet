import 'package:wallet_apps/index.dart';

const double spacing = 15;

class BottomAppBarCom extends StatelessWidget {

  final int? index;
  final bool? apiStatus;
  final HomeModel? homeM;
  final Function? scanReceipt;
  final Function? toReceiveToken;
  final Function? fillAddress;
  final Function? contactPiker;
  final void Function()? openDrawer;
  final void Function(int index)? onIndexChanged;
  final double iconSize = 4.sp;

  BottomAppBarCom({
    Key? key,
    required this.index,
    this.apiStatus,
    this.homeM,
    this.scanReceipt,
    this.toReceiveToken,
    this.fillAddress,
    this.contactPiker,
    this.openDrawer,
    this.onIndexChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("2.sp 2.sp $iconSize");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        
        Container(
          margin: EdgeInsets.only(left: spacing.sp, bottom: spacing.sp, right: spacing.sp),

          decoration: BoxDecoration(
            // border: Border.all(color: hexaCodeToColor("#E6E6E6")),
            borderRadius: BorderRadius.all(Radius.circular(50.sp)),
            color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteColorHexa),
            boxShadow: [

              BoxShadow(spreadRadius: 0, blurRadius: 4, offset: Offset(0, 0), color: Color.fromARGB(255, 126, 126, 126).withOpacity(0.5))
            ]
          ),
          padding: EdgeInsets.symmetric(vertical: 15.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Expanded(
                child: MyIconButton(
                  title: "Explorer",
                  txtColor: index == 0 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
                  isActive: index == 0 ? true : false,
                  onPressed: () {
                    onIndexChanged!(0);
                  },
                  child: Icon(Iconsax.discover_1, size: iconSize, color: index == 0 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor), )
                ),
              ),

              Expanded(
                child: MyIconButton(
                  title: "Asset",
                  txtColor: index == 1 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
                  isActive: index == 1 ? true : false,
                  onPressed: () {
                    onIndexChanged!(1);
                    // Navigator.push(context, RouteAnimation(enterPage: AssetsPage()));
                  },
                  child: Icon(Iconsax.wallet, size: iconSize, color: index == 1 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
                ),
              ),

              Expanded(
                child: MyIconButton(
                  title: "Home",
                  txtColor: index == 2 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
                  isActive: index == 2 ? true : false,
                  onPressed: () {
                    // Navigator.push(context, RouteAnimation(enterPage: HomePage()));
                    onIndexChanged!(2);
                  },
                  child: Icon(Iconsax.home, size: iconSize, color: index == 2 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
                ),
              ),

              // Expanded(
              //   child: MyIconButton(
              //     title: "Swap",
              //     txtColor: index == 3 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
              //     onPressed: () {
              //       onIndexChanged!(3);
              //     },
              //     child: Icon(Iconsax.card_coin, size: iconSize, color: index == 3 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
              //   ),
              // ),
              // Expanded(
              //   child: MyIconButton(
              //     title: "Swap",
              //     txtColor: index == 3 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
              //     isActive: index == 3 ? true : false,
              //     onPressed: () {
              //       onIndexChanged!(3);
              //     },
              //     child: Icon(Iconsax.convert_card, size: iconSize, color: index == 3 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
              //   ),
              // ),

              Expanded(
                child: MyIconButton(
                  title: "Event",
                  txtColor: index == 3 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
                  onPressed: () {
                    onIndexChanged!(3);
                  },
                  child: Icon(Iconsax.calendar_1, size: iconSize, color: index == 3 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
                ),
              ),
              // Expanded(
              //   child: MyIconButton(
              //     title: "Setting",
              //     txtColor: index == 4 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
              //     isActive: index == 4 ? true : false,
              //     onPressed: () {
              //       onIndexChanged!(4);
              //     },
              //     child: Icon(Iconsax.setting, size: iconSize, color: index == 4 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
              //   ),
              // ),

              Expanded(
                child: MyIconButton(
                  title: "NFT",
                  txtColor: index == 4 ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor : isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor,
                  isActive: index == 4 ? true : false,
                  onPressed: () {
                    onIndexChanged!(4);
                  },
                  child: SvgPicture.asset(AppConfig.iconsPath+"nft_icon.svg", width: iconSize, color: index == 4 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))//Icon(Iconsax.setting, size: iconSize, color: index == 4 ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor) : hexaCodeToColor(isDarkMode ? AppColors.iconColor : AppColors.iconGreyColor))
                ),
              ),

            ],
          ),

        ),
      ],
    );
  }
}