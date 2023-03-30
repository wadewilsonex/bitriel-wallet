// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/models/account.m.dart';
// import 'package:wallet_apps/src/screen/main/seeds/create_seeds/create_seeds.dart';

// class BodyMultipleWallets extends StatelessWidget {
//   const BodyMultipleWallets({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Iconsax.arrow_left_2,
//             color: isDarkMode ? Colors.white : Colors.black,
//             size: 30
//           ),
//           onPressed: (){
//             Navigator.pop(context);
//           },
//         ),
//         elevation: 0,
//         backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkCard : AppColors.whiteHexaColor).withOpacity(0),
//         title: MyText(text: 'Wallets', fontSize: 20, hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor, fontWeight: FontWeight.bold,),
//       ),
//       body: Consumer<ApiProvider>(
//         builder: (context,provider, wg) {

//           return ListView.builder(
//             itemCount: provider.getKeyring.allAccounts.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 3),
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         Transition(
//                           child: Account(walletName: 'Wallet $index'),
//                           transitionEffect: TransitionEffect.RIGHT_TO_LEFT
//                         )
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: ListTile(
//                         leading: const CircleAvatar(
//                           backgroundColor: Color(0xff764abc),
//                           child: MyText(text: "W", color2: Colors.white,),
//                         ),
//                         title: MyText(text: 'Wallet $index', fontSize: 18, fontWeight: FontWeight.bold, textAlign: TextAlign.start,),
//                         trailing: Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primaryColor), size: 30,),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );

//         }
//       ),
//       bottomNavigationBar: SizedBox(
//         height: 70,
//         child: Row(
//           children: [

//             Expanded(
//               child: MyGradientButton(
//                 edgeMargin: const EdgeInsets.all(paddingSize),
//                 textButton: "Create Wallet",
//                 fontWeight: FontWeight.w400,
//                 begin: Alignment.bottomLeft,
//                 end: Alignment.topRight,
//                 action: () async {

//                   await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const Passcode(label: PassCodeLabel.fromAccount,)
//                       // const ImportAcc(
//                       //   isBackBtn: true,
//                       // )
//                     )
//                   ).then((value) async {
//                     if (value != null){
                      
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CreateSeeds(newAcc: NewAccount(), passCode: value,)
//                           // const ImportAcc(
//                           //   isBackBtn: true,
//                           // )
//                         )
//                       ).then((value) {
//                         if (value != null && value == true){
                          
//                           // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
//                           Provider.of<ApiProvider>(context, listen: false).notifyListeners();
//                         }
//                       });
//                     }
//                   });
//                 },
//               ),
//             ),
      
//             Expanded(
//               child: MyGradientButton(
//                 edgeMargin: const EdgeInsets.all(paddingSize),
//                 textButton: "Import Wallet",
//                 fontWeight: FontWeight.w400,
//                 begin: Alignment.bottomLeft,
//                 end: Alignment.topRight,
//                 action: () async {

//                   await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const Passcode(label: PassCodeLabel.fromAccount,)
//                       // const ImportAcc(
//                       //   isBackBtn: true,
//                       // )
//                     )
//                   ).then((value) async {
//                     if (value != null){

//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ImportAcc(isBackBtn: true, isAddNew: true, passCode: value,)
//                           // const ImportAcc(
//                           //   isBackBtn: true,
//                           // )
//                         )
//                       ).then((value) {
//                         if (value != null && value == true){
                          
//                           // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
//                           Provider.of<ApiProvider>(context, listen: false).notifyListeners();
//                         }
//                       });
//                     }
//                   });

//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
