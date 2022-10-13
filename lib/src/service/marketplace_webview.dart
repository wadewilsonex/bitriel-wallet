import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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

  void walletConnect() async{

    WalletConnectComponent wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);
    
    wConnectC.setBuildContext = context;

    

    
    // Create a connector
    // final connector = WalletConnect(
    //   uri: "wc:d5cd43e5-88a8-4f81-bcff-986c44c081cf@1?bridge=https%3A%2F%2Fe.bridge.walletconnect.org&key=4c34306b5acf5d730a8425fcd69a3c44a9e5d20ac1768d7f6f99be30aa654766",
    //   clientMeta: PeerMeta(
    //     name: 'WalletConnect',
    //     description: 'WalletConnect Developer App',
    //     url: 'https://walletconnect.org',
    //     icons: [
    //       'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
    //     ],
    //   ),
    // );

    // // Subscribe to events
    // connector.on('connect', (session) => print("connect webview ${session}"));
    // connector.on('session_request', (payload) => print("session_request ${payload}"));
    // connector.on('disconnect', (session) => print("disconnect ${session}"));

    // await connector.approveSession(chainId: 1, accounts: ['0xa7f5f726b2395af66a2a4f5cb6fd903e596c37c7']);
  }

  WalletConnectComponent? _wConnectC;

  @override
  void initState() {
    super.initState();
    _wConnectC = Provider.of<WalletConnectComponent>(context, listen: false);

    _wConnectC!.setBuildContext = context;

    // walletConnect();

    
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
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        centerTitle: true,
        title: MyText(
          text:  widget.title,
          fontWeight: FontWeight.bold,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
            onWebViewCreated: (InAppWebViewController controller) {
              webViewController = controller;
            },
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
      )
    );
  } 
}