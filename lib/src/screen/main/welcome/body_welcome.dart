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
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
    
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  AppConfig.assetsPath+'logo/bitriel-logo-v2.png',
                  // height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
                SizedBox(
                  height: 40,
                ),
          
                MyText(
                  text: "Welcome!",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
                    color: isDarkTheme
                        ? AppColors.lowWhite
                        : AppColors.textColor,
                  ),
                )
              ]
            )
          ),
          
          Column(
            children: [
              MyGradientButton(
                edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                textButton: AppString.createAccTitle,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () {
                  // PassCodeComponent().passCode(context: context, inputController: inputController!);
    
                  Navigator.push(context, Transition(child: Passcode(label: PassCodeLabel.fromCreateSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                  // Navigator.pushNamed(context, AppString.contentBackup);
                  // Navigator.push(context,MaterialPageRoute(builder: (context) => ContentsBackup()));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => MyUserInfo("error shallow spin vault lumber destroy tattoo steel rose toilet school speed")));
                },
              ),
              MyFlatButton(
                isTransparent: true,
                buttonColor: AppColors.whiteHexaColor,
                edgeMargin:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                textButton: AppString.importAccTitle,
                action: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Passcode(label: PassCodeLabel.fromImportSeeds)));
                  Navigator.push(context, Transition(child: Passcode(label: PassCodeLabel.fromImportSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
