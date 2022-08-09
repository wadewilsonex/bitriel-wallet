import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/components/shimmer_c.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/screen/home/receive_wallet/appbar_wallet.dart';

class ReceiveWalletBody extends StatelessWidget {
  
  final Function? onChanged;

  ReceiveWalletBody({
    this.onChanged,
  });

  final double? logoSize = 12.w;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Consumer<ReceiveWalletProvider>(
      builder: (context, provider, widget){
        return Scaffold(
          key: provider.globalKey,
          appBar: AppBar(
            elevation: 0,
            bottomOpacity: 0,
            leadingWidth: 7.w,
            title: Row(
              children: [

                MyText(
                  text: "Receive wallet",
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),

                Expanded(
                  // width: MediaQuery.of(context).size.width/2,
                  child: Consumer<ReceiveWalletProvider>(
                    builder: (context, value, widget){
                      return QrViewTitle(
                        // assetInfo: provider.assetInfo,
                        listContract: value.lsContractSymbol,
                        initialValue: provider.assetsIndex.toString(),
                        onChanged: onChanged,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: <Widget>[
              
              // SafeArea(
              //   child: Stack(
              //     children: [
              //       MyAppBar(
              //         title: "Receive",
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //       ),
              
              //       Consumer<ReceiveWalletProvider>(
              //         builder: (context, value, widget){
              //           return QrViewTitle(
              //             // assetInfo: provider.assetInfo,
              //             listContract: value.lsContractSymbol,
              //             initialValue: provider.assetsIndex.toString(),
              //             onChanged: onChanged,
              //           );
              //         },
              //       )
              //       // : Container()
              //     ],
              //   ),
              // ),
              
              Expanded(
                child: 
                // (provider.accountM!.address == null)
                // ? Expanded(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         SvgPicture.asset('assets/icons/no_data.svg', height: 200),
                //         MyText(text: "There are no wallet found")
                //       ],
                //     ),
                //   )
                // : 
                Consumer<ContractProvider>(
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
                            color: isDarkTheme
                              ? Colors.white
                              : hexaCodeToColor(AppColors.whiteHexaColor),
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
                                    color: isDarkTheme
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
                                        : Image.asset(
                                          conProvider.sortListContract[provider.assetsIndex].logo!,
                                          fit: BoxFit.contain,
                                          width: logoSize,
                                          height: logoSize,
                                        )
                                      ),
                                
                                      MyText(
                                        top: paddingSize - 5,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        text: conProvider.sortListContract[provider.assetsIndex].symbol,
                                        bottom: 2.5.h,
                                      ),
                                
                                      // Qr View
                                      qrCodeGenerator(
                                        provider.accountM!.address ?? '',
                                        AppConfig.logoQrEmbedded,
                                        provider.keyQrShare,
                                      ),
                                
                                      MyText(
                                        top: 2.5.h,
                                        text: provider.accountM!.address ?? '',
                                        color: AppColors.darkBgd,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
        
                              // if (assetIndex == null) Consumer<ReceiveWalletProvider>(
                              //   builder: (context, value, widget){
                              //     return QrViewTitle(
                              //       // assetInfo: provider.assetInfo,
                              //       listContract: value.lsContractSymbol,
                              //       initialValue: provider.initialValue.toString(),
                              //       onChanged: onChanged,
                              //     );
                              //   },
                              // ) else SizedBox(height: 2.h,),
            
                              // MyText(
                              //   bottom: 2.5.h,
                              //   text: "Scan the QR code to pay me",
                              //   fontSize: 16,
                              //   color: AppColors.darkBgd
                              // ),
            
                              // Padding(
                              //   padding: EdgeInsets.only(top: 16, bottom: 16),
                              //   child: TextShimmer(
                              //     width: 300,
                              //     txt: wallet,
                              //     highlightColor: Colors.white,
                              //   )
                              // ),
        
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
                                          ClipboardData(text: provider.accountM!.address),
                                        );
                                        /* Copy Text */
                                        provider.method.snackBar('Copied', provider.globalKey!);
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
                              color: AppColors.whiteColorHexa,
                            ),
                            MyText(
                              text: "Do not transfer from other public chain.",
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColorHexa,
                            )
                          ],
                        ),
        
                        Expanded(
                          child: Image.asset("assets/logo/bitriel-text-logo.png", width: 100,),
                        )
                      ],
                    );
                  },
                )
              ),
            ],
          ),
        );
      }
    );
  }
}
