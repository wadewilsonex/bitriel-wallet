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
    return Column(
      children: [
        
        // SizedBox(
        //   height: 5.h,
        // ),
    
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
                fontSize: 25,
                hexaColor: isDarkMode
                  ? AppColors.whiteColorHexa
                  : AppColors.blackColor,
              ),
              SizedBox(
                height: 2.h,
              ),
              MyText(
                text: "Safe keeping digital assets, send, receive, trade, and more with Bitriel wallet.",
                textAlign: TextAlign.start,
                fontSize: 19,
                hexaColor: isDarkMode
                  ? AppColors.lowWhite
                  : AppColors.darkGrey,
              )
            ],
          ),
        ),
    
        Column(
          children: [
    
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20 / 2),
                    child: WelcomeItem(
                      title: "Create wallet",
                      textColor: AppColors.whiteColorHexa,
                      image: Image.asset("assets/icons/setup-1.png", ),
                      icon: Icon(Iconsax.add_circle, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 35),
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
                      image: Image.asset("assets/icons/setup-2.png", fit: BoxFit.fill,),
                      icon: Icon(Iconsax.arrow_down_2, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 35),
                      itemColor: "#F27649",
                      action: () {
                        Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromImportSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                      },
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20 / 2),
                    child: WelcomeItem(
                      title: "Google Sign In",
                      textColor: AppColors.whiteColorHexa,
                      image: Image.asset("assets/icons/setup-3.png", ),
                      icon: SvgPicture.asset("assets/icons/google-vector.svg", color: hexaCodeToColor(AppColors.whiteColorHexa), height: 35, width: 35),
                      itemColor: "#023859",
                      action: () {
                        GoogleAuthService().signInWithGoogle().then((value) => {
                          print("google name: ${value!.user!.displayName}"),
                          print("google name: ${value.user!.email}")
                        });
                      },
                    ),
                  ),
                ),
    
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20 / 2),
                    child: WelcomeItem(
                      title: "Import Json",
                      textColor: AppColors.whiteColorHexa,
                      image: Image.asset("assets/icons/setup-4.png",),
                      icon: SvgPicture.asset("assets/icons/json-file.svg", color: hexaCodeToColor(AppColors.whiteColorHexa), height: 35, width: 35),
                      itemColor: "#0D6BA6",
                      action: () {
                        
                      },
                    ),
                  ),
                ),
              ],
            ),
            
          ],
        ),
      ],
    );
  }
}
