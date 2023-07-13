import 'package:bitriel_wallet/index.dart';

Widget tabBarView(BuildContext context, Function dismiss) {

  return TabBarView(
    children: [
      
      SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              const SizedBox(height: 10),
              // Consumer<ContractProvider>(
              //   builder: (context, pro, wg) {
              //     return _
                  selendraNetworkList(context, [], dismiss),
              //   }
              // ),

              // _addMoreAsset(context),
            ],
          )
        ),
      ),
        
      // ListView(
      //   children: [
      //     for (int i = 0; i < 10; i++)
      //     Container(
      //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //         child: _nftAndTicket(context)
      //     ),
      //   ],
      // ),
    ],
  );
}

Widget selendraNetworkList(BuildContext context, List<SmartContractModel> lsAsset, Function dismiss){
  return ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: lsAsset.length,
    shrinkWrap: true,
    itemBuilder: (context, index){
      return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   Transition(
              //     child: AssetInfo(
              //       index: index,
              //       scModel: lsAsset[index]
              //     ),
              //     transitionEffect: TransitionEffect.RIGHT_TO_LEFT
              //   ),
              // );
            },
            child: AssetsItemComponent(
              scModel: lsAsset[index]
            )
          )
      // lsAsset[index].isAdded == true
      //   ? 
        // Dismissible(
        //   key: Key(index.toString()),
        //   onDismissed: (DismissDirection dismissDirection) async {

        //     await dismiss(lsAsset, index);
        //   },

        //   background: Container(
        //     color: Colors.red,
        //     child: Padding(
        //       padding: const EdgeInsets.all(15),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: const [
        //           Icon(Iconsax.trash, color: Colors.white),

        //           SizedBox(width: 5),

        //           Text('Remove', style: TextStyle(color: Colors.white)),
        //         ],
          
        //       ),
          
        //     ),
          
        //   ),
        //   direction: DismissDirection.endToStart,
        //   child: GestureDetector(
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         Transition(
        //           child: AssetInfo(
        //             index: index,
        //             scModel: lsAsset[index]
        //           ),
        //           transitionEffect: TransitionEffect.RIGHT_TO_LEFT
        //         ),
        //       );
        //     },
        //     child: AssetsItemComponent(
        //       scModel: lsAsset[index]
        //     )
        //   ),
        // ) 
        // : GestureDetector(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       Transition(
        //         child: AssetInfo(
        //           index: index,
        //           scModel: lsAsset[index]
        //         ),
        //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT
        //       ),
        //     );
        //   },
        //   child: AssetsItemComponent(
        //     scModel: lsAsset[index]
        //   )
        // )
        ;
    }
  );
}

Widget _addMoreAsset(BuildContext context){
  return GestureDetector(
    child: Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          MyTextConstant(
            text: "Don't see your token?",
            color2: Colors.grey.shade400,
          ),
      
          TextButton(
            onPressed: (){
              // Navigator.push(
              //   context, 
              //   MaterialPageRoute(builder: (context) => const AddAsset())
              // );
            },
            child: const MyTextConstant(
              text: "Import asset",
              // hexaColor: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              // left: 5.sp
            )
          )
        ],
      ),
    ),
  );
}

Widget userWallet(BuildContext context) {

//     ApiProvider api = Provider.of<ApiProvider>(context, listen: false);

    return Column(
      children: [

//         Consumer<VerifySeedsProvider>(
//           builder: (context, verifyingP, wg) {
//             verifyingP.unverifyAcc = null;
//             if (api.netWorkConnected == true){
//               List tmp = verifyingP.getPrivateList.where((e) {
//                 if (e['address'] == api.getKeyring.current.address) return true;
//                 return false;
//               }).toList();

//               if (tmp.isNotEmpty){
//                 verifyingP.unverifyAcc = tmp[0];
//               }
//             // }

//             if (verifyingP.unverifyAcc == null) return Container();

//             return verifyingP.unverifyAcc!["status"] == false ? Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 color: hexaCodeToColor(AppColors.warningColor).withOpacity(0.25),
//                 borderRadius: const BorderRadius.all(Radius.circular(16))
//               ),
//               child: Row(
//                 children: [
//                   Row(
//                     children: [
//                       const SizedBox(width: 10,),
//                       Icon(Iconsax.warning_2, color: hexaCodeToColor(AppColors.redColor),),
//                       const MyText(
//                         pLeft: 10,
//                         text: "Verify your Seed Phrase",
//                         fontWeight: FontWeight.w600,
//                         hexaColor: AppColors.redColor,
//                       ),
//                     ],
//                   ),

//                   const Spacer(),

//                   TextButton(
//                     onPressed: () async{

//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const Pincode(label: PinCodeLabel.fromAccount,)
//                         )
//                       ).then((passCodeValue) async {
//                         if (passCodeValue != null){
                          
//                           await api.getKeyring.store.getDecryptedSeed(api.getKeyring.current.pubKey, passCodeValue).then((getMnemonic) async{
//                             try {

//                               if(getMnemonic!.containsKey("seed")){


//                                 // Verifying Account To Get Mnemonic
//                                 verifyingP.mnemonic = getMnemonic["seed"];
//                                 verifyingP.isVerifying = true;

//                                 await Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => CreateSeeds(passCode: passCodeValue, newAcc: null,)
//                                     // const ImportAcc(
//                                     //   isBackBtn: true,
//                                     // )
//                                   )
//                                 ).then((value) {
//                                   if (value != null && value == true){
                                    
//                                     // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
//                                     Provider.of<ApiProvider>(context, listen: false).notifyListeners();
//                                   }
//                                 });
//                               }
//                               else{
//                                 throw Exception("wrong mnemonic");
                                
//                               }
                              
//                             } catch (e) {
//                               if (kDebugMode) {
//                                 debugPrint("error mnemonic $e");
//                               }
//                             }

//                           });

//                         }
//                       });
                      
//                     }, 
//                     child: const MyText(
//                       text: "Verify Now",
//                       fontWeight: FontWeight.w700,
//                       hexaColor: AppColors.primaryColor,
//                     ),
//                   )
//                 ],
//               )
//             ) : const SizedBox();
//             }

//             if (verifyingP.unverifyAcc == null) return Container();

//             if (verifyingP.unverifyAcc!["status"] == false) {
//               return Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: hexaCodeToColor(AppColors.warningColor).withOpacity(0.25),
//                   borderRadius: const BorderRadius.all(Radius.circular(16))
//                 ),
//                 child: Row(
//                   children: [

//                     Row(
//                       children: [
//                         const SizedBox(width: 10,),
//                         Icon(Iconsax.warning_2, color: hexaCodeToColor(AppColors.redColor),),
//                         const MyText(
//                           pLeft: 10,
//                           text: "Verify your Seed Phrase",
//                           fontWeight: FontWeight.w600,
//                           hexaColor: AppColors.redColor,
//                         ),
//                       ],
//                     ),

//                     const Spacer(),

//                     TextButton(
//                       onPressed: () async{

//                         await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const Pincode(label: PinCodeLabel.fromAccount,)
//                           )
//                         ).then((passCodeValue) async {
//                           if (passCodeValue != null){
                            
//                             await api.getKeyring.store.getDecryptedSeed(api.getKeyring.current.pubKey, passCodeValue).then((getMnemonic) async{
//                               try {

//                                 if(getMnemonic!.containsKey("seed")){


//                                   // Verifying Account To Get Mnemonic
//                                   verifyingP.mnemonic = getMnemonic["seed"];
//                                   verifyingP.isVerifying = true;

//                                   await Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CreateSeeds(passCode: passCodeValue, newAcc: null,)
//                                       // const ImportAcc(
//                                       //   isBackBtn: true,
//                                       // )
//                                     )
//                                   ).then((value) {
//                                     if (value != null && value == true){
                                      
//                                       // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
//                                       Provider.of<ApiProvider>(context, listen: false).notifyListeners();
//                                     }
//                                   });
//                                 }
//                                 else{
//                                   throw Exception("wrong mnemonic");
                                  
//                                 }
                                
//                               } catch (e) {
//                                 if (kDebugMode) {
//                                   debugPrint("error mnemonic $e");
//                                 }
//                               }

//                             });

//                           }
//                         });
                        
//                       }, 
//                       child: const MyText(
//                         text: "Verify Now",
//                         fontWeight: FontWeight.w700,
//                         hexaColor: AppColors.primaryColor,
//                       ),
//                     )
//                   ],
//                 )
//               );
//             }
//             else {
//               return const SizedBox();
//             }
//           }
//         ),

//         const SizedBox(height: 5,),

//         Consumer<AppProvider>(
//           builder: (context, pro, widget){

//             return Container(
//               decoration: BoxDecoration(
//                 color: hexaCodeToColor(AppColors.whiteColorHexa),
//                 borderRadius: const BorderRadius.all(Radius.circular(20)),
//                 image: DecorationImage(
//                   image: FileImage(File('${pro.dirPath}/default/bg-glass.jpg')),
//                   fit: BoxFit.cover
//                 ),
//               ),
//               width: MediaQuery.of(context).size.width,
              
//               child: Consumer<ApiProvider>(
//                 builder: (context, apiProvider, wg) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
//                       child: Column(
//                         children: [
                          
//                           SizedBox(height: 2.5.h),
                          
//                           Consumer<ContractProvider>(
//                             builder: (context, provider, widget){
//                               return api.netWorkConnected == true ? MyText(
//                                 text:"\$${ (provider.mainBalance).toStringAsFixed(2) }",
//                                 hexaColor: AppColors.whiteColorHexa,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 23,
//                               ) 
//                               : Lottie.asset(
//                                 "assets/animation/loading.json",
//                                 repeat: true,
//                                 reverse: true,
//                                 height: 25
//                               );
//                             }
//                           ),
                          
//                           // SizedBox(height: 0.5.h),
//                           Consumer<ContractProvider>(
//                             builder: (context, provider, widget){
//                               return api.netWorkConnected == true ? MyText(
//                                 text: provider.listContract.isNotEmpty ? "${AppUtils.toBTC(provider.mainBalance, double.parse(provider.listContract[apiProvider.btcIndex].marketPrice!)).toStringAsFixed(5)} BTC" : "0 BTC",
//                                 // provider.listContract.isEmpty ? '' : """≈ ${ (provider.mainBalance / double.parse(provider.listContract[apiProvider.btcIndex].marketPrice ?? '0')).toStringAsFixed(5) } BTC""",
//                                 hexaColor: AppColors.whiteColorHexa,
//                                 fontSize: 18,
//                               )
//                               : Lottie.asset(
//                                 "assets/animation/loading.json",
//                                 repeat: true,
//                                 reverse: true,
//                                 height: 25
//                               );
//                             }
//                           ),
                              
//                           SizedBox(height: 2.5.h),
//                           Padding(
//                             padding: EdgeInsets.only(left: 20, right: 20, bottom: 2.5.h),
//                             child: _operationRequest(context),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//               ),
//             );
//           } 
//         ),
      ],
    );
}