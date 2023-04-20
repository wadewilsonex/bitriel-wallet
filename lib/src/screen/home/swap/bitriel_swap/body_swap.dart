import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/components/num_pad_c.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';
import 'package:wallet_apps/src/screen/home/swap/select_token/select_token.dart';
import 'package:wallet_apps/src/screen/home/swap/status_swap.dart';

class SwapPageBody extends StatelessWidget {
  
  final SwapPageModel? swapPageModel;
  final Function? percentTap;
  final Function? onDeleteTxt;
  final Function(String)? onChanged;
  final Function? onTabNum;
  final Function? calculateAmount;
  final Function? swapping;

  const SwapPageBody({ 
    Key? key,
    this.swapPageModel,
    this.percentTap,
    this.onChanged,
    this.onDeleteTxt,
    this.calculateAmount,
    this.swapping,
    required this.onTabNum
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        title: MyText(
          text: "Bitriel Swap",
          fontSize: 22,
          fontWeight: FontWeight.w600,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2, size: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context, 
                Transition(child: const SwapStatus(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
              );
            },
            icon: Icon(Iconsax.notification_status, color: hexaCodeToColor(AppColors.primaryColor), size: 30,),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Consumer<SwapProvider>(
              builder: (context, pro, wg) {
                return Padding(
                  padding: const EdgeInsets.all(paddingSize),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Column(
                      children: [

                        _payInput(context),

                        TextButton(
                          onPressed: ()async {
                            
                            await PostRequest().infoTwoCoin(pro.twoCoinModel!).then((value) {
                              if (value.statusCode == 200){
                                pro.resTwoCoinModel!.fromJson(json.decode(value.body));
                                pro.balance2 = pro.resTwoCoinModel!.amount.toString();
                                pro.notifyDataChanged();
                              }
                            });
                          }, 
                          child: MyText(text: "Calculate",)
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
          
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: hexaCodeToColor(isDarkMode ? AppColors.titleAssetColor : AppColors.primaryColor),
                                ),
                              ),
          
                              GestureDetector(
                                onTap: (){
                                  swapPageModel!.myController!.clear();
                                  swapPageModel!.percentActive = 0;
                                  
                                  SwapProvider swap = Provider.of<SwapProvider>(context, listen: false);
                                  dynamic tmp = swap.index1;
                                  // dynamic tmp2 = swap.index2;
          
                                  swap.index1 = swap.index2;
                                  swap.index2 = tmp;
          
                                  tmp = swap.name1;
                                  swap.name1 = swap.name2;
                                  swap.name2 = tmp;
          
                                  tmp = swap.logo1;
                                  swap.logo1 = swap.logo2;
                                  swap.logo2 = tmp;
          
                                  tmp = swap.balance1;
                                  swap.balance1 = swap.balance2;
                                  swap.balance2 = tmp;
          
                                  swap.setList();
                                  swap.notifyDataChanged();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: hexaCodeToColor(isDarkMode ? AppColors.titleAssetColor : AppColors.primaryColor)),
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(Iconsax.arrow_swap, color: hexaCodeToColor(AppColors.primaryColor), size: 25.sp,),
                                )
                              ),
          
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: hexaCodeToColor(isDarkMode ? AppColors.titleAssetColor : AppColors.primaryColor),
                                ),
                              ),
                            ],
                          )
                        ),
                        
                        _getDisplay(context),
                      ],
                    ),
                  ),
                );
              }
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
              child:  Center(
                child: _buildNumberPad(context, onDeleteTxt, onTabNum)
              ),
            ),
    
            // SizedBox(height: 60.0 - paddingSize),
            MyGradientButton(
              edgeMargin: const EdgeInsets.all(paddingSize),
              textButton: "Next",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: () async {
                // underContstuctionAnimationDailog(context: context);
                swapping!();
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
                
                const MyText(
                  text: 'You Send',
                  fontWeight: FontWeight.bold,
                  hexaColor: AppColors.primaryColor,
                  fontSize: 18,
                ),
                
                // Expanded(child: Container()),
          
                // const MyText( 
                //   text: 'Balance: ',
                // ),

                // Consumer<SwapProvider>(
                //   builder: (context, provider, widget){
                //     return Row(
                //       children: [
                //         MyText(
                //           text: provider.balance1,
                //           fontWeight: FontWeight.w600,
                          
                //         ),
                //         SizedBox(width: 1.w),
                //         MyText(
                //           text: provider.name1,
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
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      onChanged: onChanged,
                      focusNode: swapPageModel!.focusNode,
                      controller: swapPageModel!.myController,
                      textAlign: TextAlign.start,
                      showCursor: true,
                      style: TextStyle(fontSize: 24, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,), fontWeight: FontWeight.w700),
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
                          color: swapPageModel!.focusNode!.hasFocus ? hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,) : hexaCodeToColor(isDarkMode ? AppColors.greyColor : AppColors.textColor,)
                        ),
                        border: InputBorder.none,
                    
                      ),
                      // Disable the default soft keybaord
                      keyboardType: TextInputType.none,
                    ),
                  ),

                  const MyText(
                    textAlign: TextAlign.start,
                    text: '≈\$0',
                    fontSize: 18,
                  ),
                ],
              ),

              Expanded(child: Container()),

              Consumer<SwapProvider>(
                builder: (context, pro, wg) {
                  return _ddButton(
                    context: context, 
                    i: 0,
                    onPressed: () async {

                      pro.label = "first";
                      pro.balance1 = swapPageModel!.myController!.text;

                      await Navigator.push(context, Transition(child: const SelectSwapToken(), transitionEffect: TransitionEffect.BOTTOM_TO_TOP));
                      // swapPageModel!.myController!.clear();
                      swapPageModel!.percentActive = 0;
                      
                    }
                  );
                }
              ), 


            ],
          ),
          
        ],
      ),
    );
  }

  Widget _getDisplay(BuildContext context){
    return Consumer<SwapProvider>(
      builder: (context, pro, wg) {
        return Padding(
          padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Row(
                  children: [
                    const MyText(
                      text: 'You Get',
                      fontWeight: FontWeight.bold,
                      hexaColor: AppColors.primaryColor,
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
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                        child: MyText(
                          textAlign: TextAlign.start,
                          text: pro.balance2,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),

                      MyText(
                          textAlign: TextAlign.start,
                          text: '≈\$0',
                          fontSize: 18,
                        ),
                    ],
                  ),

                  Expanded(child: Container()),


                  _ddButton(
                    context: context, 
                    i: 1,
                    onPressed:  () async {

                      pro.label = "second";
                      await Navigator.push(context, Transition(child: const SelectSwapToken(), transitionEffect: TransitionEffect.BOTTOM_TO_TOP));
                      // swapPageModel!.myController!.clear();
                      swapPageModel!.percentActive = 0;

                      await PostRequest().infoTwoCoin(pro.twoCoinModel!).then((value) {
                        if (value.statusCode == 200){
                          pro.resTwoCoinModel!.fromJson(json.decode(value.body));
                          pro.balance2 = pro.resTwoCoinModel!.deposit_amount_usdt.toString();
                          pro.notifyDataChanged();
                        }
                      });
                    }
                  )  

                ],
              ),
            ],
          ),
        );
      }
    );
  }

  /// dd stand for dropdown
  Widget _ddButton({BuildContext? context, Function()? onPressed, required int? i}){
    
    return Consumer<SwapProvider>(
      builder: (context, provider, widget){
        return GestureDetector(
          onTap: onPressed!,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: hexaCodeToColor(AppColors.lightColorBg)
            ),
            child: provider.ls.isEmpty ? const MyText(text: ".....", pLeft: 20, pRight: 20, pTop: 5, pBottom: 5,) : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            
                SizedBox(
                  height: 5.h,
                  width: 10.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: (i == 0 ? provider.logo1 : provider.logo2)
                    // .contains('http') 
                    // ? SvgPicture.network(
                    //   i == 0 ? provider.logo1 : provider.logo2,
                    //   height: 6.h,
                    //   width: 6.w,
                    // )
                    // : Image.asset(
                    //   i == 0 ? provider.logo1 : provider.logo2,
                    //   height: 8.h,
                    //   width: 8.w,
                    // )
                  ),
                ),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    MyText(
                      textAlign: TextAlign.start,
                      left: 10.sp,
                      right: 10.sp,
                      text: i == 0 ? provider.name1 : provider.name2,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      hexaColor: AppColors.textColor,
                    ),

                    MyText(
                      textAlign: TextAlign.start,
                      left: 10.sp,
                      right: 10.sp,
                      text: i == 0 ? provider.networkFrom : provider.networkTo,
                      fontWeight: FontWeight.w700,
                      hexaColor: AppColors.primaryColor,
                    ),
                  ],
                ),
          
                Icon(
                  Iconsax.arrow_down_1,
                  color: hexaCodeToColor(AppColors.primaryColor),
                  size: 20.sp
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
  Widget _tapAutoAmount(BuildContext context, int percentActive, Function percentTab){
    
    List<String> percent = [
      '25%',
      '50%',
      '75%',
      '100%',
    ];

    Consumer<SwapProvider>(
      builder: (context, provider, widget){
        return Row(
          children: [
            MyText(
              text: provider.balance1,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              
            ),
            SizedBox(width: 1.w),
            MyText(
              text: provider.name1,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              
            ),
          ],
        );
      }
    );

    String tmp = ((27.608.sp)/4).toStringAsFixed(2);
    double threeSpace = double.parse(tmp);
    
    return Container(
      padding: const EdgeInsets.only(bottom: paddingSize),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          for(int i = 0; i < percent.length; i++ )
          GestureDetector(
            onTap: (){
              percentTab(i+1);
            },
            child: Row(
              children: [
                
                Container(
                  width: (MediaQuery.of(context).size.width / 4) - ((paddingSize*2)/4) - threeSpace,// - threeSpace,// - (26.0265.sp / 4),// (12.987.sp / 4),
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: percentActive == i+1 ? hexaCodeToColor(AppColors.primaryColor) : hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                  ),
                  child: MyText(
                    text: percent[i],
                    fontWeight: FontWeight.bold,
                    // color: AppColors.whiteColorHexa,
                    color2: percentActive == i+1 ? Colors.white : hexaCodeToColor(AppColors.primaryColor)
                  ),
                ),

                if (i < 3) Container(width: threeSpace + (threeSpace/3))
              ]
            )
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad(context, Function? onDeleteTxt, Function? onTabNum) {
    return NumPad(
      buttonSize: 5.h,
      buttonColor: hexaCodeToColor("#FEFEFE"),
      controller: swapPageModel!.myController!,
      delete: onDeleteTxt!,
      onTabNum: onTabNum,
      // do something with the input numbers
      onSubmit: () {
        // debugPrint('Your code: ${swapPageModel!.myController!.text}');
      },
    );
  }

}