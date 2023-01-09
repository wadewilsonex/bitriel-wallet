import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/welcome_item_c.dart';

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

          // Expanded(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       // Image.asset(
          //       //   '${AppConfig.assetsPath}logo/bitriel-logo-v2.png',
          //       //   // height: MediaQuery.of(context).size.height * 0.25,
          //       //   width: MediaQuery.of(context).size.width * 0.25,
          //       // ),
          //       // const SizedBox(
          //       //   height: 40,
          //       // ),
          
          //       Padding(
          //         padding: const EdgeInsets.only(left: 20, right: 20),
          //         child: MyText(
          //           text: "Set up\nyour Bitriel wallet",
          //           fontWeight: FontWeight.w600,
          //           textAlign: TextAlign.center,
          //           fontSize: 19,
          //           hexaColor: isDarkMode
          //             ? AppColors.whiteColorHexa
          //             : AppColors.darkGrey,
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 25,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 20, right: 20),
          //         child: MyText(
          //           width: MediaQuery.of(context).size.width / 1.5,
          //           text: "Safe keeping digital assets, send, receive, trade, and more with Bitriel wallet.",
          //           textAlign: TextAlign.center,
          //           hexaColor: isDarkMode
          //             ? AppColors.lowWhite
          //             : AppColors.textColor,
          //         ),
          //       )
          //     ]
          //   )
          // ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [

          //     GoogleAuthButton(
          //       onPressed: () async {
          //         underContstuctionAnimationDailog(context: context);
          //       },
          //       style: const AuthButtonStyle(
          //         buttonType: AuthButtonType.icon,
          //         iconType: AuthIconType.secondary,
          //       ),
          //       themeMode: ThemeMode.light,
          //     ),

          //     SizedBox(width: 20.sp,),

          //     EmailAuthButton(
          //       onPressed: () async {
          //         // underContstuctionAnimationDailog(context: context);
          //         Navigator.push(
          //           context, 
          //           Transition(child: const LoginContent(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
          //         );

          //       },
          //       style: const AuthButtonStyle(
          //         buttonType: AuthButtonType.icon,
          //         iconType: AuthIconType.secondary,
          //       ),
          //       themeMode: ThemeMode.light,
          //     ),

          //     SizedBox(width: 20.sp,),

          //     CustomAuthButton(
          //       onPressed: () async {
          //         // underContstuctionAnimationDailog(context: context);
          //         // Navigator.push(context, Transition(child: const ImportJson(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          //         Navigator.push(context, Transition(child: const PhoneMainScreen(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          //       },
          //       authIcon: AuthIcon(
          //         iconPath: "assets/icons/phone-call.png",
          //         iconSize: 30,
          //       ),
          //       style: const AuthButtonStyle(
          //         buttonType: AuthButtonType.icon,
          //         iconType: AuthIconType.outlined,
          //         buttonColor: Colors.white,
          //         height: 50
          //       ),
          //       themeMode: ThemeMode.light,
          //     ),
          //   ],
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
          //         'Create wallet with mobile number',
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

          // const Spacer(),

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
                        image: Padding(
                          padding: const EdgeInsets.all(paddingSize),
                          child: Image.asset("assets/icons/setup-1.png"),
                        ),
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
                        image: Padding(
                          padding: const EdgeInsets.all(paddingSize),
                          child: Image.asset("assets/icons/setup-2.png", fit: BoxFit.cover,),
                        ),
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
              
              // Row(
              //   children: [
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20 / 2),
              //         child: WelcomeItem(
              //           title: "Create wallet",
              //           textColor: AppColors.whiteColorHexa,
              //           image: Padding(
              //             padding: const EdgeInsets.all(paddingSize),
              //             child: Image.asset("assets/icons/setup-3.png"),
              //           ),
              //           icon: Icon(Iconsax.add_circle, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 6.w),
              //           itemColor: "#5CA2E1",
              //           action: () {
              //             Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromCreateSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
              //           },
              //         ),
              //       ),
              //     ),

              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.only(bottom: 50, right: 20, left: 20 / 2),
              //         child: WelcomeItem(
              //           title: "Import wallet",
              //           textColor: AppColors.whiteColorHexa,
              //           image: Padding(
              //             padding: const EdgeInsets.all(paddingSize),
              //             child: Image.asset("assets/icons/setup-4.png"),
              //           ),
              //           icon: Icon(Iconsax.arrow_down_2, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 6.w),
              //           itemColor: "#FFB573",
              //           action: () {
              //             Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromImportSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
              //           },
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              // MyGradientButton(
              //   edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              //   textButton: AppString.createAccTitle,
              //   begin: Alignment.bottomLeft,
              //   end: Alignment.topRight,
              //   action: () {
    
              //     Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromCreateSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
              //   },
              // ),

              // MyFlatButton(
              //   isTransparent: true,
              //   textColor: isDarkMode ? AppColors.whiteHexaColor : AppColors.secondary,
              //   edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              //   textButton: AppString.importAccTitle,
              //   action: () {
                  
              //     Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromImportSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
              //   },
              // )
            ],
          ),
        ],
      ),
    );
  }
}
