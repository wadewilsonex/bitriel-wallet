import 'package:bitriel_wallet/index.dart';

// Future<void> seedVerifyLaterDialog(BuildContext context, Function? submit) async {

//   bool isCheck = false;
  
//   await showDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setStateWidget) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             backgroundColor: hexaCodeToColor(AppColors.whiteColorHexa),
//             content: SizedBox(
//               // height: MediaQuery.of(context).size.height / 2.6,
//               width: MediaQuery.of(context).size.width * 0.7,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [

//                     SizedBox(
//                       height: 100,
//                       width: 100,
//                       child: Lottie.asset(
//                         "assets/animation/loading-block.json",
//                         repeat: true,
//                       ),
//                     ),
//                     const MyTextConstant(
//                       text: 'Verify you Seed Phrase later?',
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
  
//                     Theme(
//                       data: ThemeData(),
//                       child: CheckboxListTile(
//                         title: const MyTextConstant(
//                           text: "I understand that if I lose my Secret Seed Phrase I will not be able to access my wallet",
//                           textAlign: TextAlign.start,
//                         ),
//                         activeColor: hexaCodeToColor(AppColors.primaryColor),
//                         value: isCheck,
//                         onChanged: (newValue) {
//                           setStateWidget(() {
//                             isCheck = newValue!;
//                           });
//                         },
//                         controlAffinity: ListTileControlAffinity.leading,
//                       ),
//                     ),

//                     SizedBox(
//                       height: MediaQuery.of(context).size.width * 0.1,
//                     ),

//                     MyFlatButton(
//                       isTransparent: true,
//                       buttonColor: AppColors.greenColor,
//                       textColor: isCheck == false ? AppColors.greyCode : AppColors.primaryColor,
//                       textButton: "Yes, Verify Later",
//                       action: () {
//                         isCheck == false ? null : submit!();
//                       },
//                     ),

//                     const SizedBox(height: 10,),

//                     MyGradientButton(
//                       textButton: "No, Verify Now",
//                       begin: Alignment.bottomLeft,
//                       end: Alignment.topRight,
//                       action: (){
//                         Navigator.pop(context);
//                       }
//                     )

//                   ],
//                 ),
//               ),
//             )
//           );
//         }
//       );
//     },
//   );
// }

Future<void> seedVerifyLaterDialog(BuildContext context, Function? submit) async {

  bool isCheck = false;
  
  showModalBottomSheet(
    context: context,
    backgroundColor: hexaCodeToColor(AppColors.white),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20), topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateWidget) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Lottie.asset(
                    "assets/animation/loading-block.json",
                    repeat: true,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                MyTextConstant(
                  text: 'Verify you Seed Phrase later?',
                  color2: hexaCodeToColor(AppColors.midNightBlue),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),

                const SizedBox(height: 10),
          
                CheckboxListTile(
                  title: MyTextConstant(
                    text: "I understand that if I lose my Secret Seed Phrase I will not be able to access my wallet",
                    textAlign: TextAlign.start,
                    color2: hexaCodeToColor(AppColors.midNightBlue),
                  ),
                  activeColor: hexaCodeToColor(AppColors.primary),
                  value: isCheck,
                  onChanged: (newValue) {
                    setStateWidget(() {
                      isCheck = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                const SizedBox(height: 10,),

                MyGradientButton(
                  textButton: "Yes, Verify Later",
                  buttonColor: AppColors.white,
                  opacity: 0,
                  textColor: isCheck == false ? AppColors.lightGrey : AppColors.primary,
                  action: (){
                    isCheck == false ? null : submit!();
                  }
                ),
          
                const SizedBox(height: 10,),
          
                MyGradientButton(
                  textButton: "No, Verify Now",
                  action: (){
                    Navigator.pop(context);
                  }
                ),

                const SizedBox(height: 10,),
          
              ],
            ),
          );
        }
      );
    },
  );
}