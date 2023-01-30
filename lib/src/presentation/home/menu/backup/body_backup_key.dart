import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/acc_c.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/models/card_section_setting.m.dart';

class BackUpKeyBody extends StatelessWidget{

  final Function? getKeyStoreJson;
  final Function? getMnemonic;
  // final Function? disableScreenShot;

  const BackUpKeyBody({Key? key, this.getKeyStoreJson, this.getMnemonic, /* this.disableScreenShot */ }) : super(key: key);

  @override
  Widget build(BuildContext context){
     
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      appBar: secondaryAppBar(
        context: context, 
        title: MyText(text: 'Export Account', fontSize: 2.4, hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor, fontWeight: FontWeight.bold,)
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingSize),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(height: 2.5.sp),

            _backupSection(context),

            // ListTileComponent(
            //   text: "Keystore (json)",
            //   action: () async {
            //     // await getKeyStoreJson!();
            //     ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
            //     Map<String, dynamic> jsons = {
            //       "address": Provider.of<ContractProvider>(context, listen: false).listContract[apiProvider.selNativeIndex].address,
            //       "encoded": apiProvider.getKeyring.current.encoded,
            //       "encoding": apiProvider.getKeyring.current.encoding,
            //       "pubKey": apiProvider.getKeyring.current.pubKey,
            //       "meta": apiProvider.getKeyring.current.meta,
            //       "memo": apiProvider.getKeyring.current.memo,
            //       "observation": apiProvider.getKeyring.current.observation,
            //       "indexInfo": apiProvider.getKeyring.current.indexInfo
            //     };

            //     Navigator.push(
            //       context, 
            //       MaterialPageRoute(builder: (context) => KeyStoreJson(keystore: jsons,))
            //     );
            //   },
            // ),

            // SizedBox(height: 2.5.h),
            
            // ListTileComponent(
            //   text: "Mnemonic",
            //   action: () async {
            //     await Navigator.push(context, MaterialPageRoute(builder: (context) => const Passcode(label: PassCodeLabel.fromBackUp))).then((value) async {
            //       // await disableScreenShot!();
            //       ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
            //       await apiProvider.apiKeyring.getDecryptedSeed(apiProvider.getKeyring, value).then((res) async {
            //         if (res!.seed != null){
            //           await DialogComponents().seedDialog(context: context, contents: res.seed.toString());
            //         } else {
            //           await DialogComponents().dialogCustom(context: context, titles: "Oops", contents: "Invalid PIN");
            //         }
            //       });
            //     });
                
            //   },
            // )
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