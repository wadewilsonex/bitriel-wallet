import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_validation/form_validation.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/email_m.dart';

class EmailBody extends StatelessWidget {

  final EmailModel? model;
  final Function? login;

  EmailBody({
    this.model,
    this.login,
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingSize),
      child: Form(
        key: model!.getFmKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
    
            TextFormField(
              controller: model!.email,
              decoration: const InputDecoration(
                label: MyText(text: "Email",)
              ),
              validator: (value) {
                return Validator(
                  validators: [
                    RequiredValidator(),
                    EmailValidator()
                  ],
                ).validate(
                  context: context,
                  label: 'Email',
                  value: value,
                );
              }
            ),

            SizedBox(height: 10,),
    
            TextFormField(
              controller: model!.password,
              decoration: InputDecoration(
                label: MyText(text: "Password",)
              ),
              validator: (value) {
                return Validator(
                  validators: [
                    RequiredValidator(),
                    MinLengthValidator(length: 8),
                  ],
                ).validate(
                  context: context,
                  label: 'Password',
                  value: value,
                );
              },
            ),

            SizedBox(height: paddingSize,),
            
            ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 18)),
                backgroundColor: MaterialStateProperty.all(hexaCodeToColor(AppColors.secondary))
              ),
              onPressed: (){
                login!();
              }, 
              child: MyText(
                text: "Login", 
                width: MediaQuery.of(context).size.width,
                fontWeight: FontWeight.w600,
                color2: Colors.white,
                fontSize: 17,
              )
            )
          ],
        ),
      ),
    );
  }
}