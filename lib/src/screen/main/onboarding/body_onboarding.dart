import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/welcome_item_c.dart';
import 'package:wallet_apps/src/provider/auth/google_auth_service.dart';

class OnboardignBody extends StatelessWidget {

  final InputController? inputController = InputController();
  final bool? selected;
  final Function? tabGoogle;

  OnboardignBody({Key? key, this.selected, this.tabGoogle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          
          SizedBox(
            height: 5.h,
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: "Set up\nyour Bitriel wallet",
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                  fontSize: 22,
                  hexaColor: isDarkMode
                    ? AppColors.whiteColorHexa
                    : AppColors.blackColor,
                ),
                const SizedBox(
                  height: 25,
                ),
                MyText(
                  text: "Safe keeping digital assets, send, receive, trade, and more with Bitriel wallet.",
                  textAlign: TextAlign.start,
                  hexaColor: isDarkMode
                    ? AppColors.lowWhite
                    : AppColors.darkGrey,
                )
              ],
            ),
          ),

          Column(
            children: [
              
              GoogleAuthButton(
                onPressed: () async {
                  GoogleAuthService().signInWithGoogle().then((value) => {
                    print("google name: ${value!.user!.displayName}"),
                    print("google name: ${value.user!.email}")
                  });
                },
                style: const AuthButtonStyle(
                  buttonType: AuthButtonType.icon,
                  iconType: AuthIconType.secondary,
                ),
                themeMode: ThemeMode.light,
              ),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20 / 2),
                      child: WelcomeItem(
                        title: "Create wallet",
                        textColor: AppColors.whiteColorHexa,
                        image: Image.asset("assets/icons/setup-1.png", width: 100, height: 200,),
                        icon: Icon(Iconsax.add_circle, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 6.w),
                        itemColor: "#263238",
                        action: () {
                          Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromCreateSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20 / 2),
                      child: WelcomeItem(
                        title: "Import wallet",
                        textColor: AppColors.whiteColorHexa,
                        image: Image.asset("assets/icons/setup-2.png", width: 100, height: 200,),
                        icon: Icon(Iconsax.arrow_down_2, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 6.w),
                        itemColor: "#F27649",
                        action: () {
                          Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromImportSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                        },
                      ),
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}
