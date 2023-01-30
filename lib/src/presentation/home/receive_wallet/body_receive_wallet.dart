import 'package:wallet_apps/index.dart';

class ReceiveWalletBody extends StatelessWidget {
  
  final Function? onChanged;

  ReceiveWalletBody({Key? key, 
    this.onChanged,
  }) : super(key: key);

  final double? logoSize = 8.vmax;

  @override
  Widget build(BuildContext context) {
     
    return Consumer<ReceiveWalletProvider>(
      builder: (context, provider, widget){
        
        return Scaffold(
          key: provider.globalKey,
          appBar: secondaryAppBar(
            context: context,
            title: Row(
              children: [

                const MyText(
                  text: "Receive",
                  fontWeight: FontWeight.bold,
                  fontSize: 2.5,
                ),

                Expanded(
                  // width: MediaQuery.of(context).size.width/2,
                  child: Container(),
                ),

                // SizedBox(
                //   width: 17.vmax,
                //   child: QrViewTitle(
                //     // assetInfo: provider.assetInfo,
                //     listContract: provider.lsContractSymbol,
                //     initialValue: provider.assetsIndex.toString(),
                //     onChanged: onChanged,
                //   ),
                // )
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              color: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
              height: MediaQuery.of(context).size.height,
              child: Consumer<ContractProvider>(
                builder: (context, conProvider, widget){

                  return Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 2.5.h,
                          left: paddingSize,
                          right: paddingSize,
                          top: paddingSize
                        ),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.vmax),
                          // boxShadow: [shadow(context)],
                          color: Colors.white
                        ),

                        child: Column(
                          children: [
                              
                            // Asset Logo and Symbol
                            RepaintBoundary(
                              key: provider.keyQrShare,
                              child: Container(
                                padding: EdgeInsets.all(paddingSize + 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1.vmax),
                                  // boxShadow: [shadow(context)],
                                  color: isDarkMode
                                    ? Colors.white
                                    : hexaCodeToColor(AppColors.whiteHexaColor),
                                ),
                                child: Column(
                                  children: [
                              
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50.vmax),
                                      child: conProvider.sortListContract[provider.assetsIndex].logo!.contains('http') 
                                      ? Image.network(
                                        conProvider.sortListContract[provider.assetsIndex].logo!,
                                        fit: BoxFit.contain,
                                        width: logoSize,
                                        height: logoSize,
                                      )
                                      : Image.asset(
                                        conProvider.sortListContract[provider.assetsIndex].logo!,
                                        fit: BoxFit.contain,
                                        width: logoSize,
                                        height: logoSize,
                                      )
                                    ),
                              
                                    MyText(
                                      top: paddingSize - 5,
                                      fontSize: 2.9,
                                      fontWeight: FontWeight.bold,
                                      hexaColor: AppColors.textColor,
                                      text: conProvider.sortListContract[provider.assetsIndex].symbol,
                                      bottom: 2.5.vmax,
                                    ),
                              
                                    // Qr View
                                    qrCodeGenerator(
                                      provider.accountM!.address ?? '',
                                      AppConfig.logoQrEmbedded,
                                      provider.keyQrShare,
                                    ),
                              
                                    MyText(
                                      top: 2.5.vmax,
                                      text: provider.accountM!.address ?? '',
                                      hexaColor: AppColors.darkBgd,
                                      fontSize: 2.4,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: paddingSize + 10),
                              child: Column(
                                children: [
          
                                  MyGradientButton(
                                    // edgeMargin: EdgeInsets.only(top: 15),
                                    textButton: "Copy",
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    action: () {
                                      Clipboard.setData(
                                        ClipboardData(text: provider.accountM!.address),
                                      );
                                      /* Copy Text */
                                      provider.method.snackBar(context, 'Copied', provider.globalKey!);
                                    },
                                  ),
          
                                  MyFlatButton(
                                    isTransparent: true,
                                    buttonColor: AppColors.whiteHexaColor,
                                    textColor: AppColors.blue,
                                    textButton: "Share",
                                    action: () {
                                      provider.method.qrShare(provider.keyQrShare, provider.accountM!.address!);
                                    },
                                  )

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),      
                
                      Column(
                        children: [

                          MyText(
                            text: "Note: This address only receives ${conProvider.sortListContract[provider.assetsIndex].symbol} ${ApiProvider().isMainnet ? conProvider.sortListContract[provider.assetsIndex].org : conProvider.sortListContract[provider.assetsIndex].orgTest}",
                            fontWeight: FontWeight.w600,
                            hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
                          ),
                          
                          MyText(
                            text: "Do not transfer from other public chain.",
                            fontWeight: FontWeight.w600,
                            hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
                          )
                        ],
                      ),

                      // Expanded(
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Image.asset(isDarkMode ? "assets/logo/bitriel-logo-light.png" : "assets/logo/bitriel-logo-dark.png", width: 11.vmax,),
                      //   ),
                      // )

                    ],
                  );
                },
              ),
            ),
          ),
        );
      }
    );
  }
}
