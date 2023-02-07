import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String url = "";

  void walletConnect() async{

    WalletConnectComponent wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);
    
    wConnectC.setBuildContext = context;

  }

  WalletConnectComponent? _wConnectC;

  @override
  void initState() {
    super.initState();

    url = widget.url;

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
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(AppColors.primaryColor),
        centerTitle: true,
        // title: MyText(
        //   text:  widget.title,
        //   fontWeight: FontWeight.bold,
        //   hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
        // ),

        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FutureBuilder<bool>(
              future: webViewController?.canGoBack() ?? Future.value(false),
              builder: (context, snapshot) {
                final canGoBack = snapshot.hasData ? snapshot.data! : false;
                return IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
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
                              size: 12)
                          : Container(),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          widget.url,
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
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: !canGoForward
                      ? null
                      : () {
                          webViewController?.goForward();
                        },
                );
              },
            ),

            Container(),
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
                  initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    if (url != null) {
                      setState(() {
                        this.url = url.toString();
                        isSecure = urlIsSecure(url);
                      });
                    }
                  },
                  onLoadStop: (controller, url) async {
                    if (url != null) {
                      setState(() {
                        this.url = url.toString();
                      });
                    }
          
                    final sslCertificate = await controller.getCertificate();
                    setState(() {
                      isSecure = sslCertificate != null ||
                          (url != null && urlIsSecure(url));
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, isReload) {
                    if (url != null) {
                      setState(() {
                        this.url = url.toString();
                      });
                    }
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
                    // final uri = navAction.request.url;
                    // final url = uri.toString();
                    final url = navAction.request.url;
                    debugPrint('URL $url');
                    // if (url.startsWith('wc:')) {
                    //   if (url.contains('bridge') && url.contains('key')) {
                    //     _wConnectC!.qrScanHandler(url);
                    //   }
                    //   return NavigationActionPolicy.CANCEL;
                    // } else {
                    //   return NavigationActionPolicy.ALLOW;
                    // }
          
                    if (navAction.isForMainFrame &&
                      url != null &&
                      ![
                        'http',
                        'https',
                        'file',
                        'chrome',
                        'data',
                        'javascript',
                        'about'
                      ].contains(Uri.parse(widget.url).scheme)) {
                    if (await canLaunchUrl(Uri.parse(widget.url))) {
                      launchUrl(Uri.parse(widget.url));
                      return NavigationActionPolicy.CANCEL;
                    }
                  }
                  return NavigationActionPolicy.ALLOW;
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
              icon: const Icon(Icons.share),
              onPressed: () {
                Share.share(widget.url, subject: widget.title);
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
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
                        Icon(Icons.open_in_browser),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Open in the Browser')
                      ],
                    )),
                // PopupMenuItem<int>(
                //     value: 1,
                //     child: Row(
                //       children: const [
                //         Icon(Icons.clear_all),
                //         SizedBox(
                //           width: 5,
                //         ),
                //         Text('Clear your browsing data')
                //       ],
                //     )),
              ],
            ),
          ],
        ),
      ),
    );
  } 

  void handleClick(int item) async {
    switch (item) {
      case 0:
        await InAppBrowser.openWithSystemBrowser(url: Uri.parse(widget.url));
        break;
      // case 1:
      //   await webViewController?.clearCache();
      //   if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      //     await webViewController?.clearHistory();
      //   }
      //   setState(() {});
      //   break;
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