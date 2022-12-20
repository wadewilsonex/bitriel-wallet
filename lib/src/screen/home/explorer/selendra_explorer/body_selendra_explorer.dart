
import 'package:wallet_apps/index.dart';

import '../detail_explorer/address_detail.dart';

class SelendraExplorerBody extends StatelessWidget {
  final TextEditingController? controller;

  const SelendraExplorerBody({
    this.controller,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const MyText(
          text: "Selendra Explorer",
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
    
        MyText(
          top: 2.h,
          text: "Search Addresses and Hash",
          fontWeight: FontWeight.w500,
          bottom: 30,
        ),
    
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: _searchToken(context, controller!),
        ),
    
      ],
    );
  }

  Widget _searchToken(BuildContext context, TextEditingController controller){

    return TextFormField(
      onFieldSubmitted: (val) {
        Navigator.push(context, Transition(child: ExplorerDetail(controller: controller.text.toString(),), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
      },
      validator: (val){
        if (val.toString().startsWith("0x") || val.toString().startsWith("se")){
          return null;
        }
        return "Please enter valid string";
      },
      controller: controller,
      textInputAction: TextInputAction.search,
      style: TextStyle(
        fontSize: 14,
        color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,),
      ),
      decoration: InputDecoration(
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
        ),

        hintText: "Search address and hash",
        hintStyle: TextStyle(
          fontSize: 14,
          color: hexaCodeToColor("#AAAAAA"),
        ),

        prefixStyle: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.orangeColor), fontSize: 18.0),
        
        /* Prefix Text */
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          onPressed: () {
            final res = Navigator.push(context, Transition(child: const QrScanner(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

            res.then((value) => {
              if(value.toString().startsWith("0x") || value.toString().startsWith("se")){
                Navigator.push(context, Transition(child: ExplorerDetail(controller: value.toString(),), transitionEffect: TransitionEffect.RIGHT_TO_LEFT))
              }
              else{
                customDialog(context, "Error", "Please scan with valid hash or address")
              }
            });
          },
          icon: Icon(Iconsax.scan_barcode, color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.blackColor), size: 20),
        ),
      ),
    );
  }
}