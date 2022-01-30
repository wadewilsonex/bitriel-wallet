import 'package:wallet_apps/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
class AirDropDes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: "By subscribe to this event, In the future you will:\n",
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            fontSize: 16,
            bottom: 5.0,
            top: 32.0,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AppConfig.iconsPath+"check.svg", width: 15, height: 15),
                MyText(
                  text: "Receive some \$SEL to your wallet",
                  // text:
                  //     'This swap is only applied for SEL token holders, whom received SEL v1 during the Selendra\'s airdrop first session.',
                  fontWeight: FontWeight.bold,
                  color: isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
                  fontSize: 14.0,
                  textAlign: TextAlign.start,
                  right: 16.0,
                  left: 10,
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AppConfig.iconsPath+"check.svg", width: 15, height: 15),
              MyText(
                text: "Receive email about upcoming event",
                // text:
                //     'This swap is only applied for SEL token holders, whom received SEL v1 during the Selendra\'s airdrop first session.',
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
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