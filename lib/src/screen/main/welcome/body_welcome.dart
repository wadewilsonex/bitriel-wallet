import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:http/http.dart';
import 'package:wallet_apps/src/provider/auth/google_auth_service.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/portrait_card_c.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/json/import_json.dart';
import 'package:wallet_apps/src/screen/main/seeds_phonenumber/phone_main_screen.dart';
import 'package:wallet_apps/src/screen/main/seeds_phonenumber/register/create_phonenumber.dart';
import 'package:wallet_apps/src/screen/main/seeds_phonenumber/register/set_password/set_password.dart';

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  '${AppConfig.assetsPath}logo/bitriel-logo-v2.png',
                  // height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
                const SizedBox(
                  height: 40,
                ),
          
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: MyText(
                    // text: "Set up \nyour wallet",
                    text: "Welcome!",
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
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
                    text: "Bitriel offers users to store, transact, hold, buy, sell crypto assets, and more!",
                    textAlign: TextAlign.center,
                    hexaColor: isDarkMode
                        ? AppColors.lowWhite
                        : AppColors.textColor,
                  ),
                )
              ]
            )
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //   child: _setupMenu(context),
          // ),

          // GoogleAuthButton(
          //   onPressed: () async {
          //     // await GoogleAuthService().signOut();
          //     await GoogleAuthService().signInWithGoogle().then((value) async {
          //       if (value == null){
          //         // Navigator.pushAndRemoveUntil(
          //         //   context, 
          //         //   MaterialPageRoute(builder: (context) => HomePage()), 
          //         //   (route) => false
          //         // );
                  
          //       }
          //       print("signInWithGoogle ${value}");

          //       try {

          //         // Verify OTP with HTTPs
                  
          //         Response response = Response(await rootBundle.loadString('assets/json/phone.json'), 200);

          //         final responseJson = json.decode(response.body);
          //         print("responseJson ${responseJson.runtimeType}");
          //         print(responseJson['user'].containsKey("encrypted"));

          //         if (response.statusCode == 200) {

          //           // if(!mounted) return;
          //           if (responseJson['user'].containsKey("encrypted")){

          //             Navigator.push(context, Transition(child: SetPassword(phoneNumber: "+85511725228", responseJson: responseJson), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          //           }
                      
          //         } else if (response.statusCode == 401) {

          //           customDialog(
          //             context, 
          //             "Error",
          //             responseJson['message']
          //           );

          //           Navigator.of(context).pop();

          //         } else if (response.statusCode >= 500 && response.statusCode < 600) {

          //           customDialog(
          //             context, 
          //             "Error",
          //             responseJson['message']
          //           );

          //           Navigator.of(context).pop();

          //         }

          //       } catch (e) {
          //         print(e);
          //       }

          //     });
          //   },
          //   style: const AuthButtonStyle(
          //     buttonType: AuthButtonType.icon,
          //     iconType: AuthIconType.outlined,
          //   ),
          //   themeMode: ThemeMode.light,
          // ),
          
          // Padding(
          //   padding: const EdgeInsets.all(paddingSize + 5),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: const <Widget>[
          //       Expanded(
          //         child: Divider(
          //           thickness: 1,
          //           color: Color(0xff818181),
          //         ),
          //       ),
          //       SizedBox(width: 10),
          //       Text(
          //         'OR',
          //         style: TextStyle(color: Color(0xff818181), fontWeight: FontWeight.w500),
          //       ),
          //       SizedBox(width: 10),
          //       Expanded(
          //         child: Divider(
          //           thickness: 1,
          //           color: Color(0xff818181),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          Column(
            children: [
              MyGradientButton(
                edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                textButton: AppString.createAccTitle,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () {
                  // PassCodeComponent().passCode(context: context, inputController: inputController!);
    
                  Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromCreateSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                  // Navigator.pushNamed(context, AppString.contentBackup);
                  // Navigator.push(context,MaterialPageRoute(builder: (context) => ContentsBackup()));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => MyUserInfo("error shallow spin vault lumber destroy tattoo steel rose toilet school speed")));
                },
              ),
              MyFlatButton(
                isTransparent: true,
                textColor: isDarkMode ? AppColors.whiteHexaColor : AppColors.textColor,
                edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                textButton: AppString.importAccTitle,
                action: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Passcode(label: PassCodeLabel.fromImportSeeds)));
                  Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromImportSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                },
              )
            ],
          ),
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
