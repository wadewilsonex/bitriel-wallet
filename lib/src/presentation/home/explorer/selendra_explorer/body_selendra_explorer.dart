
import 'package:wallet_apps/index.dart';

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
          fontSize: 2.6,
        ),
    
        MyText(
          top: 2.sp,
          text: "Search Addresses and Hash",
          fontWeight: FontWeight.w500,
          bottom: 5.sp,
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
        // Navigator.push(context, Transition(child: ExplorerDetail(controller: controller.text.toString(),), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
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
        fontSize: 2.sp,
        color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,),
      ),
      decoration: InputDecoration(
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.2.sp),
          borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.2.sp),
          borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1.2.sp),
          borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
        ),

        contentPadding: EdgeInsets.only(left: 2.sp, top: 2.sp, right: 2.sp, bottom: 2.sp),

        hintText: "Search address and hash",
        hintStyle: TextStyle(
          fontSize: 2.sp,
          color: hexaCodeToColor("#AAAAAA"),
        ),

        prefixStyle: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.orangeColor), fontSize: 11.2.sp),
        
        /* Prefix Text */
        filled: true,
        fillColor: Colors.white,
        suffixIconConstraints: BoxConstraints.expand(width: 6.sp, height: 5.sp),
        suffixIcon: Icon(Iconsax.scan_barcode, color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.blackColor), size: 2.9.sp)
        // IconButton(
        //   padding: EdgeInsets.all(1.2.sp),
        //   onPressed: () {
        //     final res = Navigator.push(context, Transition(child: const QrScanner(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

        //     res.then((value) => {
        //       if(value.toString().startsWith("0x") || value.toString().startsWith("se")){
        //         Navigator.push(context, Transition(child: ExplorerDetail(controller: value.toString(),), transitionEffect: TransitionEffect.RIGHT_TO_LEFT))
        //       }
        //       else{
        //         customDialog(context, "Error", "Please scan with valid hash or address")
        //       }
        //     });
        //   },
        //   icon: Icon(Iconsax.scan_barcode, color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.blackColor), size: 2.9.sp),
        // ),
      ),
    );
  }
}