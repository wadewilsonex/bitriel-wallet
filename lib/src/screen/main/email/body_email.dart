import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';

class EmailBody extends StatelessWidget {
  const EmailBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            label: MyText(text: "Email",)
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            label: MyText(text: "Password",)
          ),
        ),
        
        ElevatedButton(
          onPressed: (){

          }, 
          child: MyText(
            text: "Login", 
            width: MediaQuery.of(context).size.width,
            color2: Colors.white,
          )
        )
      ],
    );
  }
}