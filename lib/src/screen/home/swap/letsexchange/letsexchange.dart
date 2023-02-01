import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/walletconnect_c.dart';

class LetsExchange extends StatefulWidget {

  const LetsExchange({Key? key,}) : super(key: key);

  @override
  LetsExchangeState createState() => LetsExchangeState();
}

class LetsExchangeState extends State<LetsExchange> {

  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  double _progress = 0;

  void walletConnect() async{

    WalletConnectComponent wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);
    
    wConnectC.setBuildContext = context;

  }

  WalletConnectComponent? _wConnectC;

  @override
  void initState() {
    super.initState();
    _wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);

    _wConnectC!.setBuildContext = context;
    
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(AppColors.whiteHexaColor),
        title: MyText(
          text: "Let's Exchange",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: Stack(
        // index: _stackIndex,
        children: [
          InAppWebView(
            key: webViewKey,
            initialData: InAppWebViewInitialData(
              data: """
                <!DOCTYPE html>
                <html lang="en">
                    <head>
                      <meta charset="UTF-8">
                      <meta name="viewport" content="width=device-width, initial-scale=1.0">
                      
                    </head>

                    <body>

                      <link rel="stylesheet" type="text/css" href="https://letsexchange.io/widget_lets.css"><div class="lets-widget" id="lets_widget_kn0jXoqXjWt8TYid"  style="max-width: 480px; height: 480px;">  <iframe src="https://letsexchange.io/v2/widget?affiliate_id=kn0jXoqXjWt8TYid&is_iframe=true" width="100%" height="100%" frameBorder="0" allow="clipboard-read; clipboard-write"></iframe></div><script src="https://letsexchange.io/init_widget.js"></script>

                    </body>
                </html>
              """
            ),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                javaScriptEnabled: true,
                mediaPlaybackRequiresUserGesture: false,
                supportZoom: false,
              ),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webViewController = controller;
            },
            onProgressChanged: (InAppWebViewController controller, int progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
            shouldOverrideUrlLoading: (controller, navAction) async {
              final uri = navAction.request.url;
              final url = uri.toString();
              debugPrint('URL $url');
              if (url.startsWith('wc:')) {
                if (url.contains('bridge') && url.contains('key')) {
                  _wConnectC!.qrScanHandler(url);
                }
                return NavigationActionPolicy.CANCEL;
              } else {
                return NavigationActionPolicy.ALLOW;
              }
            },
          ),

          _progress < 1 ? SizedBox(
            height: 3,
            child: LinearProgressIndicator(
              value: _progress,
              color: hexaCodeToColor(AppColors.secondary),
              backgroundColor: hexaCodeToColor(AppColors.lowWhite),
              ),
            ) 
          : const SizedBox(),
        ],
      ),
    );
  }
}