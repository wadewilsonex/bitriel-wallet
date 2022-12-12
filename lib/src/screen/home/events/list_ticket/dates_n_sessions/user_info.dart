import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/mdw_ticketing/user_info_m.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';


class UserInfo extends StatefulWidget {

  UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  
  void onChanged(String value){
    setState(() {
      
    });
  }

  UserInfoModel model = UserInfoModel();

  PhoneCountryData? _initialCountryData;

  String? email = '';

  @override
  initState(){
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'RU',
      newMask: '+0 (000) 000 00 00',
    );
    print("(model.email.text.isEmpty || model.name.text.isEmpty || model.phoneNumber.text.isEmpty) ${(model.email.text.isEmpty || model.name.text.isEmpty || model.phoneNumber.text.isEmpty)}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          padding: const EdgeInsets.all(16),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                
                TextFormField(
                  controller: model.name,
                  decoration: InputDecoration(
                    label: Text("Name")
                  ),
                  onChanged: onChanged,
                ),
                TextFormField(
                  controller: model.phoneNumber,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [ FilteringTextInputFormatter.allow(RegExp('[0-9.,]')) ],
                  decoration: InputDecoration(
                    label: Text("Phone number")
                  ),
                  onChanged: onChanged,
                ),
                TextFormField(
                  controller: model.email,
                  decoration: InputDecoration(
                    label: Text("Email")
                  ),
                  validator: (value) {
                    print("value validate $value");
                    if(value == null || value.isEmpty || !value.contains('@') || !value.contains('.')){
                      return 'Invalid Email';
                    }
                    email = null;
                    return null;
                  },
                  onChanged: onChanged,
                ),
              
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                      backgroundColor: MaterialStatePropertyAll(hexaCodeToColor( (model.email.text.isEmpty || model.name.text.isEmpty || model.phoneNumber.text.isEmpty || email != null) ? AppColors.greyCode : AppColors.primaryColor ))
                    ),
                    onPressed: (model.email.text.isEmpty || model.name.text.isEmpty || model.phoneNumber.text.isEmpty || email != null) ? null : 
                    (){
                      print("model.email.text ${model.name.text}");
                      print("model.email.text ${model.phoneNumber.text}");
                      print("model.email.text ${model.email.text}");
                      print(model.email.text.isEmpty || model.name.text.isEmpty || model.phoneNumber.text.isEmpty);
                      Navigator.pop(context, model);
                    }, 
                    child: MyText(
                      width: MediaQuery.of(context).size.width,
                      color2: Colors.white,
                      text: "Next",
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}