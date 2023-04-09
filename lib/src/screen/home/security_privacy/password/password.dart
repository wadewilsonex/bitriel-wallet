import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/security_privacy/password/body_password.dart';

class PasswordSecurity extends StatefulWidget {
  const PasswordSecurity({Key? key}) : super(key: key);

  @override
  State<PasswordSecurity> createState() => _PasswordSecurityState();
}

class _PasswordSecurityState extends State<PasswordSecurity> {
  
  ModelUserInfo? _modelUserInfo = ModelUserInfo();

  Future<void> _onSubmit() async {
    
    if(_modelUserInfo!.confirmPasswordCon.text.isEmpty || _modelUserInfo!.confirmPasswordCon.text.isEmpty){
      customDialog(context, "Opps", "You must input password", txtButton: "OK");
    }
    else if(_modelUserInfo!.passwordCon.text == _modelUserInfo!.confirmPasswordCon.text) {
      dialogLoading(context);

      await StorageServices.writeSecure(DbKey.password, _modelUserInfo!.confirmPasswordCon.value.text).then((value) async{
        
        await StorageServices.readSecure(DbKey.password)!.then((value) {
          print("value $value");
          Navigator.pop(context);
        });
      });

      // // Close pop screen
      if(!mounted) return;
      Navigator.pop(context);

    }
    else{
      customDialog(context, "Opps", "Your password input not matched", txtButton: "OK");
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    
    _modelUserInfo = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BodyPasswordSecurity(
      userInfo: _modelUserInfo,
      onSubmit: _onSubmit
    );
  }
}