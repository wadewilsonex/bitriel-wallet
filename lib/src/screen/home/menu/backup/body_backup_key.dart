import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/acc_c.dart';

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
        centerTitle: true,
        title: MyText(text: 'Export Account', color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor),
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
              },
            ),

            ListTileComponent(
              text: "Mnemonic",
              action: () async {
                await Component().dialogBox(context).then((value) async {
                  if (value != ''){
                    // await disableScreenShot!();
                    ApiProvider _apiProvider = await Provider.of<ApiProvider>(context, listen: false);
                    await _apiProvider.getDecryptedSeed(_apiProvider.getKeyring.current.pubKey, value).then((value) async {
                      print("Mnemonic $value");
                      await showDialog(
                        context: context, 
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: MyText(
                              text: "Mnemonic",
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme == false ? AppColors.darkCard : AppColors.whiteHexaColor,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyText(
                                  textAlign: TextAlign.left,
                                  text: AppString.screenshotNote,
                                  color: isDarkTheme == false ? AppColors.darkCard : AppColors.whiteHexaColor,
                                  bottom: paddingSize,
                                ),

                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: hexaCodeToColor(AppColors.darkSecondaryText).withOpacity(0.3),
                                      width: 1
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: isDarkTheme 
                                    ? hexaCodeToColor(AppColors.darkCard)
                                    : hexaCodeToColor(AppColors.whiteHexaColor),
                                  child: MyText(
                                    text: value!['seed'],
                                    textAlign: TextAlign.left,
                                    fontSize: 25,
                                    color: AppColors.secondarytext,
                                    fontWeight: FontWeight.bold,
                                    pLeft: 16,
                                    right: 16,
                                    top: 16,
                                    bottom: 16,
                                  ),
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  // await FlutterScreenshotSwitcher.enableScreenshots();
                                  Navigator.pop(context);
                                },
                                child: MyText(text: 'Close'),
                              )
                            ],
                          );
                      });
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