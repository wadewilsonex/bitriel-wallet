import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/components/walletconnect_c.dart';

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

    WalletConnectProvider wConnectC = Provider.of<WalletConnectProvider>(context, listen: false);
    
    wConnectC.setBuildContext = context;

  }

  WalletConnectProvider? _wConnectC;

  @override
  void initState() {
    super.initState();
    _wConnectC = Provider.of<WalletConnectProvider>(context, listen: false);

    _wConnectC!.setBuildContext = context;
    
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // return InAppWebView(
    //   key: webViewKey,
    //   // initialUrlRequest: URLRequest(url: Uri.parse("https://letsexchange.io/")),
    //   initialData: InAppWebViewInitialData(
    //     data: """
    //       <!DOCTYPE html>
    //       <html lang="en">
    //           <head>
    //             <meta charset="UTF-8" />
    //             <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    //             <title>Let's Exchange</title>
    //           </head>
    
    //           <body>
    
    //             <link rel="stylesheet" type="text/css" href="https://letsexchange.io/widget_lets.css"><div class="lets-widget" id="lets_widget_kn0jXoqXjWt8TYid"  style="max-width: 480px; height: 480px;">  <iframe src="https://letsexchange.io/v2/widget?affiliate_id=kn0jXoqXjWt8TYid&is_iframe=true" width="100%" height="100%" frameBorder="0" allow="clipboard-read; clipboard-write"></iframe></div><script src="https://letsexchange.io/init_widget.js"></script>
    
    //           </body>
    //       </html>
    //     """
    //   ),
    //   initialOptions: InAppWebViewGroupOptions(
    //     crossPlatform: InAppWebViewOptions(
    //       useShouldOverrideUrlLoading: true,
    //       javaScriptEnabled: true,
    //       mediaPlaybackRequiresUserGesture: false,
    //       supportZoom: false,
    //     ),
    //   ),
    //   onWebViewCreated: (InAppWebViewController controller) {
    //     webViewController = controller;
    //   },
    //   onProgressChanged: (InAppWebViewController controller, int progress) {
    //     setState(() {
    //       _progress = progress / 100;
    //     });
    //   },
    //   shouldOverrideUrlLoading: (controller, navAction) async {
    //     final url = navAction.request.url.toString();
    //     
    //     if (url.contains('wc?uri=')) {
    //       final wcUri = Uri.parse(Uri.decodeFull(Uri.parse(url).queryParameters['uri']!));
    //       _wConnectC!.qrScanHandler(wcUri.toString());
    //       return NavigationActionPolicy.CANCEL;
    //     } else if (url.startsWith('wc:')) {
    //       _wConnectC!.qrScanHandler(url);
    //       return NavigationActionPolicy.CANCEL;
    //     } else {
    //       return NavigationActionPolicy.ALLOW;
    //     }
    //   },
    // );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        title: MyText(
          text: "Let's Exchange",
          fontSize: 20,
          fontWeight: FontWeight.w600,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor,
        ),
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: const Icon(Iconsax.arrow_left_2, size: 30,),
        // ),
        automaticallyImplyLeading: false,    
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Iconsax.close_circle, size: 30,),
          ),
        ],

      ),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: Uri.parse("https://letsexchange.io/v2/widget?affiliate_id=kn0jXoqXjWt8TYid&is_iframe=true")),
            // initialData: InAppWebViewInitialData(
            //   data: """
            //     <!DOCTYPE html>
            //     <html lang="en">
            //         <head>
            //           <meta charset="UTF-8">
            //           <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">                    
            //         </head>

            //         <body>

            //           <link rel="stylesheet" type="text/css" href="https://letsexchange.io/widget_lets.css"><div class="lets-widget" id="lets_widget_kn0jXoqXjWt8TYid"  style="max-width: 480px; height: 526px;">  <iframe src="https://letsexchange.io/v2/widget?affiliate_id=kn0jXoqXjWt8TYid&is_iframe=true" width="100%" height="100%" frameBorder="0" allow="clipboard-read; clipboard-write"></iframe></div><script src="https://letsexchange.io/init_widget.js"></script>

            //         </body>
            //     </html>
            //   """
            // ),
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
              final url = navAction.request.url.toString();
              
              if (url.contains('wc?uri=')) {
                final wcUri = Uri.parse(Uri.decodeFull(Uri.parse(url).queryParameters['uri']!));
                
                _wConnectC!.qrScanHandler(wcUri.toString());
                return NavigationActionPolicy.CANCEL;
              } else if (url.startsWith('wc:')) {
                _wConnectC!.qrScanHandler(url);
                return NavigationActionPolicy.CANCEL;
              } else {
                return NavigationActionPolicy.ALLOW;
              }
            },
            onConsoleMessage: (controller, consoleMessage) {
              
            },
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
            },
            onLoadError: (controller, url, code, message) async {
              if (Platform.isIOS && code == -999) {
                // NSURLErrorDomain
                return;
              }

              url = (url ?? 'about:blank') as Uri?;

              webViewController?.loadData(data: """
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
                    <meta http-equiv="X-UA-Compatible" content="ie=edge">
                    <style>
                    ${await webViewController?.getTRexRunnerCss()}
                    </style>
                    <style>
                    .interstitial-wrapper {
                        box-sizing: border-box;
                        font-size: 1em;
                        line-height: 1.6em;
                        margin: 0 auto 0;
                        max-width: 600px;
                        width: 100%;
                    }
                    </style>
                </head>
                <body>
                    ${await webViewController?.getTRexRunnerHtml()}
                    <div class="interstitial-wrapper">
                      <h1>Website not available</h1>
                      <p>Could not load web pages at <strong>$url</strong> because:</p>
                      <p>$message</p>
                    </div>
                </body>
                """, baseUrl: url, historyUrl: url);
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