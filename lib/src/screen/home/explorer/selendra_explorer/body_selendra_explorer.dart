
import 'package:wallet_apps/index.dart';

import '../explorer_detail/address_detail.dart';

class SelendraExplorerBody extends StatelessWidget {
  final TextEditingController? controller;

  const SelendraExplorerBody({
    this.controller,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MyText(
                top: 5.h,
                text: "Selendra Explorer",
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
              ),

              MyText(
                top: 2.h,
                text: "Search Addresses and Hash",
                fontWeight: FontWeight.w500,
                color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
              ),

              Expanded(child: Container()),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: _searchToken(context, controller!),
              ),
              Expanded(child: Container()),

            ],
          ),
        ),
      ),
    );
  }

  Widget _searchToken(BuildContext context, TextEditingController controller){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
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
          color: hexaCodeToColor(isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,),
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkTheme ? AppColors.bluebgColor : AppColors.orangeColor),),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkTheme ? AppColors.bluebgColor : AppColors.orangeColor),),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkTheme ? AppColors.bluebgColor : AppColors.orangeColor),),
          ),
          hintText: "Type token name",
          hintStyle: TextStyle(
            fontSize: 14,
            color: hexaCodeToColor("#AAAAAA"),
          ),
          prefixStyle: TextStyle(color: hexaCodeToColor(isDarkTheme ? AppColors.whiteHexaColor : AppColors.orangeColor), fontSize: 18.0),
          /* Prefix Text */
          filled: true,
          fillColor: hexaCodeToColor(isDarkTheme ? AppColors.bluebgColor : AppColors.lightColorBg),
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
            icon: Icon(Iconsax.scan_barcode, color: hexaCodeToColor(isDarkTheme ? AppColors.whiteHexaColor : AppColors.blackColor), size: 20),
          ),
        ),
      ),
    );
  }
}