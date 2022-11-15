import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/email_m.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/email/body_email.dart';
import 'package:wallet_apps/src/screen/main/json/import_json.dart';
import 'package:wallet_apps/src/screen/main/seeds_phonenumber/register/set_password/set_password.dart';

class Email extends StatefulWidget {
  const Email({Key? key}) : super(key: key);

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  
  EmailModel _model = EmailModel();

  bool _loading = false;

  Future<void> login() async {
    // print("_model.email.text ${_model.email.text}");
    // print("_model.password.text ${_model.password.text}");
    // setState(() => _loading = true);
    // await Future.delayed(Duration(seconds: 3));
    // _loading = false;
    // if (mounted == true) {
    //   setState(() {});
    // }
    print(Form.of(context)?.validate());
    if (_model.getFmKey.currentState!.validate()){
      await _decryptDataLogin();
    }
    
  }

  Future<void> _decryptDataLogin() async {
    print("_decryptDataLogin");
    try {

      // Verify OTP with HTTPs
      
      Response response = Response(await rootBundle.loadString('assets/json/phone.json'), 200);

      final responseJson = json.decode(response.body);
      print("responseJson ${responseJson.runtimeType}");
      print(responseJson['user'].containsKey("encrypted"));

      if (response.statusCode == 200) {

        // if(!mounted) return;
        if (responseJson['user'].containsKey("encrypted")){

          // Navigator.pushAndRemoveUntil(
          //   context, 
          //   MaterialPageRoute(builder: (context) => HomePage()), 
          //   (route) => false
          // );
          // Navigator.push(context, Transition(child: SetPassword(phoneNumber: widget.phoneNumber!, responseJson: responseJson), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          Navigator.push(context, Transition(child: ImportJson(json: responseJson, password: "123",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        }
          
      } else if (response.statusCode == 401) {

        if(!mounted) return;
        customDialog(
          context, 
          "Error",
          responseJson['message']
        );

        if(!mounted) return;
        Navigator.of(context).pop();

      } else if (response.statusCode >= 500 && response.statusCode < 600) {

        if(!mounted) return;
        customDialog(
          context, 
          "Error",
          responseJson['message']
        );

        if(!mounted) return;
        Navigator.of(context).pop();

      }

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: "Email", fontWeight: FontWeight.w600,),
        elevation: 0,
      ),
      body: EmailBody(
        model: _model,
        login: login,
        
      )
    );
  }
}