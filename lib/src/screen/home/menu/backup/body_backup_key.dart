import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/card_section_setting.m.dart';

class BackUpKeyBody extends StatelessWidget{

  final KeyPairData? acc;
  final Function? getKeyStoreJson;
  final Function? getMnemonic;
  // final Function? disableScreenShot;

  const BackUpKeyBody({
    Key? key, this.getKeyStoreJson, this.getMnemonic, /* this.disableScreenShot */ 
    required this.acc
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
     
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 30,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkCard : AppColors.whiteHexaColor).withOpacity(0),
        title: MyText(text: 'Export Wallet', fontSize: 20, hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor, fontWeight: FontWeight.bold,),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingSize),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(height: 2.5),

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
        itemCount: backupSection(context: context, acc: acc!).length,
        itemBuilder: (context, index) {
          
          return InkWell(
            onTap: () async {
              await backupSection(context: context, acc: acc!)[index].action!();
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
                              text: backupSection(context: context, acc: acc!)[index].title,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Icon(backupSection(context: context, acc: acc!)[index].trailingIcon, color: hexaCodeToColor(AppColors.primaryColor), size: 30,),

                  ],
                ),

                backupSection(context: context, acc: acc!).length - 1 == index ? Container() : Divider(thickness: 1, color: hexaCodeToColor(AppColors.greyColor).withOpacity(0.5),),
              
              ],
            ),
          );
        }
      ),
    );
  }
  
}