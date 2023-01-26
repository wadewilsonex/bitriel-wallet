import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/trx_history_c.dart';
import 'package:wallet_apps/src/models/asset_info.dart';
import 'package:wallet_apps/src/screen/home/asset_info/asset_detail.dart';
import 'package:wallet_apps/src/screen/home/swap/bitriel_swap/swap.dart';
import 'package:wallet_apps/src/screen/home/transaction/transaction_detail.dart/trx_detail.dart';

class AssetInfoBody extends StatelessWidget {

  final AssetInfoModel? assetInfoModel;
  final Function? onTabChange;
  final Function? onPageChange;
  
  AssetInfoBody({
    Key? key, 
    this.assetInfoModel, 
    required this.onTabChange,
    required this.onPageChange
  }) : super(key: key);

  final double logoSize = 15.w;

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      key: assetInfoModel!.globalKey,
      body: BodyScaffold(
        isSafeArea: true,
        bottom: 0,
        height: MediaQuery.of(context).size.height,
        child: NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBox) {
            return [

              SliverAppBar(
                elevation: 0,
                // pinned: true,
                floating: true,
                snap: true,
                forceElevated: innerBox,
                automaticallyImplyLeading: false,
                leading: Container(),
                backgroundColor: isDarkMode
                  ? hexaCodeToColor(AppColors.darkBgd)
                  : Colors.white,
                flexibleSpace: Column(children: [

                  // AppBar
                  Expanded(
                    child: Container(
                      color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Iconsax.arrow_left_2,
                                    color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor,),
                                    size: 22.5.sp
                                  )
                                )
                              ),

                              MyText(
                                left: 2.w,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                hexaColor: AppColors.textColor,
                                text: "${assetInfoModel!.smartContractModel!.symbol!} ${ApiProvider().isMainnet ? assetInfoModel!.smartContractModel!.org!.isNotEmpty ? "(${assetInfoModel!.smartContractModel!.org})" : "" : "(${assetInfoModel!.smartContractModel!.orgTest})"}"
                                // assetInfoModel!.smartContractModel!.id! == null
                                //     ? assetInfoModel!.smartContractModel!.symbol!
                                //     : assetInfoModel!.smartContractModel!.id!.toUpperCase(),
                              ),

                              Expanded(child: Container()),

                              // Right Text
                              InkWell(
                                onTap: () async{
                                  await showBarModalBottomSheet(
                                    context: context,
                                    backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical( 
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    builder: (context) => Column(
                                      children: [
                                        AssetDetail(assetInfoModel!.smartContractModel!),
                                      ],  
                                    ),
                                  );
                                },
                                child: Icon(Iconsax.chart, color: hexaCodeToColor(AppColors.primaryColor),),
                              ),
                            ],
                          )
                        ),
                    )
                  ),
                ]),
              ),

              // Body
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Container(
                      color: isDarkMode
                        ? hexaCodeToColor(AppColors.darkBgd)
                        : hexaCodeToColor(AppColors.lightColorBg),
                      child: Column(
                        children: [

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),

                          // Logo
                          GestureDetector(
                            // onTap: assetInfoModel!.smartContractModel!.org != "BEP-20" && assetInfoModel!.smartContractModel!.org != "ERC-20" ? null : () async {
                            //
                            //   final image = ImagePicker();
                            //   await image.pickImage(source: ImageSource.gallery).then((value) async {
                            //     if (kDebugMode) {
                            //       print(value!.path);
                            //     }
                            //     Provider.of<ContractProvider>(context, listen: false).listContract.where((element) {
                            //       if (element.contract == assetInfoModel!.smartContractModel!.contract){
                            //         // element.logo = value.path;
                            //         // If found
                            //         return true;
                            //       }
                            //       // Not found
                            //       return false;
                            //     });
                            //   });
                            // },
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: assetInfoModel!.smartContractModel!.logo!.contains('http') 
                                  ? Image.network(
                                    assetInfoModel!.smartContractModel!.logo!,
                                    fit: BoxFit.contain,
                                    width: logoSize,
                                    height: logoSize,
                                  )
                                  : Image.asset(
                                    assetInfoModel!.smartContractModel!.logo!,
                                    fit: BoxFit.contain,
                                    width: logoSize,
                                    height: logoSize,
                                  )
                                ),

                                // assetInfoModel!.smartContractModel!.org == "BEP-20" || assetInfoModel!.smartContractModel!.org == "ERC-20" ? Positioned(
                                //   right: 0,
                                //   child: Icon(
                                //     Icons.edit,
                                //     size: 18.sp,
                                //     color: hexaCodeToColor(
                                //       // isDarkMode
                                //       // ? AppColors.greyCode
                                //       // :
                                //       AppColors.whiteColorHexa
                                //     ),
                                //   ),
                                // ) : Container()
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          MyText(
                            text: '${assetInfoModel!.smartContractModel!.balance}${' ${assetInfoModel!.smartContractModel!.symbol}'}',
                            //AppColors.secondarytext,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            hexaColor: isDarkMode
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                          ),
                          
                          MyText(
                            top: 8.0,
                            text: "≈ \$${assetInfoModel!.smartContractModel!.money!.toStringAsFixed(2)}",
                            hexaColor: isDarkMode
                              ? AppColors.greyCode
                              : AppColors.textColor,
                            //fontWeight: FontWeight.bold,
                          ),

                          Padding(
                            padding: const EdgeInsets.all(paddingSize),
                            child: _operationRequest(context, assetInfoModel!.smartContractModel!),
                          ),
                            
                        ],
                      ),
                    ),

                    // // TabBar
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           onTabChange!(0);
                    //         },
                    //         child: Container(
                    //           alignment: Alignment.center,
                    //           height: 50,
                    //           decoration: BoxDecoration(
                    //             color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
                    //             border: Border(
                    //               bottom: BorderSide(
                    //                 color: assetInfoModel!.tabIndex == 0
                    //                   ? hexaCodeToColor(isDarkMode ? "#D4D6E3" : AppColors.primaryColor)
                    //                   : Colors.transparent,
                    //                 width: 2,
                    //               ),
                    //             ),
                    //           ),
                    //           child: MyText(
                    //             fontWeight: FontWeight.bold,
                    //             text: "Activity",
                    //             hexaColor: assetInfoModel!.tabIndex == 0
                    //               ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor
                    //                 : isDarkMode
                    //                     ? AppColors.iconColor
                    //                     : AppColors.greyCode,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                        
                    //     Expanded(
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           onTabChange!(1);
                    //         },
                    //         child: Container(
                    //           alignment: Alignment.center,
                    //           height: 50,
                    //           decoration: BoxDecoration(
                    //             color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
                    //             border: Border(
                    //               bottom: BorderSide(
                    //                 color: assetInfoModel!.tabIndex == 1
                    //                   ? hexaCodeToColor(isDarkMode ? "#D4D6E3" : AppColors.primaryColor)
                    //                   : Colors.transparent,
                    //                 width: 2,
                    //               ),
                    //             ),
                    //           ),
                    //           child: MyText(
                    //             fontWeight: FontWeight.w600,
                    //             text: "Details",
                    //             hexaColor: assetInfoModel!.tabIndex == 1
                    //               ? isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor
                    //                 : isDarkMode
                    //                     ? AppColors.iconColor
                    //                     : AppColors.greyCode,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ];
          },

          body: PageView(
            controller: assetInfoModel!.controller,
            onPageChanged: (index) {
              onPageChange!(index);
            },
            children: <Widget>[
              Consumer<ContractProvider>(
                builder: (context, value, child) {
                  return assetInfoModel!.lsTxInfo == null
                  ? 
                  Container(
                    color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
                    child: Center(
                      child: SvgPicture.asset(
                        '${AppConfig.iconsPath}no_data.svg',
                        width: 15.w,
                        height: 15.h,
                      )
                    ),
                  )
                  : TrxHistoryList(
                    icon: const Icon(Iconsax.export_3, color: Colors.red),
                    action: (){
                      Navigator.push(
                        context, 
                        Transition(child: TransactionDetail(assetInfoModel: assetInfoModel), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                      );
                    },
                  );
                }
              ),

              // Container(
              //   color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
              //   child: AssetDetail(assetInfoModel!.smartContractModel!),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _operationRequest(BuildContext context, SmartContractModel scModel) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: hexaCodeToColor("#FEFEFE").withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: hexaCodeToColor(AppColors.primaryColor))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded( 
              flex: 3,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context, 
                    Transition(child: SubmitTrx("", true, const [], scModel: scModel,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
              
                  children: [
                    
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Transform.rotate(
                        angle: 141.371669412,
                        child: Icon(Iconsax.import, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary)),
                      ),
                    ),
            
                    const MyText(
                      text: "Send",
                      hexaColor: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

            VerticalDivider(
              color: hexaCodeToColor("#D9D9D9"),
              thickness: 1,
            ),
            
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context, 
                    Transition(child: ReceiveWallet(assetIndex: assetInfoModel!.index, scModel: assetInfoModel!.smartContractModel,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
              
                  children: [
                    
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Icon(Iconsax.import, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary))
                    ),
            
                    MyText(
                      text: "Receive",
                      hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

            VerticalDivider(
              color: hexaCodeToColor("#D9D9D9"),
              thickness: 1,
            ),
            
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
              
                  children: [
                    
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Icon(Iconsax.card, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary))
                    ),
            
                    MyText(
                      text: "Buy",
                      hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

            VerticalDivider(
              color: hexaCodeToColor("#D9D9D9"),
              thickness: 1,
            ),
            
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    Transition(child: const SwapPage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
              
                  children: [
                    
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexaCodeToColor(AppColors.primaryColor).withOpacity(0.05)
                      ),
                      child: Icon(Iconsax.arrow_swap, color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.secondary))
                    ),
            
                    const MyText(
                      text: "Swap",
                      hexaColor: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

}