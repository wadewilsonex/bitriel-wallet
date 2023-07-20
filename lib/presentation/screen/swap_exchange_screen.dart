import 'package:bitriel_wallet/index.dart';

class SwapExchange extends StatelessWidget {
  const SwapExchange({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: "Swap"),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  children: [

                    _payInput(context),

                    // TextButton(
                    //   onPressed: ()async {
                        
                    //     await PostRequest().infoTwoCoin(pro.twoCoinModel!).then((value) {
                    //       if (value.statusCode == 200){
                    //         pro.resTwoCoinModel!.fromJson(json.decode(value.body));
                    //         pro.balance2 = pro.resTwoCoinModel!.amount.toString();
                    //         pro.notifyDataChanged();
                    //       }
                    //     });
                    //   }, 
                    //   child: MyText(text: "Calculate",)
                    // ),

                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: IconButton(
                    //     onPressed: () {
                    
                    //     }, 
                    //     color: hexaCodeToColor(AppColors.primary),
                    //     icon: Icon(Iconsax.refresh_2,)
                    //   ),
                    // ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: GestureDetector(
                          onTap: (){
                            // swapPageModel!.myController!.clear();
                            // swapPageModel!.percentActive = 0;
                            
                            // SwapProvider swap = Provider.of<SwapProvider>(context, listen: false);
                            // dynamic tmp = swap.index1;
                            // // dynamic tmp2 = swap.index2;
                            
                            // swap.index1 = swap.index2;
                            // swap.index2 = tmp;
                            
                            // tmp = swap.name1;
                            // swap.name1 = swap.name2;
                            // swap.name2 = tmp;
                            
                            // tmp = swap.logo1;
                            // swap.logo1 = swap.logo2;
                            // swap.logo2 = tmp;
                            
                            // tmp = swap.balance1;
                            // swap.balance1 = swap.balance2;
                            // swap.balance2 = tmp;
                            
                            // swap.setList();
                            // swap.notifyDataChanged();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: hexaCodeToColor(isDarkMode ? AppColors.titleAssetColor : AppColors.primaryColor)),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Icon(Iconsax.arrow_down_1, color: hexaCodeToColor(AppColors.primaryColor), size: 25,),
                          )
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: paddingSize,),

                    _getDisplay(context),
                  ],
                ),
              ),
            ),

            // SizedBox(height: 2.h),
      
            // _tapAutoAmount(context, swapPageModel!.percentActive!, percentTap!),
            
            // SizedBox(height: 2.h),

            // const MyText(
            //   text: 'Enter how much you want to swap',
            //   fontWeight: FontWeight.bold,
            //   fontSize: 17,
            // ),
    
            Expanded(
              child: Container()
            ),

            ReuseNumPad(startNumber: 1, pinIndexSetup: null, clearPin: null),
            const SizedBox(height: 20),
            ReuseNumPad(startNumber: 4, pinIndexSetup: null, clearPin: null),
            const SizedBox(height: 20),
            ReuseNumPad(startNumber: 7, pinIndexSetup: null, clearPin: null),
            const SizedBox(height: 20),
            ReuseNumPad(startNumber: 0, pinIndexSetup: null, clearPin: null),
            const SizedBox(height: 19),
    
            // SizedBox(height: 60.0 - paddingSize),
            MyButton(
              edgeMargin: const EdgeInsets.all(paddingSize),
              textButton: "Review Swap",
              action: () async {
                // underContstuctionAnimationDailog(context: context);
                // swapping!();
              },
            ),
      
          ],
        ),
      ),
    );
  }

    Widget _payInput(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top: paddingSize, left: paddingSize, right: paddingSize),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              children: [
                
                MyTextConstant(
                  text: 'You Send',
                  fontWeight: FontWeight.bold,
                  color2: hexaCodeToColor(AppColors.midNightBlue),
                  fontSize: 18,
                ),
                
              ],
            ),
          ),
          
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      autofocus: true,
                      textAlign: TextAlign.start,
                      showCursor: true,
                      style: TextStyle(
                        fontSize: 24, 
                        color: hexaCodeToColor(AppColors.textColor,), 
                        fontWeight: FontWeight.w700
                      ),
                      inputFormatters: [
                        // LengthLimitingTextInputFormatter(4),
                        // FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0.4}'))
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: "0",
                        hintStyle: TextStyle(
                          fontFamily: "NotoSans",
                          fontSize: 24,
                          color: hexaCodeToColor(AppColors.greyCode,)
                        ),
                        border: InputBorder.none,
                    
                      ),
                      // Disable the default soft keybaord
                      keyboardType: TextInputType.none,
                    ),
                  ),

                  // const MyText(
                  //   textAlign: TextAlign.start,
                  //   text: '≈\$0',
                  //   fontSize: 18,
                  // ),
                ],
              ),

              Expanded(child: Container()),

              // _ddButton(
              //   context: context, 
              //   i: 0,
              //   onPressed: () async {

                 
              //   }
              // ),

            ],
          ),
          
        ],
      ),
    );
  }
  
  Widget _getDisplay(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              children: [
                MyTextConstant(
                  text: 'You Get',
                  fontWeight: FontWeight.bold,
                  color2: hexaCodeToColor(AppColors.midNightBlue),
                  fontSize: 18,
                ),

                Expanded(child: Container()),

                // const MyText( 
                //   text: 'Balance: ',
                // ),

                // Consumer<SwapProvider>(
                //   builder: (context, provider, widget){
                //     return Row(
                //       children: [
                //         MyText(
                //           text: provider.balance2,
                //           fontWeight: FontWeight.w600,
                          
                //         ),
                //         SizedBox(width: 1.w),
                //         MyText(
                //           text: provider.name2,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ],
                //     );
                //   }
                // ),
              ],
            ),
          ),    
          
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // pro.balance2.isNotEmpty ?
                  Padding(
                    padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                    child: MyTextConstant(
                      textAlign: TextAlign.start,
                      // text: pro.lstConvertCoin![pro.name2] != null ? "≈ ${pro.lstConvertCoin![pro.name2]}" : "≈ 0",
                      text: "≈ 0",
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  )
                ],
              ),

              Expanded(child: Container()),


              // _ddButton(
              //   context: context, 
              //   i: 1,
              //   onPressed:  () async {

                
              //   }
              // )  

            ],
          ),
        ],
      ),
    );
  }

  /// dd stand for dropdown
  // Widget _ddButton({BuildContext? context, Function()? onPressed, required int? i}){
    
  //   return GestureDetector(
  //     onTap: onPressed!,
  //     child: Container(
  //       padding: const EdgeInsets.all(8),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //         color: hexaCodeToColor(AppColors.lightColorBg)
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
        
  //           SizedBox(
  //             height: 5,
  //             width: 10,
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(50),
  //               child: Placeholder()
  //               // .contains('http') 
  //               // ? SvgPicture.network(
  //               //   i == 0 ? provider.logo1 : provider.logo2,
  //               //   height: 6.h,
  //               //   width: 6.w,
  //               // )
  //               // : Image.asset(
  //               //   i == 0 ? provider.logo1 : provider.logo2,
  //               //   height: 8.h,
  //               //   width: 8.w,
  //               // )
  //             ),
  //           ),
            
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [

  //               MyTextConstant(
  //                 textAlign: TextAlign.start,
  //                 text: i == 0 ? provider.name1 : provider.name2,
  //                 fontWeight: FontWeight.w700,
  //                 fontSize: 18,
  //                 hexaColor: AppColors.textColor,
  //               ),

  //               MyText(
  //                 textAlign: TextAlign.start,
  //                 left: 10.sp,
  //                 right: 10.sp,
  //                 text: i == 0 ? provider.networkFrom : provider.networkTo,
  //                 fontWeight: FontWeight.w700,
  //                 hexaColor: AppColors.primaryColor,
  //               ),
  //             ],
  //           ),
      
  //           Icon(
  //             Iconsax.arrow_down_1,
  //             color: hexaCodeToColor(AppColors.primaryColor),
  //             size: 20.sp
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// Size of middle space = 15 per spot
  /// 
  /// 1.Find Empty Space = find both padding size and By 4 To Get 4 Pieces Of Box
  ///   
  ///   => 1.1. (Remove padding Size) = By minus leftRight 30px()
  ///   
  ///   => 1.2. (Remove pixel each 4 cell) = 27.608.sp(For responsive) will qual 11.25 after fixed decimal
  /// 
  /// 2. Remove  = 30/4 for Padding LeftRight: 30 / 4
  /// 
  /// Flow 3= 7.5 for Width Size Of Empty Space: 10 / 4
  // Widget _tapAutoAmount(BuildContext context, int percentActive, Function percentTab){
    
  //   List<String> percent = [
  //     '25%',
  //     '50%',
  //     '75%',
  //     '100%',
  //   ];

  //   Consumer<SwapProvider>(
  //     builder: (context, provider, widget){
  //       return Row(
  //         children: [
  //           MyText(
  //             text: provider.balance1,
  //             fontWeight: FontWeight.w600,
  //             fontSize: 14,
              
  //           ),
  //           SizedBox(width: 1.w),
  //           MyText(
  //             text: provider.name1,
  //             fontWeight: FontWeight.w600,
  //             fontSize: 14,
              
  //           ),
  //         ],
  //       );
  //     }
  //   );

  //   String tmp = ((27.608.sp)/4).toStringAsFixed(2);
  //   double threeSpace = double.parse(tmp);
    
  //   return Container(
  //     padding: const EdgeInsets.only(bottom: paddingSize),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [

  //         for(int i = 0; i < percent.length; i++ )
  //         GestureDetector(
  //           onTap: (){
  //             percentTab(i+1);
  //           },
  //           child: Row(
  //             children: [
                
  //               Container(
  //                 width: (MediaQuery.of(context).size.width / 4) - ((paddingSize*2)/4) - threeSpace,// - threeSpace,// - (26.0265.sp / 4),// (12.987.sp / 4),
  //                 padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 8),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(8.0),
  //                   color: percentActive == i+1 ? hexaCodeToColor(AppColors.primaryColor) : hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
  //                 ),
  //                 child: MyText(
  //                   text: percent[i],
  //                   fontWeight: FontWeight.bold,
  //                   // color: AppColors.whiteColorHexa,
  //                   color2: percentActive == i+1 ? Colors.white : hexaCodeToColor(AppColors.primaryColor)
  //                 ),
  //               ),

  //               if (i < 3) Container(width: threeSpace + (threeSpace/3))
  //             ]
  //           )
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildNumberPad(context, Function? onDeleteTxt, Function? onTabNum) {
  //   return NumPad(
  //     buttonSize: 5,
  //     buttonColor: hexaCodeToColor("#FEFEFE"),
  //     controller: swapPageModel!.myController!,
  //     delete: onDeleteTxt!,
  //     onTabNum: onTabNum,
  //     // do something with the input numbers
  //     onSubmit: () {
  //       // debugPrint('Your code: ${swapPageModel!.myController!.text}');
  //     },
  //   );
  // }

}