
// class PincodeBody extends StatelessWidget{
  
//   final String? titleStatus;
//   final String? subStatus;
//   final PinCodeLabel? label;
//   /// [0] = is4Digit
//   /// [1] = isFirstPin
//   final List<ValueNotifier<bool?>>? valueChange;
//   // final ValueNotifier<bool>? isFirst;
//   // final bool? is4digits;
//   final List<ValueNotifier<String>>? lsControl;
//   final Function? pinIndexSetup;
//   final Function? clearPin;
//   final bool? isNewPass;
//   final Function? onPressedDigit;

//   const PincodeBody({
//     Key? key, 
//     this.titleStatus,
//     this.subStatus,
//     this.isNewPass = false,
//     this.label, 
//     // this.isFirst, 
//     // this.is4digits, 
//     this.valueChange,
//     this.lsControl, this.pinIndexSetup, this.clearPin, 
//     this.onPressedDigit
//   }) : super(key: key);


//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: appBarPassCode(context),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [

//             Expanded(
//               child: Center(
//                 child: (titleStatus == null ) ? ValueListenableBuilder(
//                   valueListenable: valueChange![1], 
//                   builder: (builder, value, wg){
//                     return MyTextConstant(
//                       text: value == true ? 'Enter PIN' : 'Verify PIN',
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ) ;
//                   }
//                 )
//                 // For Change PIN
//                 : MyTextConstant(
//                   text: titleStatus,
//                   color2: AppUtils.colorFor(titleStatus == "Invalid PIN" ? AppColors.redColor : isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor),
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//             ),
            
//             if (subStatus == null) Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (
//                   label == PinCodeLabel.fromSplash || 
//                   label == PinCodeLabel.fromSendTx || 
//                   label == PinCodeLabel.fromBackUp ||
//                   label == PinCodeLabel.fromSignMessage
//                 )
//                 const MyTextConstant(
//                   fontSize: 17,
//                   text: "Verify PIN code to continue",
//                 )
//                 else 
//                 const MyTextConstant(
//                   fontSize: 17,
//                   text: "Assign a security PIN that will be required when opening in the future Verify PIN code to continue",
//                 )  
//               ],
//             ) 
//             // For Change PIN
//             else MyTextConstant(
//               text: subStatus,
//               fontWeight: FontWeight.bold,
//               fontSize: 19,
//             ), 

//             const SizedBox(height: 50),
            
//             ValueListenableBuilder(
//               valueListenable: valueChange![0], 
//               builder: (builder, value, wg){

//                 print("is4Digti ValueListenableBuilder");
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: 
//                   value == false ? 
//                   [ 
//                     DotPin(txt: lsControl![0]),
//                     DotPin(txt: lsControl![1]),
//                     DotPin(txt: lsControl![2]),
//                     DotPin(txt: lsControl![3]),
//                     DotPin(txt: lsControl![4]),
//                     DotPin(txt: lsControl![5]),
//                   ] :
//                   [
//                     DotPin(txt: lsControl![0]),
//                     DotPin(txt: lsControl![1]),
//                     DotPin(txt: lsControl![2]),
//                     DotPin(txt: lsControl![3]),
//                   ],
//                 );
//               }
//             ),

//             const Expanded(child: SizedBox(),),
            
//             ReuseNumPad(startNumber: 1, pinIndexSetup: pinIndexSetup!, clearPin: clearPin!),
//             const SizedBox(height: 20),
//             ReuseNumPad(startNumber: 4, pinIndexSetup: pinIndexSetup!, clearPin: clearPin!),
//             const SizedBox(height: 20),
//             ReuseNumPad(startNumber: 7, pinIndexSetup: pinIndexSetup!, clearPin: clearPin!),
//             const SizedBox(height: 20),
//             ReuseNumPad(startNumber: 0, pinIndexSetup: pinIndexSetup!, clearPin: clearPin!),
            
//           ],
//         ),
//       )
//     );
    
//   }

//   PreferredSizeWidget appBarPassCode(final BuildContext context){
//     return AppBar(
//       elevation: 0,
//       title: const MyTextConstant(
//         text: "Passcode",
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//       ),
//       leading: IconButton(
//         onPressed: () => Navigator.pop(context),
//         icon: const Icon(Iconsax.arrow_left_2, size: 30, color: Colors.black,),
//       ),

//       actions: [
        
//         ValueListenableBuilder(
//           valueListenable: valueChange![1], 
//           builder: (context, vl, wg){
//             return vl == true ? TextButton(
//               onPressed: () {
//                 onPressedDigit!();
//               }, 
//               child: ValueListenableBuilder(
//                 valueListenable: valueChange![0],
//                 builder: (context, value, wg){
//                   return MyTextConstant(
//                     text: value == false ? "Use 4-digits PIN" : "Use 6-digits PIN",
//                     color2: hexaCodeToColor(AppColors.primaryColor),
//                     fontWeight: FontWeight.w700,
//                   );
//                 },
//               ),
//             ) : const SizedBox();
//           }
//         )
//       ],

//     );
//   }
// }

// class DotPin extends StatelessWidget {

//   final ValueNotifier<String>? txt;

//   const DotPin({super.key, this.txt});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 56,
//       height: 56,
//       child: Column(
//         children: [
          
//           // Expanded(
//           //   child: ValueListenableBuilder(
//           //     valueListenable: txt!, 
//           //     builder: (context, value, wg){
//           //       print("DotPin ValueListenableBuilder");
//           //       return value.isEmpty ? const SizedBox() : const Icon(Icons.circle, color: Color(0xFFF29F05),);
//           //     }
//           //   ),
//           // ),

//           Expanded(
//             child: txt!.value.isEmpty ? const SizedBox() : const Icon(Icons.circle, color: Color(0xFFF29F05),)
//             // ValueListenableBuilder(
//             //   valueListenable: txt!, 
//             //   builder: (context, value, wg){
//             //     print("DotPin ValueListenableBuilder");
//             //     return ;
//             //   }
//             // ),
//           ),
    
//           Container(
//             height: 5,
//             decoration: const BoxDecoration(
//               color: Color(0xFFF29F05)
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }

// Widget reusePinNum(
//   TextEditingController? textEditingController
// ) {

//   return Pinput(
//     length: 1,
//     obscureText: true,
//     pinAnimationType: PinAnimationType.slide,
//     controller: textEditingController,
//     defaultPinTheme: pinTheme,
//     showCursor: false,
//     preFilledWidget: const PrefillWidget(),
//     useNativeKeyboard: false,
//   );

// }

// // ignore: must_be_immutable
// class ReuseNumPad extends StatelessWidget {

//   int startNumber;
//   final Function? pinIndexSetup;
//   final Function? clearPin;

//   ReuseNumPad({
//     super.key,
//     this.startNumber = -1,
//     this.pinIndexSetup,
//     this.clearPin,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[

//         startNumber != 0 ? ReuseKeyBoardNum(
//           n: startNumber,
//           onPressed: pinIndexSetup,
//         ) : const Expanded(child: SizedBox(),),
//         const SizedBox(width: 19),

//         ReuseKeyBoardNum(
//           n: startNumber != 0 ? ++startNumber : startNumber,
//           onPressed: pinIndexSetup,
//         ),
//         const SizedBox(width: 19),

//         // If startNumber != 0: Mean Among number 1-9
//         // Else Mean Back Or Remove 1 Pin Button
//         ReuseKeyBoardNum(
//           n: (startNumber != 0) ? (++startNumber) : -1,
//           onPressed: startNumber != 0 ? pinIndexSetup : clearPin,
//           child: startNumber == 0 ? Transform.rotate(
//             angle: 70.6858347058,
//             child: Icon(Iconsax.shield_cross, color: hexaCodeToColor(isDarkMode ? AppColors.lowWhite : AppColors.lightGreyColor), size: 30),
//           ) : null,
//         ),
//       ],
//     );
//   }
// }

// // Widget reuseNumPad(
// //   int startNumber,
// //   Function pinIndexSetup,
// //   Function clearPin
// // ) {
// //   return ;
// // }

// class ReuseKeyBoardNum extends StatelessWidget {

//   final int? n;
//   final Function? onPressed;
//   final Widget? child;

//   const ReuseKeyBoardNum({super.key, this.n, this.onPressed, this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: InkWell(
//         onTap: (){
//           if (n == -1){
//             onPressed!();
//           }
//           else {
//             onPressed!('$n');
//           }
//         },
//         child: Container(
//           alignment: Alignment.center,
//           height: 55,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(50),
//             color: Colors.white
//           ),
//           child: child ?? Text(
//             '$n',
//             style: const TextStyle(
//               fontSize: 30,// * MediaQuery.of(context).textScaleFactor,
//               color: Colors.black,//isDarkMode ? Colors.white : Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }