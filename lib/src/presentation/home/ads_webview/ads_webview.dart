import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wallet_apps/index.dart';

class AdsWebView extends StatefulWidget {

  final Map<String, dynamic>? item;
  final String? url;
  final String? title;

  const AdsWebView({Key? key, this.item, this.url, this.title}) : super(key: key);

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
      appBar: AppBar(
        toolbarHeight: 10.vmax,
        backgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        elevation: 0,
        bottomOpacity: 0,
        leadingWidth: 7.vmax,
        // iconTheme: IconThemeData(
        //   color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        // ),
        // backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        centerTitle: true,
        title: MyText(
          text: widget.item != null ? widget.item!['title'] : widget.title!,
          fontWeight: FontWeight.bold,
          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Iconsax.arrow_left_2, size: 4.vmax,),
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
          : const SizedBox(),
        ],
      )
    );
  } 
}