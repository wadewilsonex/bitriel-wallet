import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/acc_c.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/presentation/home/menu/backup/keystore_json.dart';

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
        title: MyText(text: 'Export Account', fontSize: 2.4, hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor, fontWeight: FontWeight.bold,),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingSize),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(height: 2.5.h),

            ListTileComponent(
              text: "Keystore (json)",
              action: () async {
                // await getKeyStoreJson!();
                ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
                Map<String, dynamic> jsons = {
                  "address": Provider.of<ContractProvider>(context, listen: false).listContract[apiProvider.selNativeIndex].address,
                  "encoded": apiProvider.getKeyring.current.encoded,
                  "encoding": apiProvider.getKeyring.current.encoding,
                  "pubKey": apiProvider.getKeyring.current.pubKey,
                  "meta": apiProvider.getKeyring.current.meta,
                  "memo": apiProvider.getKeyring.current.memo,
                  "observation": apiProvider.getKeyring.current.observation,
                  "indexInfo": apiProvider.getKeyring.current.indexInfo
                };

                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => KeyStoreJson(keystore: jsons,))
                );
              },
            ),

            SizedBox(height: 2.5.h),
            
            ListTileComponent(
              text: "Mnemonic",
              action: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const Passcode(label: PassCodeLabel.fromBackUp))).then((value) async {
                  // await disableScreenShot!();
                  ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
                  await apiProvider.apiKeyring.getDecryptedSeed(apiProvider.getKeyring, value).then((res) async {
                    if (res!.seed != null){
                      await DialogComponents().seedDialog(context: context, contents: res.seed.toString());
                    } else {
                      await DialogComponents().dialogCustom(context: context, titles: "Oops", contents: "Invalid PIN");
                    }
                  });
                });
                
              },
            )
          ]
        ),
      )
    );
  }
}