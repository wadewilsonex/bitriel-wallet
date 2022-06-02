import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/num_pad_c.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/screen/home/swap/select_token/select_token.dart';

class SwapPageBody extends StatelessWidget {
  
  final SwapPageModel? swapPageModel;
  final Function? percentTap;

  const SwapPageBody({ 
    Key? key,
    this.swapPageModel,
    this.percentTap
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
      
            _tapAutoAmount(context, swapPageModel!.percentActive!, percentTap!),
      
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: MyText(
                text: 'Enter how much you want to swap',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColorHexa
              ),
            ),
      
            MyText(
              text: 'Minimum value is 0.00058714 BTC',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColorHexa
            ),

            Expanded(child: Container()), 
            _buildNumberPad(context),

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
                  fontSize: 12,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 10.0),
                MyText(
                  text: '0 BTC',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppColors.whiteColorHexa,
                ),
              ],
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Expanded(
                child: TextField(
                  controller: swapPageModel!.myController,
                  textAlign: TextAlign.start,
                  showCursor: false,
                  style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  // Disable the default soft keybaord
                  keyboardType: TextInputType.none,
                )
              ),

              _buttonPayToken(context),            
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
                text: '≈0',
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColorHexa,
              ),
            ],
          ),

          Expanded(
            child: Container()
          ),

          _buttonGetToken(context),
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

  Widget _buttonPayToken(BuildContext context){
    
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
            color: hexaCodeToColor("#114463"),
            borderRadius: BorderRadius.circular(8)),
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

  Widget _buttonGetToken(BuildContext context){
    
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
            color: hexaCodeToColor("#114463"),
            borderRadius: BorderRadius.circular(8)),
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


  Widget _tapAutoAmount(BuildContext context, int percentActive, Function percentTab ){

    List<String> percent = [
      '25%',
      '50%',
      '75%',
      '100%',
    ];
    
    return Container(
      padding: EdgeInsets.only(bottom: paddingSize),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          for(int i = 0; i < percent.length; i++ )
          GestureDetector(
            onTap: (){
              percentTab(i+1);
            },
            child: Row(
              children: [
                
                Container(
                  
                  // Flow 1= Screen Size divide By 4 To Get 4 Pieces Of Box
                  // Flow 2= 48/4 for Padding LeftRight: 48 / 4
                  // Flow 3= 7.5 for Width Size Of Empty Space: 10 / 4
                  width: (MediaQuery.of(context).size.width / 4) - (48/4) - 7.5,
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: percentActive == i+1 ? hexaCodeToColor(AppColors.orangeColor) : Colors.white.withOpacity(0.06)
                  ),
                  child: MyText(
                    text: percent[i],
                    fontSize: 16,
                    // color: AppColors.whiteColorHexa,
                    color2: percentActive == i+1 ? Colors.white : Colors.white.withOpacity(0.5)
                  ),
                ),

                if (i < 3) SizedBox(width: 10)
              ]
            )
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad(context) {
    return NumPad(
      buttonSize: 50,
      buttonColor: Colors.white.withOpacity(0.06),
      iconColor: Colors.deepOrange,
      controller: swapPageModel!.myController!,
      delete: () {
        swapPageModel!.myController!.text = swapPageModel!.myController!.text.substring(0, swapPageModel!.myController!.text.length - 1);
      },
      // do something with the input numbers
      onSubmit: () {
        debugPrint('Your code: ${swapPageModel!.myController!.text}');
      },
    );
  }

}