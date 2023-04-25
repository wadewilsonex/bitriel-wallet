// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/screen/home/swap/bitriel_swap/swap.dart';
// import 'package:wallet_apps/src/screen/home/swap/letsexchange/letsexchange.dart';

// class SwapMethod extends StatelessWidget {
//   const SwapMethod({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//    return swapMethod(context);
//   }

//   Widget swapMethod(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
        

//         const Padding(
//           padding: EdgeInsets.all(paddingSize),
//           child: MyText(
//             text: "Select Swap Method",
//             fontSize: 20,
//             hexaColor: AppColors.textColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),

//         InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               Transition(child: const SwapPage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
//             );
//           },
//           child: Container(
//             margin: const EdgeInsets.all(10),
//             height: 7.h,
//             decoration: BoxDecoration(
//               border: Border.all(color: hexaCodeToColor(AppColors.primaryColor)),
//               borderRadius: BorderRadius.circular(10)
//             ),
//             child: Row(
//               children: [
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(paddingSize - 5),
//                       child: Image.asset('assets/logo/bitriel-logo-v2.png'),
//                     ),
//                     const MyText(text: "Bitriel Swap", fontSize: 18, fontWeight: FontWeight.bold,)
//                   ],
//                 ),
        
//                 const Spacer(),
        
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primaryColor),),
//                 )
//               ],
//             ),
//           ),
//         ),

//         InkWell(
//           onTap: () async{
//             Navigator.pop(context);
            
//             await showBarModalBottomSheet(
//               context: context,
//               isDismissible: false,
//               enableDrag: false,
//               backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.vertical(
//                   top: Radius.circular(25.0),
//                 ),
//               ),
//               builder: (context) => const LetsExchange(),
//             );
//           },
//           child: Container(
//             margin: const EdgeInsets.only(top: paddingSize / 2, left: 10, right: 10),
//             height: 7.h,
//             decoration: BoxDecoration(
//               border: Border.all(color: hexaCodeToColor(AppColors.primaryColor)),
//               borderRadius: BorderRadius.circular(10)
//             ),
//             child: Row(
//               children: [
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(paddingSize - 5),
//                       child: Image.asset('assets/logo/let_exchange.png'),
//                     ),
//                     const MyText(text: "LetsExchange", fontSize: 18, fontWeight: FontWeight.bold)
//                   ],
//                 ),
        
//                 const Spacer(),
        
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primaryColor),),
//                 )
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(height: 25,),

//       ],
//     );
//   }
// }
