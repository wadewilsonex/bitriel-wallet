import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/security_privacy/password/password.dart';

class SecurityPrivacy extends StatelessWidget {
  final MenuModel? model;
  final Function? switchBio;
  const SecurityPrivacy({Key? key, this.model, this.switchBio}) : super(key: key);
  
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

  Widget _backupSeed(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyText(text: "Reveal Secret Recovery Phrase", fontSize: 18, fontWeight: FontWeight.bold,),

          const MyText(
            text: "Protect your wallet by saving your secret recovery phrase in the saving & various place like on a piece or paper, password manager, and/or the cloud", 
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

                // Navigator.push(
                //   context, 
                //   Transition(
                //     child: BackUpKey(),
                //     transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                //   )
                // );
              },
              child: const MyText(text: "Reveal Secret Recovery Phrase", fontSize: 17, fontWeight: FontWeight.w600, hexaColor: AppColors.primaryColor,),
            ),
          )

        ],
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
                    child: const PasswordSecurity(),
                    transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                  )
                );
              },
              child: const MyText(text: "Setup Password", fontSize: 17, fontWeight: FontWeight.w600, hexaColor: AppColors.primaryColor,),
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
            value: model!.switchBio,
            onChanged: (value) async {
              await StorageServices.readSecure(DbKey.password)!.then((passwordValue) async {
                print("value $passwordValue");
                if(passwordValue.isNotEmpty) {
                  await switchBio!(context, value);  
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

        // ListTile(
        //   leading: SvgPicture.asset("assets/icons/face-id.svg", height: 22.5.sp, width: 22.5.sp,),
        //   title: const MyText(text: "Unlock with Face ID", fontSize: 17, fontWeight: FontWeight.bold, textAlign: TextAlign.start,),
        //   minLeadingWidth: 0,
        //   horizontalTitleGap: 5,
        //   trailing: Switch(
        //     activeColor: hexaCodeToColor(AppColors.primaryColor),
        //     // value: model!.switchBio,
        //     value: true,
        //     onChanged: (value) {
        //       // switchBio!(context, value);
        //     },
        //   ),
        //   onTap: null,
        // ),

      ],
    );
  }

}