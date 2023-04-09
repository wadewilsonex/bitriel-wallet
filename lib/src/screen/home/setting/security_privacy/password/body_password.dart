import 'package:wallet_apps/index.dart';

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
            child: tfPasswordWidget(userInfo!.passwordCon, "Password"),
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