import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/data/provider/receive_wallet_p.dart';

class ReceiveWalletBody extends StatelessWidget {
  
  final Function? onChanged;

  ReceiveWalletBody({Key? key, 
    this.onChanged,
  }) : super(key: key);

  final double? logoSize = 12.w;

  @override
  Widget build(BuildContext context) {
     
    return Consumer<ReceiveWalletProvider>(
      builder: (context, provider, widget){
        return Scaffold(
          key: provider.globalKey,
          appBar: AppBar(
            backgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
            iconTheme: IconThemeData(
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
            ),
            elevation: 0,
            bottomOpacity: 0,
            title: Row(
              children: [
                const MyText(
                  text: "Receive",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  hexaColor: AppColors.blackColor,
                ),

                Expanded(
                  // width: MediaQuery.of(context).size.width/2,
                  child: Container(),
                ),

                // SizedBox(
                //   width: 130,
                //   child: QrViewTitle(
                //     // assetInfo: provider.assetInfo,
                //     listContract: provider.lsContractSymbol,
                //     initialValue: provider.assetsIndex.toString(),
                //     onChanged: onChanged,
                //   ),
                // )
              ],
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Iconsax.arrow_left_2,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 30,
              ),
            ),
          ),
          body: Container(
            color: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
            child: Column(
              children: <Widget>[  
                Expanded(
                  child: Consumer<ContractProvider>(
                    builder: (context, conProvider, widget){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 2.5.h,
                              left: paddingSize,
                              right: paddingSize,
                              top: 16.0
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              // boxShadow: [shadow(context)],
                              color: Colors.white
                            ),
                            child: Column(
                              children: [
                                  
                                // Asset Logo and Symbol
                                RepaintBoundary(
                                  key: provider.keyQrShare,
                                  child: Container(
                                    padding: const EdgeInsets.all(paddingSize + 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      // boxShadow: [shadow(context)],
                                      color: isDarkMode
                                        ? Colors.white
                                        : hexaCodeToColor(AppColors.whiteHexaColor),
                                    ),
                                    child: Column(
                                      children: [
                                  
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: conProvider.sortListContract[provider.assetsIndex].logo!.contains('http') 
                                          ? Image.network(
                                            conProvider.sortListContract[provider.assetsIndex].logo!,
                                            fit: BoxFit.contain,
                                            width: logoSize,
                                            height: logoSize,
                                          )
                                          : Image.file(
                                            File(conProvider.sortListContract[provider.assetsIndex].logo!),
                                            fit: BoxFit.contain,
                                            width: logoSize,
                                            height: logoSize,
                                          )
                                        ),
                                  
                                        MyText(
                                          top: paddingSize - 5,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          hexaColor: AppColors.textColor,
                                          text: conProvider.sortListContract[provider.assetsIndex].symbol,
                                          bottom: 2.5.h,
                                        ),
                                  
                                        // Qr View
                                        qrCodeGenerator(
                                          context,
                                          provider.accountM!.address ?? '',
                                          AppConfig.logoQrEmbedded,
                                          provider.keyQrShare,
                                        ),
                                  
                                        MyText(
                                          top: 2.5.h,
                                          text: provider.accountM!.address ?? '',
                                          hexaColor: AppColors.darkBgd,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
        
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: paddingSize + 10),
                                  child: Column(
                                    children: [
                                      MyGradientButton(
                                        // edgeMargin: const EdgeInsets.only(top: 15),
                                        textButton: "Copy",
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        action: () {
                                          Clipboard.setData(
                                            ClipboardData(text: provider.accountM!.address!),
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
        
                          Consumer<AppProvider>(
                            builder: (context, pro, wg) {
                              return Expanded(
                                child: Image.file(File(isDarkMode ? "${pro.dirPath}/logo/bitriel-logo-light.png" : "${pro.dirPath}/logo/bitriel-logo-dark.png"), width: 100,),
                              );
                            }
                          )
                        ],
                      );
                    },
                  )
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
