// import 'package:wallet_apps/index.dart';

// class TestProvider{

//   ValueNotifier<bool>? isConnected = ValueNotifier<bool>(false);

//   void checkConnect(BuildContext context) async {
//     ApiProvider api = Provider.of<ApiProvider>(context, listen: false);

//     await api.getSdk.webView!.evalJavascript("settings.getIsConnected()").then((value) {
//       isConnected = value;

//     });
//   }
// }