// import 'package:lottie/lottie.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/components/asset_item_c.dart';
// import 'package:wallet_apps/src/components/category_card_c.dart';
// import 'package:wallet_apps/src/screen/home/swap/swap_method/swap_method.dart';

// class Assets extends StatefulWidget {

//   final HomePageModel? homePageModel;

//   const Assets({Key? key, required this.homePageModel}) : super(key: key);

//   @override
//   State<Assets> createState() => _AssetsState();
// }

// class _AssetsState extends State<Assets> with TickerProviderStateMixin {

//   int changeVertical = 0;

//   final AssetPageModel model = AssetPageModel();

//   // void onTapCategories(int index, {bool? isTap}){
//   //   setState(() {
//   //     model.categoryIndex = index;
//   //     // if (isTap != null) widget.homePageModel.pageController.jumpToPage(index);
//   //     // else 
//   //     if (isTap != null) model.assetTabController!.animateTo(index);

//   //     if (index == 0) {
//   //       model.assetLength = Provider.of<ContractProvider>(context, listen: false).sortListContract.length;
//   //     } else if (index == 1) {
//   //       model.assetLength = model.nativeAssets!.length;
//   //     } else if (index == 2) {
//   //       model.assetLength = model.bep20Assets!.length;
//   //     } else if (index == 3) {
//   //       model.assetLength = model.erc20Assets!.length;
//   //     }// > 5 ? model.erc20Assets!.length : 5;
//   //   });
//   // }

//   // // Drag Horizontal Left And Right
//   // void onHorizontalChanged(DragEndDetails details){
//   //   // From Right To Left = Scroll To Home Page
//   //   if (details.primaryVelocity!.toDouble() < 0 && model.assetTabController!.index == 3) {
//   //     widget.homePageModel!.pageController!.jumpToPage(2);
//   //   }

//   //   // From Left To Right = Scroll To Discover Page
//   //   else if (details.primaryVelocity!.toDouble() > 0 && model.assetTabController!.index == 0) {
//   //     widget.homePageModel!.pageController!.jumpToPage(0);
//   //   }
    
//   //   // Scroll Forward InSide Asset Page
//   //   else if (details.primaryVelocity!.toDouble() < 0) {

//   //     onTapCategories(model.assetTabController!.index+1);
//   //     model.assetTabController!.animateTo(model.assetTabController!.index+1);
//   //     // homePageModel.pageController.jumpTo(2);
//   //   }
    
//   //   // Scroll Backward InSide Asset Page
//   //   else if (details.primaryVelocity!.toDouble() > 0) {
//   //     onTapCategories(model.assetTabController!.index-1);
//   //     model.assetTabController!.animateTo(model.assetTabController!.index-1);
//   //     // homePageModel.pageController.jumpTo(2);
//   //   }
//   // }

//   // // Drag Horizontal Left And Right
//   // void onVerticalUpdate(DragUpdateDetails details) async {
//   //   model.scrollController!.jumpTo(model.scrollController!.offset + (details.primaryDelta! * (-1)));
//   // }

//   @override
//   void initState() {
    
//     // model.assetTabController = TabController(initialIndex: 1, length: 4, vsync: this);
//     model.assetLength = Provider.of<ContractProvider>(context, listen: false).sortListContract.length;
//     model.indicator = GlobalKey<RefreshIndicatorState>();
//     model.scrollController = ScrollController();
//     /// If Do transaction We need to refetch All Asset's Data.
//     // if (widget.isTrx == true){
//     //   Provider.of<ContractsBalance>(context, listen: false).refetchContractBalance(context: context);
//     // }
    
//     model.assetFilter(context);

//     AppServices.noInternetConnection(context: context);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10,),
        
//             // SizedBox(
//             //   height: 30,
//             //   child: categoryToken()
//             // ),

//             for(int index = 0; index < Provider.of<ContractProvider>(context).sortListContract.length; index++)
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   Transition(
//                     child: AssetInfo(
//                       index: index,
//                       scModel: Provider.of<ContractProvider>(context).sortListContract[index]
//                     ),
//                     transitionEffect: TransitionEffect.RIGHT_TO_LEFT
//                   ),
//                 );
//               },
//               child: AssetsItemComponent(
//                 scModel: Provider.of<ContractProvider>(context).sortListContract[index]
//               )
//             ),

//             // GestureDetector(
              
//             //   // onHorizontalDragEnd: (details) {
//             //   //   onHorizontalChanged(details);
//             //   // },
//             //   // onVerticalDragUpdate: (detail){
                              
//             //   //   onVerticalUpdate(detail);
//             //   // },
                              
//             //   child: Builder(builder: (context){
//             //     return Column(
//             //         children: [
                      
//             //           for(int index = 0; index < Provider.of<ContractProvider>(context).sortListContract.length; index++)
//             //           GestureDetector(
//             //             onTap: () {
//             //               Navigator.push(
//             //                 context,
//             //                 Transition(
//             //                   child: AssetInfo(
//             //                     index: index,
//             //                     scModel: Provider.of<ContractProvider>(context).sortListContract[index]
//             //                   ),
//             //                   transitionEffect: TransitionEffect.RIGHT_TO_LEFT
//             //                 ),
//             //               );
//             //             },
//             //             child: AssetsItemComponent(
//             //               scModel: Provider.of<ContractProvider>(context).sortListContract[index]
//             //             )
//             //           )
//             //         ],
//             //       );
      
//             //     // if (model.categoryIndex == 0){
//             //     //   return Column(
//             //     //     children: [
                      
//             //     //       for(int index = 0; index < Provider.of<ContractProvider>(context).sortListContract.length; index++)
//             //     //       GestureDetector(
//             //     //         onTap: () {
//             //     //           Navigator.push(
//             //     //             context,
//             //     //             Transition(
//             //     //               child: AssetInfo(
//             //     //                 index: index,
//             //     //                 scModel: Provider.of<ContractProvider>(context).sortListContract[index]
//             //     //               ),
//             //     //               transitionEffect: TransitionEffect.RIGHT_TO_LEFT
//             //     //             ),
//             //     //           );
//             //     //         },
//             //     //         child: AssetsItemComponent(
//             //     //           scModel: Provider.of<ContractProvider>(context).sortListContract[index]
//             //     //         )
//             //     //       )
//             //     //     ],
//             //     //   );
//             //     //   // _selendraNetworkList(context, Provider.of<ContractProvider>(context).sortListContract);
//             //     // }
//             //     // else if (model.categoryIndex == 1) {
//             //     //   return _selendraNetworkList(context, model.nativeAssets! );
//             //     // }
//             //     // else if (model.categoryIndex == 2) {
//             //     //   return _selendraNetworkList(context, model.bep20Assets!, networkIndex: 2);
//             //     // }
//             //     // else if (model.categoryIndex == 3){
//             //     //   return _selendraNetworkList(context, model.erc20Assets!, networkIndex: 3);
//             //     // }
      
//             //     // return Container();
//             //   }),
//               // SizedBox(
                
//               //   height: 8.h * 5,
//               //   child: TabBarView(
//               //       controller: model.assetTabController,
//               //       physics: const NeverScrollableScrollPhysics(),
//               //       children: [
                              
//               //         _selendraNetworkList(context, Provider.of<ContractProvider>(context).sortListContract),
//               //         _selendraNetworkList(context, model.nativeAssets! ),
//               //         _selendraNetworkList(context, model.bep20Assets!, networkIndex: 2),
//               //         _selendraNetworkList(context, model.erc20Assets!, networkIndex: 3)
                              
//               //       ]
//               //   ),
//               // )
//             // ),
                                
//             // if ( (model.assetTabController!.index == 2 && model.bep20Assets!.isEmpty) || (model.assetTabController!.index == 3 && model.erc20Assets!.isEmpty ))
//             //   GestureDetector(
//             //     onHorizontalDragEnd: (details) {
//             //       onHorizontalChanged(details);
//             //     },
//             //     onVerticalDragUpdate: (details) {
                                
//             //       // Prevent Scroll When Empty Asset
//             //       if(model.assetLength > 5) onVerticalUpdate(details);
//             //     },
//             //     child: SizedBox(
//             //         height: 60.sp,
//             //         child: OverflowBox(
//             //           minHeight: 60.h,
//             //           maxHeight: 60.h,
//             //           child: Lottie.asset("${AppConfig.animationPath}no-data.json", width: 60.w, height: 60.w),
//             //         )
//             //     ),
//             //   ),
                                
//             // // Add Asset For BEP-20
//             // if (model.assetTabController!.index == 2)
//             //   addMoreAsset(context, const EdgeInsets.only(bottom: 20.0, top: 20.0 ))
                                
//             // // Add Asset For ERC-20
//             // else if (model.assetTabController!.index == 3)
//             //   addMoreAsset(context, model.erc20Assets!.isEmpty ? EdgeInsets.zero : const EdgeInsets.only(bottom: 20.0, top: 20.0 )),
                                
//             // For Gesture
//             // if ( (model.assetTabController!.index == 2 || model.assetTabController!.index == 3 || model.assetTabController!.index == 1) && model.assetLength < 5)
//             //   Container(
//             //     color: Colors.blue,
//             //     child: GestureDetector(
//             //       onHorizontalDragEnd: (details) {
//             //         onHorizontalChanged(details);
//             //       },
//             //       onVerticalDragUpdate: (details) {
                                  
//             //         // Prevent Scroll When Empty Asset
//             //         if(model.assetLength > 5) onVerticalUpdate(details);
//             //       },
//             //       child: Container(
//             //         width: MediaQuery.of(context).size.width,
//             //         height: 8.h * 5,
//             //         color: Colors.transparent,
//             //       ),
//             //     ),
//             //   )
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget categoryToken(){

//   //   return ListView.builder(
//   //     shrinkWrap: true,
//   //     scrollDirection: Axis.horizontal,
//   //     itemCount: model.categories!.length,
//   //     physics: const BouncingScrollPhysics(),
//   //     itemBuilder: (BuildContext context, int index) {
//   //       return Row(
//   //         children: [
            
//   //           CategoryCard(
//   //             index: index,
//   //             title: model.categories![index],
//   //             selectedIndex: model.categoryIndex!,
//   //             onTap: onTapCategories,
//   //           ),

//   //         ],
//   //       );
//   //     }
//   //   );
//   // }

//   Widget addMoreAsset(BuildContext context, EdgeInsetsGeometry padding){
//     return GestureDetector(
//       // onHorizontalDragEnd: (details) {
//       //   onHorizontalChanged(details);
//       // },
//       // onVerticalDragUpdate: (details) {
//       //   onVerticalUpdate(details);
//       // },
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         color: Colors.transparent,
//         padding: padding,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
            
//             MyText(
//               text: "Don't see your token?",
//               color2: Colors.grey.shade400,
//               bottom: 10.sp,
//             ),
        
//             GestureDetector(
//               onTap: (){
//                 Navigator.push(
//                   context, 
//                   MaterialPageRoute(builder: (context) => AddAsset(network: model.assetTabController!.index == 2 ? 0 : 1,))
//                 );
//               },
//               child: const MyText(
//                 text: "Import asset",
//                 hexaColor: AppColors.primaryColor,
//                 fontWeight: FontWeight.bold,
//                 // left: 5.sp
//               )
//             )
//           ],
//         ),
//       ),
//     );
//   }

// //   Widget _selendraNetworkList(BuildContext context, List<SmartContractModel> lsAsset, {int? networkIndex}){
// //     return ListView.builder(
// //       physics: const NeverScrollableScrollPhysics(),
// //       itemCount: lsAsset.length,
// //       shrinkWrap: true,
// //       itemBuilder: (context, index){
// //         print("symbol ${lsAsset[index].symbol}");
// //         return GestureDetector(
// //           onTap: () {
// //             Navigator.push(
// //               context,
// //               Transition(
// //                 child: AssetInfo(
// //                   index: index,
// //                   scModel: lsAsset[index]
// //                 ),
// //                 transitionEffect: TransitionEffect.RIGHT_TO_LEFT
// //               ),
// //             );
// //           },
// //           child: AssetsItemComponent(
// //             scModel: lsAsset[index]
// //           )
// //         );
// //       }
// //     );
// //   }

// //   Widget _operationRequest(BuildContext context) {
// //     return IntrinsicHeight(
// //       child: Container(
// //         padding: const EdgeInsets.all(8),
// //         decoration: BoxDecoration(
// //           color: hexaCodeToColor("#FEFEFE").withOpacity(0.9),
// //           borderRadius: const BorderRadius.all(Radius.circular(10)),
// //           border: Border.all(color: hexaCodeToColor(AppColors.primaryColor))
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //           children: [
// //             Expanded( 
// //               flex: 3,
// //               child: InkWell(
// //                 onTap: () {
// //                   Navigator.push(
// //                     context, 
// //                     Transition(child: const SubmitTrx("", true, []), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
// //                   );
// //                 },
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   crossAxisAlignment: CrossAxisAlignment.center,
              
// //                   children: [
                    
// //                     Container(
// //                       width: 40,
// //                       height: 40,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
// //                       ),
// //                       child: Transform.rotate(
// //                         angle: 141.371669412,
// //                         child: Icon(Iconsax.import, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary)),
// //                       ),
// //                     ),
            
// //                     const MyText(
// //                       text: "Send",
// //                       hexaColor: AppColors.primaryColor,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),

// //             VerticalDivider(
// //               color: hexaCodeToColor("#D9D9D9"),
// //               thickness: 1,
// //             ),

// //             Expanded(
// //               flex: 3,
// //               child: InkWell(
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     Transition(child: const ReceiveWallet(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
// //                   );
// //                 },
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   crossAxisAlignment: CrossAxisAlignment.center,
              
// //                   children: [
                    
// //                     Container(
// //                       width: 40,
// //                       height: 40,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
// //                       ),
// //                       child: Icon(Iconsax.import, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary))
// //                     ),
            
// //                     MyText(
// //                       text: "Receive",
// //                       hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),

// //             VerticalDivider(
// //               color: hexaCodeToColor("#D9D9D9"),
// //               thickness: 1,
// //             ),
            
// //             Expanded(
// //               flex: 3,
// //               child: InkWell(
// //                 onTap: () {
// //                   underContstuctionAnimationDailog(context: context);
// //                 },
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   crossAxisAlignment: CrossAxisAlignment.center,
              
// //                   children: [
                    
// //                     Container(
// //                       width: 40,
// //                       height: 40,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
// //                       ),
// //                       child: Icon(Iconsax.card, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary))
// //                     ),
            
// //                     MyText(
// //                       text: "Buy",
// //                       hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),

// //             VerticalDivider(
// //               color: hexaCodeToColor("#D9D9D9"),
// //               thickness: 1,
// //             ),
            
// //             Expanded(
// //               flex: 3,
// //               child: InkWell(
// //                 onTap: () async {
// //                   await showBarModalBottomSheet(
// //                       context: context,
// //                       backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
// //                       shape: const RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.vertical( 
// //                           top: Radius.circular(25.0),
// //                         ),
// //                       ),
// //                       builder: (context) => Column(
// //                         children: const [
// //                           SwapMethod(),
// //                         ],  
// //                       ),
// //                     );
// //                 },
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   crossAxisAlignment: CrossAxisAlignment.center,
              
// //                   children: [
                    
// //                     Container(
// //                       width: 40,
// //                       height: 40,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
// //                       ),
// //                       child: Icon(Iconsax.arrow_swap, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary))
// //                     ),
            
// //                     const MyText(
// //                       text: "Swap",
// //                       hexaColor: AppColors.primaryColor,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
            
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// }