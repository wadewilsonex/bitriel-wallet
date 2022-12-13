import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/screen/main/json/import_json.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SetPassword extends StatefulWidget {

  final String phoneNumber;
  final dynamic responseJson;
  const SetPassword({Key? key, required this.phoneNumber, this.responseJson}) : super(key: key);

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  HeadlessInAppWebView? _headlessInAppWebView;

  Future<void> _registerWallet() async {
    
    try {

      Navigator.push(context, Transition(child: ImportJson(password: password.text, json: widget.responseJson, webViewController: webViewController), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

      // final response = await PostRequest().registerSetPassword(widget.phoneNumber, password.text, confirmPassword.text);

      // final responseJson = json.decode(response.body);

      // if (response.statusCode == 200) {

      //   if(!mounted) return;
      //   // Navigator.push(context, Transition(child: OPTVerification(phoneNumber: getPhoneNumber), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          
      // }
      // else {
      //   if(!mounted) return;
      //   await customDialog(
      //     context, 
      //     "Error",
      //     responseJson['message']
      //   );
      // }

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          InAppWebView(
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
            initialOptions: options,
            onWebViewCreated: (controller) async {
              await controller.clearCache();
            },
            onLoadStop: (controller, uri) async {
              
              webViewController = controller;
              
              await webViewController!.injectJavascriptFileFromAsset(assetFilePath: "lib/src/js_api/dist/main.js");
            },
            
            onConsoleMessage: (controller, consoleMessage) {
              print(consoleMessage);
              // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
            },
          ),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              color: hexaCodeToColor("#F2F2F2"),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(paddingSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const MyText(
                    text: "Set a password \nto encrypt your wallet",
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    top: 30,
                    bottom: 30,
                  ),
          
                  tfPasswordWidget(password, "Password"),
                  
                  SizedBox(height: 20),
          
                  tfPasswordWidget(
                    confirmPassword, "Confirm Password",
                    onSubmit: _registerWallet
                  ),
          
                  Expanded(child: Container(),),
          
                  MyGradientButton(
                    textButton: "Finish",
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    action: () {
                      _registerWallet();
                      // Navigator.push(context, Transition(child: OPTVerification(phoneNumber: getPhoneNumber), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                    },
                  ),
                ],
              ),
            ),
          )
          
        ],
      ),
    );
  }
}