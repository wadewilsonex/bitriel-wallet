import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/portrait_card_c.dart';
import 'package:wallet_apps/src/screen/main/json/import_json.dart';
import 'package:wallet_apps/src/screen/main/seeds_phonenumber/phone_main_screen.dart';
import 'package:wallet_apps/src/screen/main/seeds_phonenumber/register/create_phonenumber.dart';

class WelcomeBody extends StatelessWidget {

  final InputController? inputController = InputController();

  WelcomeBody({Key? key}) : super(key: key);
  // WelcomeBody({this.inputController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
    
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Image.asset(
                //   '${AppConfig.assetsPath}logo/bitriel-logo-v2.png',
                //   // height: MediaQuery.of(context).size.height * 0.25,
                //   width: MediaQuery.of(context).size.width * 0.25,
                // ),
                // const SizedBox(
                //   height: 40,
                // ),
          
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: MyText(
                    text: "Set up \nyour wallet",
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    fontSize: 20,
                    hexaColor: isDarkMode
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: MyText(
                    text: "Bitriel offer users to store, make transaction, invest, buy, sell crypto assets, and more!",
                    textAlign: TextAlign.start,
                    hexaColor: isDarkMode
                        ? AppColors.lowWhite
                        : AppColors.textColor,
                  ),
                )
              ]
            )
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: _setupMenu(context),
          ),
          
          // Column(
          //   children: [
          //     MyGradientButton(
          //       edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
          //       textButton: AppString.createAccTitle,
          //       begin: Alignment.bottomLeft,
          //       end: Alignment.topRight,
          //       action: () {
          //         // PassCodeComponent().passCode(context: context, inputController: inputController!);
    
          //         Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromCreateSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          //         // Navigator.pushNamed(context, AppString.contentBackup);
          //         // Navigator.push(context,MaterialPageRoute(builder: (context) => ContentsBackup()));
          //         // Navigator.push(context, MaterialPageRoute(builder: (context) => MyUserInfo("error shallow spin vault lumber destroy tattoo steel rose toilet school speed")));
          //       },
          //     ),
          //     MyFlatButton(
          //       isTransparent: true,
          //       textColor: isDarkMode ? AppColors.whiteHexaColor : AppColors.textColor,
          //       edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
          //       textButton: AppString.importAccTitle,
          //       action: () {
          //         // Navigator.push(context, MaterialPageRoute(builder: (context) => Passcode(label: PassCodeLabel.fromImportSeeds)));
          //         Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromImportSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          //       },
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _setupMenu(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PortraitCardItem(
                hexColor: "#263238",
                icon: const Icon(Iconsax.add_circle, color: Colors.white),
                image: Image.asset(
                  "assets/icons/setup-1.png",
                  width: 25.w,
                ),
                title: "Create a new crypto wallet",
                action: () async {
                  Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromCreateSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                },
              ),
            ),

            const SizedBox(width: 10,),

            Expanded(
              child: PortraitCardItem(
                hexColor: "#F27649",
                icon: const Icon(Iconsax.import, color: Colors.white),
                image: Image.asset(
                  "assets/icons/setup-2.png",
                  width: 35.w,
                ),
                title: "Import seed",
                action: () {
                  Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromImportSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                },
              ),
            )
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: PortraitCardItem(
                hexColor: "#5CA2E1",
                icon: const Icon(Iconsax.call_add, color: Colors.white),
                image: Image.asset(
                  "assets/icons/setup-3.png",
                  width: 40.w,
                ),
                title: "Create wallet with phone number",
                action: () {
                  // underContstuctionAnimationDailog(context: context);
                  Navigator.push(context, Transition(child: const PhoneMainScreen(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                },
              ),
            ),

            const SizedBox(width: 10,),

            Expanded(
              child: PortraitCardItem(
                hexColor: "#FFB573",
                icon: const Icon(Iconsax.import_2, color: Colors.white),
                image: Image.asset(
                  "assets/icons/setup-4.png",
                ),
                title: "Import Json",
                action: () {
                  // underContstuctionAnimationDailog(context: context);
                  Navigator.push(context, Transition(child: const ImportJson(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
