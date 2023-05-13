import 'package:wallet_apps/index.dart';

class SwapDescription extends StatelessWidget {
  const SwapDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Column(
      children: [
        MyText(
          width: double.infinity,
          text: AppString.swapNote,
          fontWeight: FontWeight.bold,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          fontSize: 16,
          bottom: 4.0,
          top: 32.0,
          // left: 16.0,
        ),
        MyText(
          width: double.infinity,
          text: AppString.swapfirstNote,
          // text:
          //     'This swap is only applied for SEL token holders, whom received SEL v1 during the Selendra\'s airdrop first session.',
          fontWeight: FontWeight.bold,
          hexaColor: isDarkMode ? AppColors.darkSecondaryText : AppColors.textColor,
          fontSize: 14.0,
          textAlign: TextAlign.start,
          bottom: 4.0,
          top: 16.0,
          // left: 16.0,
          right: 16.0,
        ),
        MyText(
          width: double.infinity,
          text: AppString.swapSecondNote,
          // text:
          //     '🚀 Swap rewards: this is part of the airdrop 2. For example, if you have 100 SEL v1, after swapped you will have 200 SEL v2 to keep and use in the future.',
          fontWeight: FontWeight.bold,
          hexaColor:
              isDarkMode ? AppColors.darkSecondaryText : AppColors.textColor,
          fontSize: 14.0,
          textAlign: TextAlign.start,
          bottom: 4.0,
          top: 16.0,
          // left: 16.0,
          right: 16.0,
        ),
        MyText(
          width: double.infinity,
          text: AppString.swapThirdNote,
          // text:
          //     '🚀 SEL v2 will be the utility token for Selendra with cross-chains capability. This meant that SEL v2 will be able to perform on both Selendra network as well as other network such as Polygon, Ethereum, BSC.',
          fontWeight: FontWeight.bold,
          hexaColor:
              isDarkMode ? AppColors.darkSecondaryText : AppColors.textColor,
          fontSize: 14.0,
          textAlign: TextAlign.start,
          bottom: 4.0,
          top: 16.0,
          // left: 16.0,
          right: 16.0,
        ),
      ],
    );
  }
}
