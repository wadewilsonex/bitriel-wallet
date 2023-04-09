import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/setting/security_privacy/password/body_password.dart';

class PasswordSecurity extends StatefulWidget {

  bool? isChangePwd;
  PasswordSecurity({Key? key, this.isChangePwd = false}) : super(key: key);

  @override
  State<PasswordSecurity> createState() => _PasswordSecurityState();
}

class _PasswordSecurityState extends State<PasswordSecurity> {
  
  ModelUserInfo? _modelUserInfo = ModelUserInfo();

  String? status;

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

  Future<void> checkOldPwd() async {

    await StorageServices.readSecure(DbKey.password)!.then((value) async {
      print("Value $value");
      print(value != _modelUserInfo!.oldPwdCon.text);
      if (value != _modelUserInfo!.oldPwdCon.text){
        status = "Invalid Old Password";
      } 
      else {

        if (_modelUserInfo!.passwordCon.text == _modelUserInfo!.confirmPasswordCon.text){

          await StorageServices.writeSecure(DbKey.password, _modelUserInfo!.confirmPasswordCon.text);
          status = null;
        } else {
          status = "Password does not match";
        }
      }
      
      setState(() {
        
      });
    });

    // ignore: use_build_context_synchronously
    await dialogSuccess(
      context, 
      MyText(text: status == null ? "Your password is updated" : status ?? 'null',), 
      MyText(text: status == null ? "Successfully" : "Oops",),
      action: TextButton(
        onPressed: (){
          if (status == null){
            Navigator.popUntil(context, ModalRoute.withName(AppString.homeView));
          } else {
            Navigator.pop(context);
          }
        },
        child: const MyText(text: "Close", fontWeight: FontWeight.bold,)
      )
    );
  }

  Future<void> submit() async {
    
    if (widget.isChangePwd == true){
      checkOldPwd();
    } else {
      _onSubmit();
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
      isChangePwd: widget.isChangePwd,
      userInfo: _modelUserInfo,
      onSubmit: submit
    );
  }
}