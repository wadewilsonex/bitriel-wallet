// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:wallet_apps/index.dart';

// class DropdownList extends StatelessWidget {
//   final bool? isValue;
//   final String? assetInfo;
//   final String? initialValue;
//   final Function? onChanged;
//   final List<Map<String, dynamic>>? listContract;

//   const DropdownList({Key? key, this.isValue, this.assetInfo, this.initialValue, this.onChanged, required this.listContract}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: ThemeData(
//         canvasColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg)
//       ),
//       child: Consumer<WalletProvider>(
//         builder: (context, value, child) {
//           return DropdownButtonHideUnderline(
//             child: DropdownButton2(
//               style: const TextStyle(fontFamily: "NotoSans", fontWeight: FontWeight.bold),
//               value: isValue == true ? initialValue : null,
//               isExpanded: true,
//               dropdownElevation: 16,
//               dropdownPadding: EdgeInsets.zero,
//               dropdownDecoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 border: Border.all(color: hexaCodeToColor(AppColors.primaryColor), width: 1)
//               ),
//               // itemHeight: 50,
//               itemPadding: EdgeInsets.zero,
//               icon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: paddingSize),
//                 child: Icon(Iconsax.arrow_down_1, color: hexaCodeToColor(AppColors.primaryColor),),
//               ),
//               items: listContract!.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
//                 return DropdownMenuItem<String>(
//                   value: value['index'].toString(),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: Container(
//                           alignment: Alignment.center,
//                           child: MyText(
//                             text: value['symbol'], 
//                             fontWeight: FontWeight.bold,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                       // Divider(
//                       //   color: hexaCodeToColor(AppColors.primaryColor), 
//                       //   height: 1,
//                       // )
//                     ],
//                   )
//                 );
//               }).toList(),
//               // value: initialValue,
//               onChanged: (String? value){
//                 onChanged!(value);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }