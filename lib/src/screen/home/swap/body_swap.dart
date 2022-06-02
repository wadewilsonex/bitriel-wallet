import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/num_pad_c.dart';
import 'package:wallet_apps/src/screen/home/swap/select_token/select_token.dart';

class SwapPageBody extends StatelessWidget {
  
  final TextEditingController? myController;

  const SwapPageBody({ 
    Key? key,
    this.myController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        physic: BouncingScrollPhysics(),
        isSafeArea: true,
        bottom: 0,
        child: Column(
          children: [
            AppBarCustom(),

            _payInput(context),
            
            _getDisplay(context),

            _tapAutoAmount(context),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: MyText(
                text: 'Enter how much you want to swap',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColorHexa
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: paddingSize),
              child: MyText(
                text: 'Minimum value is 0.00058714 BTC',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColorHexa
              ),
            ),
            
            _buildNumberPad(context),
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

          Row(
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

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Expanded(
                child: TextField(
                  controller: myController,
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

              SizedBox(width: 100),
              _buttonPayToken(context),            
            ],
          ),
        ],
      ),
    );
  }

  Widget _getDisplay(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: paddingSize),
      child: Column(
        children: [
          Row(
            children: [
              MyText(
                text: 'You Get',
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColorHexa,
              ),
            ],
          ),
          Row(
            children: [
              MyText(
                text: '≈0',
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColorHexa,
              ),
              Expanded(child: Container()),
              SizedBox(width: 75),
               _buttonGetToken(context),
            ],
          )
          
        ],
      ),
    );
  }

  Widget _buttonPayToken(BuildContext context){
    
    return Expanded(
      child: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
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
      ),
    );
  }

  Widget _buttonGetToken(BuildContext context){
    
    return Expanded(
      child: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
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
      ),
    );
  }


  Widget _tapAutoAmount(BuildContext context){
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: hexaCodeToColor("#034A76")
              ),
              child: MyText(
                top: 5,
                text: "25%",
                color: AppColors.whiteColorHexa,
              ),
            )
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: hexaCodeToColor("#034A76")
              ),
              child: MyText(
                top: 5,
                text: "50%",
                color: AppColors.whiteColorHexa,
              ),
            )
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: hexaCodeToColor("#034A76")
              ),
              child: MyText(
                top: 5,
                text: "75%",
                color: AppColors.whiteColorHexa,
              ),
            )
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: hexaCodeToColor("#034A76")
              ),
              child: MyText(
                top: 5,
                text: "100%",
                color: AppColors.whiteColorHexa,
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad(context) {
    return Container(
      alignment: Alignment.center,  
      child: Column(
        children: <Widget>[
          // implement the custom NumPad
          NumPad(
            buttonSize: 50,
            buttonColor: Colors.white.withOpacity(0.06),
            iconColor: Colors.deepOrange,
            controller: myController!,
            delete: () {
              myController!.text = myController!.text.substring(0, myController!.text.length - 1);
            },
            // do something with the input numbers
            onSubmit: () {
              debugPrint('Your code: ${myController!.text}');
            },
          ),
        ],
      ),
    );
  }

}