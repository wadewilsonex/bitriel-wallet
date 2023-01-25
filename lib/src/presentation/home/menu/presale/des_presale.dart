import 'package:wallet_apps/index.dart';

class PresaleDescription extends StatelessWidget {
  const PresaleDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Column(
      children: [
        MyText(
          width: double.infinity,
          text: AppString.header,
          fontWeight: FontWeight.bold,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          bottom: 4.0,
          top: 32.0,
          left: 32.0,
          right: 32.0,
        ),
        MyText(
          width: double.infinity,
          text: AppString.contents,
          // text:
          //     'This swap is only applied for SEL token holders, whom received SEL v1 during the Selendra\'s airdrop first session.',
          fontWeight: FontWeight.bold,
          hexaColor:
              isDarkMode ? AppColors.darkSecondaryText : AppColors.textColor,
          fontSize: 2,
          textAlign: TextAlign.start,
          bottom: 0.5.vmax,
          top: 2.4.vmax,
          left: 4.8.vmax,
          right: 4.8.vmax,
        ),
      ],
    );
  }
}
