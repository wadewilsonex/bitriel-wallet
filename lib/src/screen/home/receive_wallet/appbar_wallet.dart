import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wallet_apps/index.dart';

class QrViewTitle extends StatelessWidget {
  final bool? isValue;
  final String? assetInfo;
  final String? initialValue;
  final Function? onChanged;
  final List<Map<String, dynamic>>? listContract;

  const QrViewTitle({Key? key, this.isValue, this.assetInfo, this.initialValue, this.onChanged, required this.listContract}) : super(key: key);

  @override
  Widget build(BuildContext context) {

     

    return Consumer<WalletProvider>(
      builder: (context, value, child) {
        return DropdownButtonHideUnderline(
          child: DropdownButton2(
            value: isValue == true ? initialValue : null,
            isExpanded: true,
            dropdownElevation: 16,
            dropdownPadding: EdgeInsets.zero,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: hexaCodeToColor(AppColors.primary), width: 1)
            ),
            itemHeight: 50,
            itemPadding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_drop_down, color: hexaCodeToColor(AppColors.secondary),),
            items: listContract!.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
              return DropdownMenuItem<String>(
                value: value['index'].toString(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: MyText(text: value['symbol'], color2: Colors.white, overflow: TextOverflow.ellipsis,),
                      ),
                    ),
                    Divider(
                      color: hexaCodeToColor(AppColors.primary), 
                      height: 1,
                    )
                  ],
                )
              );
            }).toList(),
            // value: initialValue,
            onChanged: (String? value){
              onChanged!(value);
            },
          ),
        );
        // Container(
        //   // padding: EdgeInsets.symmetric(horizontal: 5.w,),
        //   // decoration: BoxDecoration(
        //   //   border: Border.all(
        //   //     color: hexaCodeToColor(AppColors.darkBgd)
        //   //   ),
        //     color: hexaCodeToColor(AppColors.whiteColorHexa),
        //   //   borderRadius: BorderRadius.circular(8)
        //   // ),
        //   child: ReuseDropDown(
        //     icon: Icon(Iconsax.arrow_down_1, color: hexaCodeToColor(AppColors.darkBgd), size: 20.sp,),
        //     initialValue: initialValue,
        //     onChanged: (String? value){
        //       onChanged!(value);
        //     },
        //     itemsList: listContract,//ContractService.getConSymbol(context, listContract!),
        //     style: TextStyle(
        //       fontSize: 15.sp,
        //       color: hexaCodeToColor(AppColors.darkBgd)
        //     ),
        //   ),
        // );
      },
    );
    // Padding(
    //   padding: EdgeInsets.only(bottom: 2.5.h),
    //   child: Stack(
    //     alignment: Alignment.center,
    //     children: [

    //       // Align(
    //       //   child: MyText(
    //       //     text: 'Wallet',
    //       //     fontSize: 20.0,
    //       //     color: isDarkMode
    //       //       ? AppColors.whiteColorHexa
    //       //       : AppColors.textColor,
    //       //   ),
    //       // ),
          
    //       if (assetInfo != null)
    //         Container()
    //       else
    //       Align(
    //         alignment: Alignment.topRight,
    //         child: Consumer<WalletProvider>(
    //           builder: (context, value, child) {
    //             return DropdownButtonHideUnderline(
    //               child: DropdownButton2(
    //                 isExpanded: true,
    //                 items: listContract!.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
    //                   return DropdownMenuItem<String>(
    //                     value: value['index'].toString(),
    //                     child: Text(value['symbol'])
    //                   );
    //                 }).toList(),
    //                 value: initialValue,
    //                 onChanged: (String? value){
    //                   onChanged!(value);
    //                 },
    //               ),
    //             );
    //             // Container(
    //             //   // padding: EdgeInsets.symmetric(horizontal: 5.w,),
    //             //   // decoration: BoxDecoration(
    //             //   //   border: Border.all(
    //             //   //     color: hexaCodeToColor(AppColors.darkBgd)
    //             //   //   ),
    //             //     color: hexaCodeToColor(AppColors.whiteColorHexa),
    //             //   //   borderRadius: BorderRadius.circular(8)
    //             //   // ),
    //             //   child: ReuseDropDown(
    //             //     icon: Icon(Iconsax.arrow_down_1, color: hexaCodeToColor(AppColors.darkBgd), size: 20.sp,),
    //             //     initialValue: initialValue,
    //             //     onChanged: (String? value){
    //             //       onChanged!(value);
    //             //     },
    //             //     itemsList: listContract,//ContractService.getConSymbol(context, listContract!),
    //             //     style: TextStyle(
    //             //       fontSize: 15.sp,
    //             //       color: hexaCodeToColor(AppColors.darkBgd)
    //             //     ),
    //             //   ),
    //             // );
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}