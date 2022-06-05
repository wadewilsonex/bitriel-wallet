import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/num_pad_c.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/screen/home/swap/select_token/select_token.dart';

class SwapPageBody extends StatelessWidget {
  
  final SwapPageModel? swapPageModel;
  final Function? percentTap;
  final Function? onDeleteTxt;
  final Function(String)? onChanged;

  const SwapPageBody({ 
    Key? key,
    this.swapPageModel,
    this.percentTap,
    this.onChanged,
    this.onDeleteTxt
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
            
            _getDisplay(context),

            GestureDetector(
              onTap: () async {

                await Clipboard.setData(
                  ClipboardData(text: 1.sp.toString()),
                );
              },
              child: MyText(text: "${((27.608.sp)/4).toStringAsFixed(2)}", color2: Colors.white,)
            ),
      
            _tapAutoAmount(context, swapPageModel!.percentActive!, percentTap!),
      
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: MyText(
                text: 'Enter how much you want to swap',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColorHexa
              ),
            ),
      
            MyText(
              text: 'Minimum value is 0.00058714 BTC',
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColorHexa
            ),

            Expanded(child: Container()), 
            _buildNumberPad(context, onDeleteTxt),

            SizedBox(height: 60.0 - paddingSize),
            MyGradientButton(
              edgeMargin: EdgeInsets.all(paddingSize),
              textButton: "Next",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: () async {
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
      padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: paddingSize),
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
                  fontSize: 15.sp,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 10.0),
                MyText(
                  text: '0 BTC',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  color: AppColors.whiteColorHexa,
                ),
              ],
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Flexible(
                child: TextField(
                  onChanged: onChanged,
                  controller: swapPageModel!.myController,
                  textAlign: TextAlign.start,
                  showCursor: true,
                  style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  // Disable the default soft keybaord
                  keyboardType: TextInputType.none,
                )
              ),

              _ddButton(
                context: context, 
                onPressed: (){
                  Navigator.push(context, Transition(child: SelectSwapToken(), transitionEffect: TransitionEffect.BOTTOM_TO_TOP));
                }
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
                color: AppColors.whiteColorHexa,
              ),
            ],
          ),

          Expanded(
            child: Container()
          ),

          _ddButton(
            context: context,
            onPressed:  (){
              Navigator.push(context, Transition(child: SelectSwapToken(), transitionEffect: TransitionEffect.BOTTOM_TO_TOP));
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
  Widget _ddButton({BuildContext? context, Function()? onPressed}){
    
    return GestureDetector(
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: hexaCodeToColor(AppColors.defiMenuItem),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 2.sp),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          
              Image.asset(
                'assets/SelendraCircle-White.png',
                height: 6.h,
                width: 6.w,
              ),

              MyText(
                left: 10.sp,
                right: 10.sp,
                text: 'SEL',
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: AppColors.whiteColorHexa,
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

  Widget _buildNumberPad(context, Function? onDeleteTxt) {
    return NumPad(
      buttonSize: 50,
      buttonColor: hexaCodeToColor(AppColors.defiMenuItem),
      controller: swapPageModel!.myController!,
      delete: onDeleteTxt!,
      // do something with the input numbers
      onSubmit: () {
        debugPrint('Your code: ${swapPageModel!.myController!.text}');
      },
    );
  }

}