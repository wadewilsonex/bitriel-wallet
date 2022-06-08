import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/components/shimmer_c.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/screen/home/receive_wallet/appbar_wallet.dart';

class ReceiveWalletBody extends StatelessWidget {
  
  final Function? onChanged;

  const ReceiveWalletBody({
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Consumer<ReceiveWalletProvider>(
      builder: (context, provider, widget){
        return Column(
          children: <Widget>[
            
            MyAppBar(
              title: "Receive",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  RepaintBoundary(
                    key: provider.keyQrShare,
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 2.5.h,
                        left: paddingSize,
                        right: paddingSize,
                        top: 16.0
                      ),
                      padding: const EdgeInsets.all(paddingSize),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        // boxShadow: [shadow(context)],
                        color: isDarkTheme
                          ? Colors.white.withOpacity(0.06)
                          : hexaCodeToColor(AppColors.whiteHexaColor),
                      ),
                      child: Column(
                        children: [
                          
                          QrViewTitle(
                            // assetInfo: provider.assetInfo,
                            initialValue: provider.initialValue.toString(),
                            onChanged: onChanged,
                          ),
      
                          MyText(
                            bottom: 2.5.h,
                            text: "Scan the qr code to perform transaction",
                            fontSize: 16,
                            color: isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                          ),
                          
                          // Qr View
                          qrCodeGenerator(
                            provider.accountM!.address ?? '',
                            AppConfig.logoQrEmbedded,
                            provider.keyQrShare,
                          ),
      
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 10),
                            child: TextShimmer(
                              txt: provider.accountM!.name,
                            )
                          ),
      
                          // Padding(
                          //   padding: EdgeInsets.only(top: 16, bottom: 16),
                          //   child: TextShimmer(
                          //     width: 300,
                          //     txt: wallet,
                          //     highlightColor: Colors.white,
                          //   )
                          // ),
                          // MyText(
                          //   text: name ?? 'User name',
                          //   bottom: 16,
                          //   top: 16,
                          //   fontSize: 16,
                          //   color: isDarkTheme
                          //     ? AppColors.whiteColorHexa
                          //     : AppColors.textColor,
                          //   fontWeight: FontWeight.bold,
                          // ),

                          MyText(
                            width: 100.w,
                            text: provider.accountM!.address ?? '',
                            color: AppColors.secondarytext,
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
      
                  Column(
                    children: [
                      MyGradientButton(
                        edgeMargin: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16),
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
                        edgeMargin:
                            const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                        textButton: "Share",
                        action: () {
                          provider.method.qrShare(provider.keyQrShare, provider.accountM!.address!);
                        },
                      )
                    ],
                  ),
                  
                ],
              )
            ),
          ],
        );
      }
    );
  }
}
