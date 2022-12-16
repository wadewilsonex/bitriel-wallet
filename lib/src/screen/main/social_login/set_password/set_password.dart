import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/provider/headless_webview_p.dart';
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

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  Future<void> _registerWallet() async {
    
    try {

      Navigator.push(context, Transition(child: ImportJson(password: password.text, json: widget.responseJson, webViewController: Provider.of<HeadlessWebView>(context, listen: false).headlessWebView!.webViewController), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

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
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
      ),
    );
  }
}