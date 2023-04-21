import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/setting/security_privacy/password/body_password.dart';

class PasswordSecurity extends StatefulWidget {
  final Function? switchBio;
  final bool? isChangePwd;

  const PasswordSecurity({Key? key, this.isChangePwd = false, this.switchBio}) : super(key: key);

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

      await StorageServices.writeSecure(DbKey.password, _modelUserInfo!.confirmPasswordCon.value.text).then((value) async{
        
        await StorageServices.readSecure(DbKey.password)!.then((value) {
          DialogComponents().dialogCustom(
            barrierDismissible: false,
            onWillPop: false,
            context: context,
            titles: "Your password has been setup!",
            btn2: MyGradientButton(
              textButton: "Ok",
              textColor: AppColors.lowWhite,
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: () async {
                Navigator.popUntil(context, ModalRoute.withName(AppString.homeView));
              },
            )
          );
        });
      });

    }
    else{
      customDialog(context, "Opps", "Your password input not matched", txtButton: "OK");
    }
  }

  Future<void> checkOldPwd() async {

    await StorageServices.readSecure(DbKey.password)!.then((value) async {
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
    DialogComponents().dialogCustom(
      barrierDismissible: false,
      onWillPop: false,
      context: context,
      titles: status == null ? "Successfully" : "Oops",
      contents: status == null ? "Your password is updated" : status ?? 'null',
      btn2: MyGradientButton(
        textButton: "Ok",
        textColor: AppColors.lowWhite,
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        action: () {
          if (status == null){
            Navigator.popUntil(context, ModalRoute.withName(AppString.homeView));
          } else {
            Navigator.pop(context);
          }
        },
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
      onSubmit: submit,
      switchBio: widget.switchBio,
    );
  }
}