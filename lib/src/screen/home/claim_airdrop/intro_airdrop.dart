import 'package:wallet_apps/index.dart';
<<<<<<< HEAD
=======
import 'package:flutter_svg/flutter_svg.dart';
>>>>>>> dev
class AirDropDes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Padding(
<<<<<<< HEAD
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          MyText(
            width: double.infinity,
            text: "How to claim SEL token?",
=======
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: "By subscribe to this event, In the future you will:\n",
>>>>>>> dev
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
<<<<<<< HEAD
            bottom: 4.0,
            top: 32.0,
            left: 16.0,
          ),
          MyText(
            width: double.infinity,
            text: "Step 1: Make sure you have some BNB to pay for transaction fees, 1-2 USD worth of BNB would be recommended to pay to the network. Though, it would only cost around USD 0.1 - USD 0.2",
            // text:
            //     'This swap is only applied for SEL token holders, whom received SEL v1 during the Selendra\'s airdrop first session.',
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
            fontSize: 14.0,
            textAlign: TextAlign.start,
            bottom: 4.0,
            top: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          MyText(
            width: double.infinity,
            text: "Step 2: Enter your BSC address and click on submit. This will fetch an authorization signature from the whitelisted address.",
            // text:
            //     '🚀 Swap rewards: this is part of the airdrop 2. For example, if you have 100 SEL v1, after swapped you will have 200 SEL v2 to keep and use in the future.',
            fontWeight: FontWeight.bold,
            color:
                isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
            fontSize: 14.0,
            textAlign: TextAlign.start,
            bottom: 4.0,
            top: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          MyText(
            width: double.infinity,
            text: "Step 3: Confirm the transaction to cliam your SEL tokens. This will send a transaction to the Airdrop smart contract.",
            // text:
            //     '🚀 SEL v2 will be the utility token for Selendra with cross-chains capability. This meant that SEL v2 will be able to perform on both Selendra network as well as other network such as Polygon, Ethereum, BSC.',
            fontWeight: FontWeight.bold,
            color:
                isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
            fontSize: 14.0,
            textAlign: TextAlign.start,
            bottom: 4.0,
            top: 16.0,
            left: 16.0,
            right: 16.0,
=======
            fontSize: 16,
            bottom: 5.0,
            top: 32.0,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(AppConfig.iconsPath+"check.svg", width: 15, height: 15, color: hexaCodeToColor(AppColors.blueColor),),
                Flexible(
                  child: MyText(
                    text: "Receive 222 SEL native token when its mainnet launch on February 2nd, 2022",
                    // text:
                    //     'This swap is only applied for SEL token holders, whom received SEL v1 during the Selendra\'s airdrop first session.',
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
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
              SvgPicture.asset(AppConfig.iconsPath+"check.svg", width: 15, height: 15, color: hexaCodeToColor(AppColors.blueColor),),
              MyText(
                text: "Receive email on upcoming events such as this airdrop",
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
>>>>>>> dev
          ),
        ],
      )
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> dev
