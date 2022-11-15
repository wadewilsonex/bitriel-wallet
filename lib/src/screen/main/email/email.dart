import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/email_m.dart';
import 'package:wallet_apps/src/screen/main/email/body_email.dart';

class Email extends StatefulWidget {
  const Email({Key? key}) : super(key: key);

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  
  EmailModel _model = EmailModel();

  Future<void> login() async {
    print("_model.email.text ${_model.email.text}");
    print("_model.password.text ${_model.password.text}");
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