// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/components/login_component/components/bottom_text.dart';
// import 'package:wallet_apps/src/components/login_component/components/top_text.dart';
// import 'package:wallet_apps/src/models/email_m.dart';

// class EmailBody extends StatelessWidget {

//   final EmailModel model;
//   final List<Widget> loginContent;
//   final List<Widget> createAccountContent;
//   const EmailBody({
//     Key? key, 
//     required this.model,
//     required this.loginContent, 
//     required this.createAccountContent
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     return Stack(
//       children: [
//         // const Positioned(
//         //   top: 136,
//         //   left: 24,
//         //   child: TopText(),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 100),
//           child: Stack(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: createAccountContent,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: loginContent,
//               ),
//             ],
//           ),
//         ),
//         const Align(
//           alignment: Alignment.bottomCenter,
//           child: Padding(
//             padding: EdgeInsets.only(bottom: 50),
//             child: BottomText(),
//           ),
//         ),
//       ],
//     );
//   }
// }