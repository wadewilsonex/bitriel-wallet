import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transition/transition.dart';
import 'package:wallet_apps/index.dart';

class WelcomeBody extends StatelessWidget {

  final InputController? inputController = InputController();
  // WelcomeBody({this.inputController});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        SvgPicture.asset(
          AppConfig.assetsPath+'logo/bitriel-logo-v2.svg',
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.15,
        ),
        SizedBox(
          height: 50,
        ),
        MyText(
          text: "Welcome!",
          fontWeight: FontWeight.bold,
          fontSize: 26,
          color: isDarkTheme
              ? AppColors.whiteColorHexa
              : AppColors.textColor,
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: MyText(
            text: "Bitriel offer users to store, make transaction, invest, buy, sell crypto assets, and more!",
            fontSize: 18,
            color: isDarkTheme
                ? AppColors.bgdColor
                : AppColors.textColor,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
        ),
        Column(
          children: [
            MyGradientButton(
              edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              textButton: AppString.createAccTitle,
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: () {
                Navigator.push(context, Transition(child: Passcode(), transitionEffect: TransitionEffect.LEFT_TO_RIGHT));
              },
            ),
            MyFlatButton(
              isTransparent: true,
              buttonColor: AppColors.whiteHexaColor,
              edgeMargin:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              textButton: AppString.importAccTitle,
              action: () {
                Navigator.push(context, Transition(child: Passcode(), transitionEffect: TransitionEffect.LEFT_TO_RIGHT));
              },
            )
          ],
        ),
      ],
    );
  }
}
