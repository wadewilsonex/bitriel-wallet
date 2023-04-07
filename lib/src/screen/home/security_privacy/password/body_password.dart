import 'package:wallet_apps/index.dart';

class BodyPasswordSecurity extends StatelessWidget {
  final ModelUserInfo? userInfo;
  final Function? onSubmit;
  
  const BodyPasswordSecurity({
    Key? key,
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
        title: const MyText(
          text: "Set Up Password",
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
    
          // const Spacer(),
    
          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: MyGradientButton(
              textButton: "Set Up",
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