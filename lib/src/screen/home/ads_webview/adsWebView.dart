import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wallet_apps/index.dart';

class AdsWebView extends StatefulWidget {

  final Map<String, dynamic>? item;
  final String? url;
  final String? title;

  AdsWebView({Key? key, this.item, this.url, this.title}) : super(key: key);

  @override
  State<AdsWebView> createState() => _AdsWebViewState();
}

class _AdsWebViewState extends State<AdsWebView> {

  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  double _progress = 0;

  @override
  void initState() {
    print("item: ${widget.item}");
    print("url: ${widget.item}");
    print("item: ${widget.item}");
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
        title: MyText(
          text: widget.item != null ? widget.item!['title'] : widget.title!,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: Uri.parse(widget.item != null ? widget.item!['url'] : widget.url!)),
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
          : SizedBox(),
        ],
      )
    );
  } 
}