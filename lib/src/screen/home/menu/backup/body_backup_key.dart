import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/acc_c.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/models/card_section_setting.m.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/keystore_json.dart';

class BackUpKeyBody extends StatelessWidget{

  final Function? getKeyStoreJson;
  final Function? getMnemonic;
  // final Function? disableScreenShot;

  const BackUpKeyBody({Key? key, this.getKeyStoreJson, this.getMnemonic, /* this.disableScreenShot */ }) : super(key: key);

  @override
  Widget build(BuildContext context){
     
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 22.5.sp,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkCard : AppColors.whiteHexaColor).withOpacity(0),
        title: MyText(text: 'Export Account', fontSize: 18, hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor, fontWeight: FontWeight.bold,),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingSize),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(height: 2.5.h),

            _backupSection(context),
          ]
        ),
      )
    );
  }

  Widget _backupSection(BuildContext context,) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 48.0,
            offset: const Offset(0.0, 2)
          )
        ],
        color: hexaCodeToColor(isDarkMode ? AppColors.defiMenuItem : AppColors.whiteColorHexa),
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: backupSection(context: context).length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              backupSection(context: context)[index].action!();
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: paddingSize / 2),
                            child: MyText(
                              text: backupSection(context: context)[index].title,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Icon(backupSection(context: context)[index].trailingIcon, color: hexaCodeToColor(AppColors.primaryColor), size: 17,),

                  ],
                ),

                backupSection(context: context).length - 1 == index ? Container() : Divider(thickness: 1, color: hexaCodeToColor(AppColors.greyColor).withOpacity(0.5),),
              ],
            ),
          );
        }
      ),
    );
  }
  
}