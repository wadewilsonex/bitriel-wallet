import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/constants/db_key_con.dart';

class BodyPasswordSecurity extends StatelessWidget {
  final bool? isChangePwd;
  final ModelUserInfo? userInfo;
  final Function? onSubmit;
  final Function? switchBio;
  
  const BodyPasswordSecurity({
    Key? key,
    this.isChangePwd,
    this.userInfo,
    this.onSubmit,
    this.switchBio,
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
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            tfPasswordWidget(userInfo!.changePasswordCon, "Current Password",),
                            // TextFormField(
                            //   controller: userInfo!.passwordCon,
                            // ),

                            if (userInfo!.msg != null ) MyText(top: 5, text: userInfo!.msg, fontSize: 15, color2: Colors.red,)
                          ],
                        ),
                        actions: <Widget>[
                          
                          Padding(
                            padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize),
                            child: MyGradientButton(
                              textButton: "Submit",
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight, 
                              action: () async {
                          
                                await StorageServices.readSecure(DbKey.password)!.then((String? value) async {
                                  
                                  if (value == userInfo!.changePasswordCon.text){
                                    await switchBio!(context, false);  
                          
                                    userInfo!.msg = null;
                          
                                    if (value != null){
                                      await StorageServices.clearKeySecure(DbKey.password);
                                      // ignore: use_build_context_synchronously
                                      Navigator.popUntil(context, ModalRoute.withName(AppString.homeView));
                                    }
                                  } else {
                                    
                                    mySetState( () {
                                      userInfo!.msg = "Wrong Password";
                                    });
                                  }
                                });
                              },
                            ),
                          )
                        ]
                      );
                    }
                  );
                }
              );
            },
            child: const MyText(text: "Disable Password", fontWeight: FontWeight.bold, color2: Colors.red,),
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
            child: tfPasswordWidget(userInfo!.oldPwdCon, "Current Password",),
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