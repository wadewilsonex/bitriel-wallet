import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/components/welcome_item_c.dart';
import 'package:wallet_apps/data/provider/auth/google_auth_service.dart';
import 'package:wallet_apps/presentation/screen/auth/json/json.dart';

class OnboardingBody extends StatelessWidget {
  
  final ValueNotifier<bool>? isReady;
  final InputController? inputController;
  final bool? selected;
  final Function? tabGoogle;
  final double? logoSize;

  const OnboardingBody({
    Key? key, 
    this.selected, 
    this.tabGoogle,
    this.isReady,
    this.inputController,
    this.logoSize = 100
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const MyTextConstant(
            text: "Set up your Bitriel wallet",
            textAlign: TextAlign.start,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(
            height: 20,
          ),

          const MyTextConstant(
            text: "Safe keeping digital assets, send, receive, trade, and more with Bitriel wallet.",
            textAlign: TextAlign.start,
            fontSize: 16,
          ),
      
          Row(
            children: [

              InkWell(
                child: const Text("Hello"),
            onTap: (){

              Navigator.push(
                context,
                PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                  position: Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(animation),
                  child: child,
                  );
                },
                pageBuilder: (context, animation, secondaryAnimation) => const Pincode(label: PinCodeLabel.fromCreateSeeds),
                )
              );
              // Navigator.push(
              //   context, 
              //   PageRouteBuilder(
              //     transitionDuration: const Duration(microseconds: 0),
              //     reverseTransitionDuration: const Duration(microseconds: 0),
              //     pageBuilder: (context, animation, secondaryAnimation) => const Pincode(label: PinCodeLabel.fromCreateSeeds),
              //     settings: ModalRoute.of(context)?.settings
              //   // MaterialPageRoute(
              //   //   builder: (context) => const Pincode(label: PinCodeLabel.fromCreateSeeds),
              //   )
              //   // Transition(child: const Pincode(label: PinCodeLabel.fromCreateSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
              // );
            },
          )
              
              // Expanded(
              //   child: WelcomeItem(
              //     margin: const EdgeInsets.only(top: 20, bottom: 20, right: 20 / 2),
              //     title: "Create wallet",
              //     img: "https://raw.githubusercontent.com/BITRIEL-DATA/BITRIEL-DATA.github.io/main/icons/setup-1.png",
              //     textColor: AppColors.whiteColorHexa,
              //     imageIndex: 0,
              //     icon: Icon(Iconsax.add_circle, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 35),
              //     itemColor: "#263238",
              //     action: () {
              //       Navigator.push(
              //         context, 
              //         MaterialPageRoute(
              //           builder: (context) => const Pincode(label: PinCodeLabel.fromCreateSeeds),
              //           settings: ModalRoute.of(context)?.settings
              //         )
              //         // Transition(child: const Pincode(label: PinCodeLabel.fromCreateSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
              //       );
              //     },
              //   ),
              // ),

              // Expanded(
              //   child: WelcomeItem(
              //     margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20 / 2),
              //     title: "Import wallet",
              //     img: "https://raw.githubusercontent.com/BITRIEL-DATA/BITRIEL-DATA.github.io/main/icons/setup-2.png",
              //     textColor: AppColors.whiteColorHexa,
              //     imageIndex: 1,
              //     icon: Icon(Iconsax.arrow_down_2, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 35),
              //     itemColor: "#F27649",
              //     action: () {
              //       Navigator.push(
              //         context, 
              //         MaterialPageRoute(
              //           builder: (context) => const Pincode(label: PinCodeLabel.fromImportSeeds,)
              //         )
              //         // Transition(child: , transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
              //       );
              //       // Navigator.push(
              //       //   context,
              //       //   PageRouteBuilder(
              //       //     pageBuilder: (context, animation, secondaryAnimation) {
              //       //       return const Pincode(label: PinCodeLabel.fromImportSeeds);
              //       //     },
              //       //     transitionDuration: const Duration(seconds: 500),
              //       //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
              //       //       return SlideTransition(
              //       //         position: const Animtion<Offset>(1, 0),
              //       //         child: child,
              //       //       );
              //       //     },
              //       //   ),
              //       // );
              //     },
              //   ),
              // ),

            ],
          ),
          

          // Row(
          //   children: [

          //     Expanded(
          //       child: WelcomeItem(
          //         margin: const EdgeInsets.only(right: 20 / 2),
          //         title: "Google Sign In",
          //         textColor: AppColors.whiteColorHexa,
          //         imageIndex: 2,
          //         iconIndex: 3,
          //         itemColor: "#023859",
          //         action: () {
          //           // GoogleAuthService().signInWithGoogle().then((value) => {
          //           //   debugPrint("google name: ${value!.user!.displayName}"),
          //           //   debugPrint("google name: ${value.user!.email}")
          //           // });
          //           underContstuctionAnimationDailog(context: context);
          //         },
          //       ),
          //     ),

          //     Expanded(
          //       child: WelcomeItem(
          //         margin: const EdgeInsets.only(left: 20 / 2),
          //         title: "Import Json",
          //         textColor: AppColors.whiteColorHexa,
          //         imageIndex: 4,
          //         iconIndex: 5,//pro.onBoardingImg![5].path.isEmpty ? circularWidget() : SvgPicture.file(pro.onBoardingImg![5], color: hexaCodeToColor(AppColors.whiteColorHexa), height: 35, width: 35),
          //         itemColor: "#0D6BA6",
          //         action: () {
          //           // Navigator.push(
          //           //   context,
          //           //   MaterialPageRoute(
          //           //     builder: (context) => ImportJson()
          //           //   )
          //           // );
          //           underContstuctionAnimationDailog(context: context);
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
    // Stack(
    //   children: [
        
        

    
    //     ValueListenableBuilder(
    //       valueListenable: isReady!,
    //       builder: (context, value, wg) {

    //         if (value == true) return const SizedBox();
            
    //         return Container(width: size.width, height: size.height, color: Colors.white,);   
    //       }
    //     )
    //   ],
    // );
  }
}
