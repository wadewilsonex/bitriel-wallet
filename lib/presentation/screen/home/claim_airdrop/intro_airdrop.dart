import 'package:wallet_apps/index.dart';

class AirDropDes extends StatelessWidget {
  const AirDropDes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: "By subscribe to this event, In the future you will:\n",
            fontWeight: FontWeight.bold,
            hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            fontSize: 16,
            bottom: 5.0,
            top: 32.0,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset("${AppConfig.iconsPath}check.svg", width: 15, height: 15, color: hexaCodeToColor(AppColors.blueColor),),
                Flexible(
                  child: MyText(
                    text: "Receive 222 SEL native token when its mainnet launch on February 2nd, 2022",
                    // text:
                    //     'This swap is only applied for SEL token holders, whom received SEL v1 during the Selendra\'s airdrop first session.',
                    fontWeight: FontWeight.bold,
                    hexaColor: isDarkMode ? AppColors.darkSecondaryText : AppColors.textColor,
                    fontSize: 14.0,
                    textAlign: TextAlign.start,
                    right: 16.0,
                    left: 10,
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("${AppConfig.iconsPath}check.svg", width: 15, height: 15, color: hexaCodeToColor(AppColors.blueColor),),
              MyText(
                text: "Receive email on upcoming events such as this airdrop",
                // text:
                //     'This swap is only applied for SEL token holders, whom received SEL v1 during the Selendra\'s airdrop first session.',
                fontWeight: FontWeight.bold,
                hexaColor: isDarkMode ? AppColors.darkSecondaryText : AppColors.textColor,
                fontSize: 14.0,
                textAlign: TextAlign.start,
                right: 16.0,
                left: 10,
              )
            ],
          ),
        ],
      )
    );
  }
}