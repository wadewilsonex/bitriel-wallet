import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/walletconnect_c.dart';

class MarketPlaceWebView extends StatefulWidget {

  final String url;
  final String title;
  final String? wc;

  const MarketPlaceWebView({Key? key, required this.url, required this.title, this.wc}) : super(key: key);

  @override
  State<MarketPlaceWebView> createState() => _MarketPlaceWebViewState();
}

class _MarketPlaceWebViewState extends State<MarketPlaceWebView> {

  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  double _progress = 0;
  bool? isSecure;
  
  String getUrl = "";

  WalletConnectProvider? _wConnectC;

  @override
  void initState() {
    super.initState();

    _wConnectC = Provider.of<WalletConnectProvider>(context, listen: false);

    _wConnectC!.setBuildContext = context;

    setState(() {
      getUrl = widget.url;
    });
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(AppColors.primaryColor),
        // centerTitle: true,

        automaticallyImplyLeading: false
        ,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FutureBuilder<bool>(
              future: webViewController?.canGoBack() ?? Future.value(false),
              builder: (context, snapshot) {
                final canGoBack = snapshot.hasData ? snapshot.data! : false;
                return IconButton(
                  icon: Icon(Iconsax.arrow_left_2, color: hexaCodeToColor(!canGoBack ? AppColors.greyCode : AppColors.whiteColorHexa), size: 30,),
                  onPressed: !canGoBack
                    ? null
                    : () {
                      webViewController?.goBack();
                    },
                );
              },
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isSecure != null
                        ? Icon(isSecure == true ? Icons.lock : Icons.lock_open,
                          color: isSecure == true ? Colors.green : Colors.red,
                          size: 14)
                        : Container(),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          getUrl,
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                          overflow: TextOverflow.fade,
                        )
                      ),
                    ],
                  )
                ],
              )
            ),
            FutureBuilder<bool>(
              future: webViewController?.canGoForward() ?? Future.value(false),
              builder: (context, snapshot) {
                final canGoForward = snapshot.hasData ? snapshot.data! : false;
                return IconButton(
                  icon:  Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(!canGoForward ? AppColors.greyCode : AppColors.whiteColorHexa), size: 30,),
                  onPressed: !canGoForward
                    ? null
                    : () {
                      webViewController?.goForward();
                    },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(url: getUrl.startsWith("https") == true ? Uri.parse(getUrl) : Uri.parse("https://www.google.com/search?q=$getUrl")),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webViewController = controller;
                  },

                  onLoadStart: (controller, url) {
                    if (url != null) {
                      setState(() {
                        getUrl = url.toString();
                        isSecure = urlIsSecure(url);
                      });
                    }
                  },
                  onLoadStop: (controller, url) async {
                    if (url != null) {
                      setState(() {
                        getUrl = url.toString();
                      });
                    }
          
                    final sslCertificate = await controller.getCertificate();
                    setState(() {
                      isSecure = sslCertificate != null ||
                          (url != null && urlIsSecure(url));
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, isReload) {
                    // if (url != null) {
                    //   setState(() {
                    //     this.url = url.toString();
                    //   });
                    // }
                  },
                  // onTitleChanged: (controller, title) {
                  //   if (title != null) {
                  //     setState(() {
                  //       this.title = title;
                  //     });
                  //   }
                  // },
                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    setState(() {
                      _progress = progress / 100;
                    });
                  },
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                    ),
                  ),
                  
                  shouldOverrideUrlLoading: (controller, navAction) async {
                    final url = navAction.request.url.toString();
                    debugPrint('URL $url');
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
                  // shouldOverrideUrlLoading: (controller, navAction) async {
                  //   final uri = navAction.request.url;
                  //   final url = uri.toString();
                  //   debugPrint('URL $url');
                  //   if (url.startsWith('wc:')) {
                  //     if (url.contains('bridge') && url.contains('key')) {
                  //       _wConnectC!.qrScanHandler(url);
                  //     }
                  //     return NavigationActionPolicy.CANCEL;
                  //   } else {
                  //     return NavigationActionPolicy.ALLOW;
                  //   }
                  // },
                  onConsoleMessage: (controller, consoleMessage) {
                    debugPrint("consoleMessage $consoleMessage");
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
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Iconsax.share),
              onPressed: () {
                Share.share(getUrl, subject: widget.title);
              },
            ),
            IconButton(
              icon: const Icon(Iconsax.refresh),
              onPressed: () {
                webViewController?.reload();
              },
            ),
            PopupMenuButton<int>(
              onSelected: (item) => handleClick(item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: const [
                      Icon(Iconsax.chrome),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Open in the Browser')
                    ],
                  )
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Iconsax.close_circle),
              onPressed: () { 
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  } 

  void handleClick(int item) async {
    switch (item) {
      case 0:
        await InAppBrowser.openWithSystemBrowser(url: Uri.parse(getUrl));
        break;
    }
  }

  static bool urlIsSecure(Uri url) {
    return (url.scheme == "https") || isLocalizedContent(url);
  }

  static bool isLocalizedContent(Uri url) {
    return (url.scheme == "file" ||
        url.scheme == "chrome" ||
        url.scheme == "data" ||
        url.scheme == "javascript" ||
        url.scheme == "about");
  }

}