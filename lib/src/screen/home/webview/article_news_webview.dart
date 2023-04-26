import 'package:share_plus/share_plus.dart';
import 'package:wallet_apps/index.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebView extends StatefulWidget {
  final String url;
  final String title;

  const ArticleWebView({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ArticleWebViewState();
  }
}

class _ArticleWebViewState extends State<ArticleWebView> {

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    // #docregion webview_controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    // #enddocregion webview_controller
  }

  @override
  void dispose(){
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

        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            
            IconButton(
              icon: Icon(Iconsax.arrow_left_2, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 30,),
              onPressed: () async {
                if (await controller.canGoBack()) {
                  await controller.goBack();
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No back history item')),
                    );
                  }
                }
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
                  Text(
                    widget.url,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    overflow: TextOverflow.fade,
                  )
                ],
              )
            ),
            
            IconButton(
              icon:  Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.whiteColorHexa), size: 30,),
              onPressed: () async {
                if (await controller.canGoForward()) {
                  await controller.goForward();
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No forward history item')),
                    );
                  }
                }
              },
            ),

          ],
        ),
      ),
      body: WebViewWidget(controller: controller,),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Iconsax.share),
              onPressed: () {
                Share.share(widget.url, subject: widget.title);
              },
            ),
            IconButton(
              icon: const Icon(Iconsax.refresh),
              onPressed: () {
                controller.reload();
              },
            ),
            IconButton(
              icon: const Icon(Iconsax.close_circle),
              onPressed: () { 
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

}
