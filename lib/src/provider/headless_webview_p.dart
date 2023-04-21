import 'package:wallet_apps/index.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HeadlessWebView with ChangeNotifier {

  HeadlessInAppWebView? headlessWebView;

  final InAppWebViewGroupOptions _options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    )
  );

  initHeadlessWebview() async {
    if (kDebugMode) {
      debugPrint("initHeadlessWebview");
    }
    headlessWebView = HeadlessInAppWebView(
      initialData: InAppWebViewInitialData(
        data: """
          <!DOCTYPE html>
          <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
              </head>
              <body>
              </body>
          </html>
        
        """
      ),
      initialOptions: _options,
      onWebViewCreated: (controller) async {
        if (kDebugMode) {
          debugPrint("onWebViewCreated");
        }
        await controller.clearCache();
      },
      onLoadStop: (controller, uri) async {

        if (kDebugMode) {
          debugPrint('controller uri');
        }
        
        // webViewController = controller;
        
        // await webViewController!.injectJavascriptFileFromAsset(assetFilePath: "assets/js/main.js");
        await headlessWebView!.webViewController.injectJavascriptFileFromAsset(assetFilePath: "assets/js/main.js");
      },
      
      onConsoleMessage: (controller, consoleMessage) {
        if (kDebugMode) {
          debugPrint("onConsoleMessage");
        }
        // it will debugPrint: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
      },
    );

    await headlessWebView!.run();

  }

}

//   final Widget? child;

//   StandaloneWebview({this.child});

//   @override
//   State<StandaloneWebview> createState() => _StandaloneWebviewState();
// }

// class _StandaloneWebviewState extends State<StandaloneWebview> {

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Stack(
//       children: [
        
//         InAppWebView(
//           initialData: InAppWebViewInitialData(
//             data: """
            
//               <!DOCTYPE html>
//               <html lang="en">
//                   <head>
//                       <meta charset="UTF-8">
//                       <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
//                   </head>
//                   <body>
//                   </body>
//               </html>
            
//             """
//           ),
//           initialOptions: options,
//           onWebViewCreated: (controller) async {
//             await controller.clearCache();
//           },
//           onLoadStop: (controller, uri) async {
            
//             webViewController = controller;
            
//             await webViewController!.injectJavascriptFileFromAsset(assetFilePath: "assets/js/main.js");
//           },
          
//           onConsoleMessage: (controller, consoleMessage) {
//             debugPrint(consoleMessage);
//             // it will debugPrint: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
//           },
//         ),
//       ],
//     )
//   }
// }