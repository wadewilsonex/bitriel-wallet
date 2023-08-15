import 'package:bitriel_wallet/index.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AdsWebView extends StatefulWidget {

  final Map<String, dynamic>? item;
  final String url;
  final String title;

  const AdsWebView({Key? key, this.item, required this.url, required this.title}) : super(key: key);

  @override
  State<AdsWebView> createState() => _AdsWebViewState();
}

class _AdsWebViewState extends State<AdsWebView> {

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
      appBar: appBar(context, title: widget.title),
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
      )
    );
  } 
}