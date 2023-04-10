import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';

class BodyPasswordSecurity extends StatelessWidget {
  final bool? isChangePwd;
  final ModelUserInfo? userInfo;
  final Function? onSubmit;
  
  const BodyPasswordSecurity({
    Key? key,
    this.isChangePwd,
    this.userInfo,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        elevation: 0,
        bottomOpacity: 0,
        title: MyText(
          text: isChangePwd! == false ? "Set Up Password" : "Change Password",
          hexaColor: AppColors.blackColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 30,
          ),
        ),
        actions: [

          if (isChangePwd!) TextButton(
            onPressed: () async {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {

                  return StatefulBuilder(
                    builder: (context, mySetState) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        title: const Align(
                          child: MyText(
                            text: "Fill Your Password",
                          ),
                        ),
                        content: Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: userInfo!.passwordCon,
                              ),

                              if (userInfo!.msg != null ) MyText(top: 5, text: userInfo!.msg, fontSize: 15, color2: Colors.red,)
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          
                          TextButton(
                            onPressed: () async {

                              await StorageServices.readSecure(DbKey.password)!.then((String? value) async {
                                
                                if (value == userInfo!.passwordCon.text){

                                  mySetState(() {
                                    userInfo!.msg = null;
                                  });

                                  if (value != null){
                                    await StorageServices.clearKeySecure(DbKey.password);
                                    // ignore: use_build_context_synchronously
                                    Navigator.popUntil(context, ModalRoute.withName(AppString.homeView));
                                  }
                                } else {
                                  print("Else");
                                  mySetState( () {
                                    userInfo!.msg = "Wrong Password";
                                  });
                                }
                              });
                            }, 
                            child: MyText(
                              text: "Submit"
                            )
                          )
                        ]
                      );
                    }
                  );
                }
              );
            },
            child: MyText(text: "Disable Password", fontWeight: FontWeight.bold, color2: Colors.red,),
          )
        ],
      ),
      body: Column(
        children: [
          _passwordField(context)
        ],
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
    
          const SizedBox(height: 20),

          if (isChangePwd == true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingSize),
            child: tfPasswordWidget(userInfo!.oldPwdCon, "Old Password"),
          )
          else Container(),

          if (isChangePwd == true)
          const SizedBox(height: 20),
    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingSize),
            child: tfPasswordWidget(userInfo!.passwordCon, isChangePwd! ? "New Password" : "Password"),
          ),
                
          const SizedBox(height: 20),
    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingSize),
            child: tfPasswordWidget(userInfo!.confirmPasswordCon, "Confirm Password",
            ),
          ),
    
          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: MyGradientButton(
              textButton: "Submit",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: (){
                onSubmit!();
              }
            ),
          )
    
        ],
      ),
    );
  }

}