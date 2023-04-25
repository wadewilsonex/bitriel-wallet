import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/setting/security_privacy/password/password.dart';

class SecurityPrivacy extends StatefulWidget {
  
  final MenuModel? model;
  final Function? switchBio;
  const SecurityPrivacy({Key? key, this.model, this.switchBio}) : super(key: key);

  @override
  State<SecurityPrivacy> createState() => _SecurityPrivacyState();
}

class _SecurityPrivacyState extends State<SecurityPrivacy> {

  bool? isPassword = false;

  Future<void> checkPassword() async {

    await StorageServices.readSecure(DbKey.password)!.then((value) {
      if (value.isNotEmpty){
        setState(() {
          isPassword = true;
        });
      }
    });
  }

  @override
  initState(){
    checkPassword();
    super.initState();
  }

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
          text: "Security & Privacy",
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
      body: StatefulBuilder(
        builder: (context, setStateWidget) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // _backupSeed(context),

                _password(context),

                _securityLayer(context, setStateWidget),

              ],
            ),
          );
        }
      ),
    );
  }

  Widget _password(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const MyText(text: "Password", fontSize: 18, fontWeight: FontWeight.bold,),

          const MyText(
            text: "Choose a strong password to unlock Bitriel app on your devices. If you lost or forgot password, you will need your secret recovery phrase to re-import your wallet", 
            hexaColor: AppColors.greyCode,
            textAlign: TextAlign.start,
            top: 10,
          ),

          SizedBox(height: 2.h,),

          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: hexaCodeToColor(AppColors.primaryColor))
                  )
                )
              ),
              onPressed: () {

                Navigator.push(
                  context, 
                  Transition(
                    child: PasswordSecurity(isChangePwd: isPassword, switchBio: widget.switchBio,),
                    transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                  )
                );
              },
              child: MyText(text: isPassword! == false ? "Setup Password" : "Change Password", fontSize: 17, fontWeight: FontWeight.w600, hexaColor: AppColors.primaryColor,),
            ),
          )

        ],
      ),
    );
  }

  Widget _securityLayer(BuildContext context, StateSetter setStateWidget) {
    
    return Column(
      children: [
        ListTile(
          leading: Icon(Iconsax.finger_scan, color: hexaCodeToColor(AppColors.darkGrey), size: 22.5.sp),
          title: const MyText(text: "Unlock with Biometric", fontSize: 17, fontWeight: FontWeight.bold, textAlign: TextAlign.start,),
          minLeadingWidth: 0,
          horizontalTitleGap: 5,
          trailing: Switch(
            activeColor: hexaCodeToColor(AppColors.primaryColor),
            value: widget.model!.switchBio,
            onChanged: (value) async {
              
              await StorageServices.readSecure(DbKey.password)!.then((passwordValue) async {
                if(passwordValue.isNotEmpty) {
                  await widget.switchBio!(context, value);  
                  setStateWidget(() {
                    value;
                  });
                }
                else{
                  customDialog(context, "Opps", "Set up password to unlock with Biometric", txtButton: "OK");
                }
              });
              
            },
          ),
          onTap: null
        ),

      ],
    );
  }
}