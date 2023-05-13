// import 'package:animate_do/animate_do.dart';
// import 'package:flutter_verification_code/flutter_verification_code.dart';
// import 'package:http/http.dart';
// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/backend/post_request.dart';
// import 'package:wallet_apps/src/screen/main/social_login/set_password/set_password.dart';

// class OPTVerification extends StatefulWidget {

//   final String? phoneNumber;
//   const OPTVerification({ Key? key, this.phoneNumber }) : super(key: key);

//   @override
//   OPTVerificationState createState() => OPTVerificationState();
// }

// class OPTVerificationState extends State<OPTVerification> {

//   bool _isResendAgain = false;
//   bool _isVerified = false;
//   bool _isLoading = false;
//   bool _onEditing = true;

//   String _code = '';

//   late Timer _timer;
//   int _start = 60;
//   int _currentIndex = 0;

//   void resend() {
//     if(!mounted) return;
//     setState(() {
//       _isResendAgain = true;
//     });

//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(oneSec, (timer) { 
//       if(!mounted) return;
//       setState(() {
//         if (_start == 0) {
//           _start = 60;
//           _isResendAgain = false;
//           timer.cancel();
//         } else {
//           _start--;
//         }
//       });
//     });
//   }

//   verify() {
//     if(!mounted) return;
//     setState(() {
//       _isLoading = true;
//     });

//     const oneSec = Duration(milliseconds: 2000);
//     _timer = Timer.periodic(oneSec, (timer) { 
//       if(!mounted) return;
//       setState(() {
//         _isLoading = false;
//         _isVerified = true;
//       });
//     });

//     _optRegister();
//   }

//  Future<void> _optLogin() async {
//     try {
//       final response = await PostRequest().loginVerifyOPT(widget.phoneNumber!, _code);

//       final responseJson = json.decode(response.body);

//       if (response.statusCode == 200) {

//         if(!mounted) return;
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => ImportJson(json: responseJson))
//         // );
          
//       } else if (response.statusCode == 401) {

//         if(!mounted) return;
//         customDialog(
//           context, 
//           "Error",
//           responseJson['message']
//         );

//         if(!mounted) return;
//         Navigator.of(context).pop();

//       } else if (response.statusCode >= 500 && response.statusCode < 600) {

//         if(!mounted) return;
//         customDialog(
//           context, 
//           "Error",
//           responseJson['message']
//         );

//         if(!mounted) return;
//         Navigator.of(context).pop();

//       }

//     } catch (e) {
//       if (kDebugMode) {
//         debugPrint(e);
//       }
//     }
//   }

//   // Future<void> _optRegister() async {
//   //   try {

//   //     // Verify OTP with HTTPS
//   //     final response = await PostRequest().loginVerifyOPT(widget.phoneNumber!, _code);

//   //     final responseJson = json.decode(response.body);
//   //     debugPrint("responseJson $responseJson");
//   //     if (response.statusCode == 200) {

//   //       if(!mounted) return;
//   //       Navigator.push(context, Transition(child: SetPassword(phoneNumber: widget.phoneNumber!,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          
//   //     } else if (response.statusCode == 401) {

//   //       if(!mounted) return;
//   //       customDialog(
//   //         context, 
//   //         "Error",
//   //         responseJson['message']
//   //       );

//   //       if(!mounted) return;
//   //       Navigator.of(context).pop();

//   //     } else if (response.statusCode >= 500 && response.statusCode < 600) {

//   //       if(!mounted) return;
//   //       customDialog(
//   //         context, 
//   //         "Error",
//   //         responseJson['message']
//   //       );

//   //       if(!mounted) return;
//   //       Navigator.of(context).pop();

//   //     }

//   //   } catch (e) {
//   //     debugPrint(e);
//   //   }
//   // }

//   Future<void> _optRegister() async {
//     try {

//       // Verify OTP with HTTPs
      
//       Response response = Response(await rootBundle.loadString('assets/json/phone.json'), 200);

//       final responseJson = json.decode(response.body);

//       if (response.statusCode == 200) {

//         // if(!mounted) return;
//         if (responseJson['user'].containsKey("encrypted")){
          
//           if(!mounted) return;
//           Navigator.push(context, Transition(child: SetPassword(phoneNumber: widget.phoneNumber!, responseJson: responseJson), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
//         }
          
//       } else if (response.statusCode == 401) {

//         if(!mounted) return;
//         customDialog(
//           context, 
//           "Error",
//           responseJson['message']
//         );

//         if(!mounted) return;
//         Navigator.of(context).pop();

//       } else if (response.statusCode >= 500 && response.statusCode < 600) {

//         if(!mounted) return;
//         customDialog(
//           context, 
//           "Error",
//           responseJson['message']
//         );

//         if(!mounted) return;
//         Navigator.of(context).pop();

//       }

//     } catch (e) {
//       if (kDebugMode) {
//         debugPrint(e);
//       }
//     }
//   }

//   @override
//   void initState() {

//     Timer.periodic(const Duration(seconds: 5), (timer) {
//       if(!mounted) return;
//       setState(() {
//         _currentIndex++;

//         if (_currentIndex == 2) {
//           _currentIndex = 0;
//         }
//       });
//     });

//     super.initState();
//   }

//   @override 
//   void dispose() {
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [

//               SizedBox(
//                 height: 160,
//                 child: Stack(
//                   children: [

//                     Positioned(
//                       top: 0,
//                       left: 0,
//                       right: 0,
//                       bottom: 0,
//                       child: Image.asset("assets/illustration/otp-verification.png"),
//                     ),

//                   ]
//                 ),
//               ),

//               const SizedBox(height: 30,),
//               FadeInDown(
//                 duration: const Duration(milliseconds: 500),
//                 child: const MyText(text: "Verification", fontWeight: FontWeight.bold, fontSize: 22,)),
              
//               const SizedBox(height: 30,),
//               FadeInDown(
//                 delay: const Duration(milliseconds: 500),
//                 duration: const Duration(milliseconds: 500),
//                 child: MyText(text: "Please enter the 4 digit code sent to \n ${widget.phoneNumber}")
//               ),

//               const SizedBox(height: 30,),
//               // Verification Code Input
//               FadeInDown(
//                 delay: const Duration(milliseconds: 600),
//                 duration: const Duration(milliseconds: 500),
//                 child: VerificationCode(
//                   autofocus: true,
//                   itemSize: 40,
//                   length: 6,
//                   digitsOnly: true,
//                   textStyle: TextStyle(fontSize: 20, color: isDarkMode ? Colors.white : Colors.black),
//                   underlineColor: hexaCodeToColor(AppColors.orangeColor),
//                   keyboardType: TextInputType.number,
//                   underlineUnfocusedColor: isDarkMode ? Colors.white : Colors.black,
//                   onCompleted: (value) {
//                     setState(() {
//                       _code = value;
//                     });
//                     _optRegister();
//                   }, 
//                   onEditing: (bool value) {
//                     setState(() {
//                       _onEditing = value;
//                     });
//                   },
//                 ),
//               ),

//               const SizedBox(height: 20,),
//               FadeInDown(
//                 delay: const Duration(milliseconds: 700),
//                 duration: const Duration(milliseconds: 500),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     MyText(text: "Didn't recieve the OTP?", color2: Colors.grey.shade500,),
//                     TextButton(
//                       onPressed: () {
//                         if (_isResendAgain) return;
//                         resend();
//                       }, 
//                       child: MyText(text: _isResendAgain ? "Try again in $_start".toString() : "Resend", hexaColor: AppColors.orangeColor,)
//                     )
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Container()
//               ),

//               SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 height: 50,
//                 child: FadeInDown(
//                   delay: const Duration(milliseconds: 800),
//                   duration: const Duration(milliseconds: 500),
//                   child: MaterialButton(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     elevation: 0,
//                     onPressed: _code.length < 6 ? () => {} : () { verify(); },
//                     color: hexaCodeToColor(AppColors.orangeColor),
//                     minWidth: MediaQuery.of(context).size.width * 0.8,
//                     child: _isLoading ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         backgroundColor: Colors.white,
//                         strokeWidth: 3,
//                         color: Colors.black,
//                       ),
//                     ) : _isVerified ? const Icon(Icons.check_circle, color: Colors.white, size: 30,) : const Text("Verify", style: TextStyle(color: Colors.white),),
//                   ),
//                 ),
//               )

//           ])
//         ),
//       )
//     );
//   }
// }