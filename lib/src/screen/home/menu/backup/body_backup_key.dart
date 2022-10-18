import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/acc_c.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/keystoreJson.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

class BackUpKeyBody extends StatelessWidget{

  final Function? getKeyStoreJson;
  final Function? getMnemonic;
  final Function? disableScreenShot;

  BackUpKeyBody({this.getKeyStoreJson, this.getMnemonic, this.disableScreenShot});

  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          /* Menu Icon */

          padding: const EdgeInsets.only(left: 16, right: 8),
          iconSize: 40.0,
          icon: Icon(
            Platform.isAndroid ? LineAwesomeIcons.arrow_left : LineAwesomeIcons.angle_left,
            color: isDarkTheme ? Colors.white : Colors.black,
            size: 36,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: hexaCodeToColor(isDarkTheme ? AppColors.darkCard : AppColors.whiteHexaColor),
        title: MyText(text: 'Export Account', color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor, fontWeight: FontWeight.bold,),
      ),
      body: Card(
        margin: EdgeInsets.all(paddingSize),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ListTileComponent(
              text: "Keystore (json)",
              action: () async {
                // await getKeyStoreJson!();
                ApiProvider _apiProvider = await Provider.of<ApiProvider>(context, listen: false);
                Map<String, dynamic> jsons = {
                  "address": Provider.of<ContractProvider>(context, listen: false).listContract[_apiProvider.selNativeIndex].address,
                  "encoded": _apiProvider.getKeyring.current.encoded,
                  "encoding": _apiProvider.getKeyring.current.encoding,
                  "pubKey": _apiProvider.getKeyring.current.pubKey,
                  "meta": _apiProvider.getKeyring.current.meta,
                  "memo": _apiProvider.getKeyring.current.memo,
                  "observation": _apiProvider.getKeyring.current.observation,
                  "indexInfo": _apiProvider.getKeyring.current.indexInfo
                };

                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => KeyStoreJson(keystore: jsons,))
                );
              },
            ),

            ListTileComponent(
              text: "Mnemonic",
              action: () async {
                await Component().dialogBox(context).then((value) async {
                  if (value != ''){
                    // await disableScreenShot!();
                    ApiProvider _apiProvider = await Provider.of<ApiProvider>(context, listen: false);
                    await _apiProvider.apiKeyring.getDecryptedSeed(_apiProvider.getKeyring, value).then((res) async {
                      if (res!.seed != null){
                        await DialogComponents().seedDialog(context: context, contents: res.seed.toString(), isDarkTheme: isDarkTheme);
                      } else {
                        await DialogComponents().dialogCustom(context: context, titles: "Oops", contents: "Invalid PIN", isDarkTheme: isDarkTheme);
                      }
                    });
                  }
                }); 
              },
            )
          ]
        ),
      )
    );
  }
}