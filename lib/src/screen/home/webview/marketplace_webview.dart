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
        // leading: IconButton(
        //   onPressed: () => Navigator.of(context).pop(),
        //   icon: const Icon(Iconsax.arrow_left_2),
        // ),
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