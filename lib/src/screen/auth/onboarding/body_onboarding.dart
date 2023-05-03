import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/welcome_item_c.dart';
import 'package:wallet_apps/src/provider/auth/google_auth_service.dart';
import 'package:wallet_apps/src/screen/auth/json/json.dart';

class OnboardignBody extends StatelessWidget {

  final InputController? inputController = InputController();
  final bool? selected;
  final Function? tabGoogle;
  final double? logoSize = 100;

  OnboardignBody({Key? key, this.selected, this.tabGoogle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

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
    
        Consumer<AppProvider>(
          builder: (context, pro, wg) {
            return Column(
              children: [
                Row(
                  children: [
                    
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20 / 2),
                        child: WelcomeItem(
                          title: "Create wallet",
                          textColor: AppColors.whiteColorHexa,
                          image: pro.onBoardingImg![0].path.isEmpty ? circularWidget() : Image.file(pro.onBoardingImg![0]),
                          icon: Icon(Iconsax.add_circle, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 35),
                          itemColor: "#263238",
                          action: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => const Pincode(label: PinCodeLabel.fromCreateSeeds,) )
                              // Transition(child: const Pincode(label: PinCodeLabel.fromCreateSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                            );
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
                          image: pro.onBoardingImg![1].path.isEmpty ? circularWidget() : Image.file(pro.onBoardingImg![1], fit: BoxFit.fill,),
                          icon: Icon(Iconsax.arrow_down_2, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 35),
                          itemColor: "#F27649",
                          action: () {
                            Navigator.push(context, Transition(child: const Pincode(label: PinCodeLabel.fromImportSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
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
                          image: pro.onBoardingImg![2].path.isEmpty ? circularWidget() : Image.file(pro.onBoardingImg![2], ),
                          icon: pro.onBoardingImg![3].path.isEmpty ? circularWidget() : SvgPicture.file(pro.onBoardingImg![3], color: hexaCodeToColor(AppColors.whiteColorHexa), height: 35, width: 35),
                          itemColor: "#023859",
                          action: () {
                            // GoogleAuthService().signInWithGoogle().then((value) => {
                            //   debugPrint("google name: ${value!.user!.displayName}"),
                            //   debugPrint("google name: ${value.user!.email}")
                            // });
                            underContstuctionAnimationDailog(context: context);
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
                          image: pro.onBoardingImg![4].path.isEmpty ? circularWidget() : Image.file( pro.onBoardingImg![4],),
                          icon: pro.onBoardingImg![5].path.isEmpty ? circularWidget() : SvgPicture.file(pro.onBoardingImg![5], color: hexaCodeToColor(AppColors.whiteColorHexa), height: 35, width: 35),
                          itemColor: "#0D6BA6",
                          action: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ImportJson()
                            //   )
                            // );
                            underContstuctionAnimationDailog(context: context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                
              ],
            );
          }
        ),
      ],
    );
  }

  Widget circularWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(height: 30, width: 30, child: CircularProgressIndicator())
      ],
    );
  }
}
