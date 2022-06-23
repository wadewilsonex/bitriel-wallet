import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/num_pad_c.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';
import 'package:wallet_apps/src/screen/home/swap/select_token/select_token.dart';

class SwapPageBody extends StatelessWidget {
  
  final SwapPageModel? swapPageModel;
  final Function? percentTap;
  final Function? onDeleteTxt;
  final Function(String)? onChanged;
  final Function? onTabNum;
  final Function? calculateAmount;

  const SwapPageBody({ 
    Key? key,
    this.swapPageModel,
    this.percentTap,
    this.onChanged,
    this.onDeleteTxt,
    this.calculateAmount,
    required this.onTabNum
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            _payInput(context),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingSize),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: hexaCodeToColor(AppColors.titleAssetColor),
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
                      swap.notifyListeners();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: hexaCodeToColor(AppColors.titleAssetColor)),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      padding: EdgeInsets.all(5),
                      child: Icon(Iconsax.arrow_swap, color: hexaCodeToColor(AppColors.orangeColor), size: 22.sp,),
                    )
                  ),

                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: hexaCodeToColor(AppColors.titleAssetColor),
                    ),
                  ),
                ],
              )
            ),
            
            _getDisplay(context),

            SizedBox(height: 2.h),
      
            _tapAutoAmount(context, swapPageModel!.percentActive!, percentTap!),
            
            MyText(
              text: 'Enter how much you want to swap',
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColorHexa
            ),
      
            // MyText(
            //   text: 'Minimum value is 0.00058714 BTC',
            //   fontWeight: FontWeight.w500,
            //   color: AppColors.whiteColorHexa
            // ),

            Expanded(
              child:  Center(
                child: _buildNumberPad(context, onDeleteTxt, onTabNum)
              ),
            ),

            // SizedBox(height: 60.0 - paddingSize),
            MyGradientButton(
              edgeMargin: EdgeInsets.all(paddingSize),
              textButton: "Next",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: () async {
                underContstuctionAnimationDailog(context: context);
                // Navigator.push(context, Transition(child: VerifyPassphrase(createKeyModel: createKeyModel!),  transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
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
            padding: EdgeInsets.only(right: 5),
            child: Row(
              children: [
                MyText(
                  text: 'You Pay',
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColorHexa,
                ),
                
                Expanded(child: Container()),
          
                MyText(
                  text: 'Available',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 2.w),

                Consumer<SwapProvider>(
                  builder: (context, provider, widget){
                    return Row(
                      children: [
                        MyText(
                          text: provider.balance1,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.whiteColorHexa,
                        ),
                        SizedBox(width: 1.w),
                        MyText(
                          text: provider.name1,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.whiteColorHexa,
                        ),
                      ],
                    );
                  }
                ),
              ],
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  focusNode: swapPageModel!.focusNode,
                  controller: swapPageModel!.myController,
                  textAlign: TextAlign.start,
                  showCursor: true,
                  style: TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.w800),
                  inputFormatters: [
                    // LengthLimitingTextInputFormatter(4),
                    // FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0.4}'))
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    hintText: "0",
                    hintStyle: TextStyle(
                      fontSize: 20.sp,
                      color: swapPageModel!.focusNode!.hasFocus ? hexaCodeToColor(AppColors.iconColor) : Colors.white
                    ),
                    border: InputBorder.none,

                  ),
                  // Disable the default soft keybaord
                  keyboardType: TextInputType.none,
                )
              ),

              SizedBox(width: 5.w),

              Flexible(
                flex: 0,
                child: _ddButton(
                  context: context, 
                  i: 0,
                  onPressed: (){
                    Provider.of<SwapProvider>(context, listen: false).label = "first";
                    Navigator.push(context, Transition(child: SelectSwapToken(), transitionEffect: TransitionEffect.BOTTOM_TO_TOP));
                    swapPageModel!.myController!.clear();
                    swapPageModel!.percentActive = 0;
                  }
                ),
              ),            
            ],
          ),
        ],
      ),
    );
  }

  Widget _getDisplay(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText(
                text: 'You Get',
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColorHexa,
              ),

              MyText(
                text: '≈ 0',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.whiteColorHexa,
              ),
            ],
          ),

          Expanded(
            child: Container()
          ),

          _ddButton(
            context: context,
            i: 1,
            onPressed:  (){
              Provider.of<SwapProvider>(context, listen: false).label = "second";
              Navigator.push(context, Transition(child: SelectSwapToken(), transitionEffect: TransitionEffect.BOTTOM_TO_TOP));
              swapPageModel!.myController!.clear();
              swapPageModel!.percentActive = 0;
            }
          )
        ],
      ),
      // Row(
      //   children: [
      //     Expanded(child: Container()),
      //     SizedBox(width: 75),
      //   ],
      // ),
    );
  }

  /// dd stand for dropdown
  Widget _ddButton({BuildContext? context, Function()? onPressed, required int? i}){
    
    return Consumer<SwapProvider>(
      builder: (context, provider, widget){
        return GestureDetector(
          child: Container(
            width: 35.w,
            decoration: BoxDecoration(
              color: hexaCodeToColor(AppColors.defiMenuItem),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 13.sp),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              
                  SizedBox(
                    height: 6.w,
                    width: 6.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        i == 0 ? provider.logo1 : provider.logo2,
                        height: 6.h,
                        width: 6.w,
                      )
                    ),
                  ),
                  Expanded(
                    child: MyText(
                      textAlign: TextAlign.start,
                      left: 10.sp,
                      right: 10.sp,
                      text: i == 0 ? provider.name1 : provider.name2,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: AppColors.whiteColorHexa,
                    )
                  ),

                  Icon(
                    Iconsax.arrow_down_1,
                    color: hexaCodeToColor(AppColors.whiteColorHexa),
                    size: 17.sp
                  ),
                ],
              ),
            ),
          ),
          
          onTap: onPressed!,
        );
      },
    );
  }

  Widget _buttonGetToken(BuildContext context){
    
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: hexaCodeToColor(AppColors.defiMenuItem),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/SelendraCircle-White.png',
                height: 25,
                width: 25,
              ),

              Expanded(child: Container()),

              MyText(
                top: 5,
                text: 'SEL',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.whiteColorHexa,
              ),

              Expanded(child: Container()),

              Icon(
                Iconsax.arrow_down_1,
                color: hexaCodeToColor(AppColors.whiteColorHexa),
              ),
            ],
          ),
        ),
      ),
      
      onTap: (){
        Navigator.push(context, RouteAnimation(enterPage: SelectSwapToken()));
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
              color: AppColors.whiteColorHexa,
            ),
            SizedBox(width: 1.w),
            MyText(
              text: provider.name1,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.whiteColorHexa,
            ),
          ],
        );
      }
    );

    String tmp = ((27.608.sp)/4).toStringAsFixed(2);
    double threeSpace = double.parse(tmp);
    
    return Container(
      padding: EdgeInsets.only(bottom: paddingSize),
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
                    color: percentActive == i+1 ? hexaCodeToColor(AppColors.orangeColor) : hexaCodeToColor(AppColors.defiMenuItem)
                  ),
                  child: MyText(
                    text: percent[i],
                    fontSize: 14,
                    // color: AppColors.whiteColorHexa,
                    color2: percentActive == i+1 ? Colors.white : Colors.white.withOpacity(0.5)
                  ),
                ),

                if (i < 3) Container(width: threeSpace + (threeSpace/3))
              ]
            )
          ),

          // for(int i = 0; i < percent.length; i++ )
          // GestureDetector(
          //   onTap: (){
          //     percentTab(i+1);
          //   },
          //   child: Row(
          //     children: [
                
          //       Container(width: threeSpace, color: Colors.red, height: 10,)
          //     ]
          //   )
          // ),
        ],
      ),
    );
  }

  Widget _buildNumberPad(context, Function? onDeleteTxt, Function? onTabNum) {
    return NumPad(
      buttonSize: 5.h,
      buttonColor: hexaCodeToColor(AppColors.defiMenuItem),
      controller: swapPageModel!.myController!,
      delete: onDeleteTxt!,
      onTabNum: onTabNum,
      // do something with the input numbers
      onSubmit: () {
        debugPrint('Your code: ${swapPageModel!.myController!.text}');
      },
    );
  }

}