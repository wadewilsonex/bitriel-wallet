import 'dart:ui';

import 'package:wallet_apps/index.dart';

class EventCardShimmerComponent extends StatelessWidget {

  const EventCardShimmerComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Shimmer.fromColors(
      period: const Duration(seconds: 2),
      baseColor: hexaCodeToColor(AppColors.whiteHexaColor),
      highlightColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          Container(
            margin: const EdgeInsets.only(left: 30, top: 30, bottom: 10),
            child: Shimmer.fromColors(
              baseColor: Colors.red.withOpacity(0.5),
              highlightColor: Colors.red,
              child: Container(
                width: 15.w,
                color: Colors.white,
                child: const MyText(
                  text: "",
                  color2: Colors.transparent,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                2,
                (i) => Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 20 : 0,
                    right: i != 19 ? 20 : 0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                  
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width - 60,
                          
                        ),
                  
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, bottom: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
                                  child: Container(
                                  // margin: const EdgeInsets.only(left: 10, bottom: 10),
                                  // alignment: Alignment.bottomLeft,
                                  decoration: BoxDecoration(
                                    // color: hexaCodeToColor("#413B3B").withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                    // border: Border.all(color: hexaCodeToColor("#383838"))
                                  ),
                                  // width: MediaQuery.of(context).size.width - 60,
                                  height: 8.h,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    
                                      Shimmer.fromColors(
                                        baseColor: hexaCodeToColor(AppColors.whiteHexaColor).withOpacity(0.5),
                                        highlightColor: Colors.white,
                                        child: const MyText(
                                          text: '',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          bottom: 5,
                                          hexaColor: "#878787",
                                        ),
                                      ),
                                    
                                      Shimmer.fromColors(
                                        baseColor: hexaCodeToColor(AppColors.whiteHexaColor).withOpacity(0.5),
                                        highlightColor: Colors.white,
                                        child: const MyText(
                                          text: '',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          bottom: 5,
                                          hexaColor: "#878787",
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            // alignment: Alignment.bottomLeft,
                            decoration: BoxDecoration(
                              color: hexaCodeToColor("#413B3B").withOpacity(0.7),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            // width: MediaQuery.of(context).size.width - 60,
                            height: 5.h,
                            width: 5.h,
                            padding: const EdgeInsets.all(10),
                            child: Icon(Iconsax.heart, color: Colors.white, size: 4.w,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
      
          ),
        ],
      )
    );
  }
}