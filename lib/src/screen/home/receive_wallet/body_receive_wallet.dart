import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/screen/home/receive_wallet/appbar_wallet.dart';

class ReceiveWalletBody extends StatelessWidget {
  
  final GlobalKey<ScaffoldState>? globalKey;
  final GlobalKey? keyQrShare;
  final HomeModel? homeM;
  final GetWalletMethod? method;
  final Function? onChanged;
  final String? name;
  final String? wallet;
  final int? initialValue;
  final String? assetInfo;

  const ReceiveWalletBody({
    this.keyQrShare,
    this.globalKey,
    this.homeM,
    this.method,
    this.onChanged,
    this.name,
    this.wallet,
    this.initialValue,
    this.assetInfo,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      children: <Widget>[
        
        MyAppBar(
          title: "Receive",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        
        Expanded(
          child: (wallet == 'wallet address')
          ? Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/no_data.svg', height: 200),
                  MyText(text: "There are no wallet found")
                ],
              ),
            )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              RepaintBoundary(
                key: keyQrShare,
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
                        assetInfo: assetInfo,
                        initialValue: initialValue.toString(),
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
                        wallet ?? '',
                        AppConfig.logoQrEmbedded,
                        keyQrShare!,
                      ),

                      // Padding(
                      //   padding: EdgeInsets.only(top: 16, bottom: 16),
                      //   child: TextShimmer(
                      //     txt: name,
                      //   )
                      // ),

                      // Padding(
                      //   padding: EdgeInsets.only(top: 16, bottom: 16),
                      //   child: TextShimmer(
                      //     width: 300,
                      //     txt: wallet,
                      //     highlightColor: Colors.white,
                      //   )
                      // ),
                      MyText(
                        text: name ?? 'User name',
                        bottom: 16,
                        top: 16,
                        fontSize: 16,
                        color: isDarkTheme
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      MyText(
                        width: 100.w,
                        text: wallet ?? '',
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
                        ClipboardData(text: wallet),
                      );
                      /* Copy Text */
                      method!.snackBar('Copied', globalKey!);
                    },
                  ),
                  MyFlatButton(
                    isTransparent: true,
                    buttonColor: AppColors.whiteHexaColor,
                    edgeMargin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                    textButton: "Share",
                    action: () {
                      method!.qrShare(keyQrShare!, wallet!);
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
}
