import 'dart:ui';

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/swap/bitriel_swap/swap.dart';
import 'package:wallet_apps/src/screen/home/swap/letsexchange/letsexchange.dart';

class SwapMethod extends StatelessWidget {
  const SwapMethod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(AppColors.whiteColorHexa)
        ),
        backgroundColor: Colors.transparent,
        title: const MyText(
          text: "Swap",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          hexaColor: AppColors.whiteColorHexa,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: Stack(
        children: <Widget>[

          Container(
            height: 75.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage("assets/logo/swap.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: MyText(
              text: "Select Swap Method",
              top: 10.h,
              fontSize: 20,
              hexaColor: AppColors.whiteColorHexa,
              fontWeight: FontWeight.bold,
            ),
          ),

          DraggableScrollableSheet(
            maxChildSize: .8,
            initialChildSize: .8,
            minChildSize: .6,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.only(left:19,right:19,top: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          height: 4,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    
                    SizedBox(height: 2.h),
                    
                    swapMethod(context),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget swapMethod(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              Transition(child: const SwapPage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
            );
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            height: 7.h,
            decoration: BoxDecoration(
              border: Border.all(color: hexaCodeToColor(AppColors.primaryColor)),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(paddingSize - 5),
                      child: Image.asset('assets/logo/bitriel-logo-v2.png'),
                    ),
                    const MyText(text: "Bitriel Swap",)
                  ],
                ),
        
                const Spacer(),
        
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primaryColor),),
                )
              ],
            ),
          ),
        ),

        InkWell(
          onTap: () {
            Navigator.push(
              context,
              Transition(child: const LetsExchange(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: paddingSize / 2, left: 10, right: 10),
            height: 7.h,
            decoration: BoxDecoration(
              border: Border.all(color: hexaCodeToColor(AppColors.primaryColor)),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(paddingSize - 5),
                      child: Image.asset('assets/logo/let_exchange.png'),
                    ),
                    const MyText(text: "LetsExchange",)
                  ],
                ),
        
                const Spacer(),
        
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primaryColor),),
                )
              ],
            ),
          ),
        ),

      ],
    );
  }
}