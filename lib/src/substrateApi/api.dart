// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/store/app.dart';

// Api webApi;

// class Api {

//   final BuildContext context;
//   final AppStore store;

//   /// preload js code for opening dApps
//   String asExtensionJSCode;

//   FlutterWebviewPlugin _web;
//   Function _onLaunched;

//   Map<String, Function> _msgHandlers = {};
//   Map<String, Completer> _msgCompleters = {};
//   int _evalJavascriptUID = 0;
//   Function _connectFunc;

//   StreamSubscription _subscription;

//   Api({this.context, this.store});

//   void init() async {
//     try {

//       await launchWebView();

//       DefaultAssetBundle.of(context).loadString('lib/src/js_api/dist/main.js').then((String js) {
//         asExtensionJSCode = js;
//       });
//     } catch (e) {
//       print("Error $e");
//     }
//   }  
  
//   Future<void> launchWebView({bool customNode = false}) async {
//     // _msgHandlers = {'txStatusChange': ApiProvider.sdk.api.account.setTxStatus};
//     _evalJavascriptUID = 0;
//     _msgCompleters = {};

//     // _connectFunc = customNode ? connectNode : connectNodeAll;

//     print("_web $_web");

//     if (_web != null) {
//       _web.reload();
//       return;
//     }

//     _web = FlutterWebviewPlugin();

//     await _web.onStateChanged.listen((event) {
//       if (event.type == WebViewState.finishLoad){
//         DefaultAssetBundle.of(context).loadString('lib/js_api/dist/main.js').then((String js) {
//           print('js file loaded $js');
//           _startJSCode(js);
//         });
//       }
//     });

//     await _web.launch(
//       'about:blank',
//       javascriptChannels: [
//         JavascriptChannel(
//             name: 'PolkaWallet',
//             onMessageReceived: (JavascriptMessage message) {
//               print('received msg: ${message.message}');
//               compute(jsonDecode, message.message).then((msg) {
                
//                 final String path = msg['path'];
//                 if (_msgCompleters[path] != null) {
//                   Completer handler = _msgCompleters[path];
//                   handler.complete(msg['data']);
//                   if (path.contains('uid=')) {
//                     _msgCompleters.remove(path);
//                   }
//                 }
//                 if (_msgHandlers[path] != null) {
//                   Function handler = _msgHandlers[path];
//                   handler(msg['data']);
//                 }
//               });
//             }),
//       ].toSet(),
//       ignoreSSLErrors: true,
// //        withLocalUrl: true,
// //        localUrlScope: 'lib/polkadot_js_service/dist/',
//       hidden: true,
//     );

//     print("After _web $_web");
//   }

//   Future<void> connectNode() async {

//     // String node = ApiProvider.sdk.api.setting.//api.settings.endpoint.value;
//     // // do connect
//     // String res = await evalJavascript('settings.connect("$node")');
//     // if (res == null) {
//     //   print('connect failed');
//     //   store.settings.setNetworkName(null);
//     //   return;
//     // }
//     // fetchNetworkProps();
//   }

//   void _startJSCode(String js) async {
//     // inject js file to webview
//     await _web.evalJavascript(js);

//     // load keyPairs from local data
//     // account.initAccounts();

//     // connect remote node
//     await _connectFunc();
//   }
  
// }