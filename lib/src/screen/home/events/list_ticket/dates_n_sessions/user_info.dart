import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/mdw_ticketing/user_info_m.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            onChanged: onChanged,
          ),
        
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
                padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                backgroundColor: MaterialStatePropertyAll(hexaCodeToColor( (model.email.text.isEmpty && model.name.text.isEmpty && model.phoneNumber.text.isEmpty) ? AppColors.primaryColor : AppColors.greyCode))
              ),
              onPressed: (model.email.text.isEmpty || model.name.text.isEmpty || model.phoneNumber.text.isEmpty) ? null : 
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
    );
  }
}