import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wallet_apps/index.dart';

class TrxExplorerWebView extends StatefulWidget {

  final String url;

  const TrxExplorerWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<TrxExplorerWebView> createState() => _TrxExplorerWebViewState();
}

class _TrxExplorerWebViewState extends State<TrxExplorerWebView> {

  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  double _progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const MyText(
            text: 'Selendra Explorer',
            fontWeight: FontWeight.bold,
            fontSize: 20,
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