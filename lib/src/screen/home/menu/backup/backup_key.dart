// import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:wallet_apps/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/body_backup_key.dart';

class BackUpKey extends StatefulWidget{
  const BackUpKey({Key? key}) : super(key: key);


  @override
  State<BackUpKey> createState() => _BackUpKeyState();
}

class _BackUpKeyState extends State<BackUpKey> {

  // KeyringStorage? _keyringStorage = KeyringStorage();

  ApiProvider? _apiProvider;

  Future getMnemonic() async {
    await Component().dialogBox(context).then((value) async {
      if (value != ''){
        await KeyringPrivateStore([0, 42]).getDecryptedSeed(_apiProvider!.getKeyring.keyPairs[0].pubKey, value);
      }
    });

  }

  Future<void> getKeyStoreJson(String pass) async {
    await _apiProvider!.getSdk.api.keyring.getDecryptedSeed(_apiProvider!.getKeyring, "1234");
    
  }

  // Future<void> disableScreenShot() async {
  //   try {
  //     await FlutterScreenshotSwitcher.disableScreenshots();
  //     // await FlutterScreenshotSwitcher.enableScreenshots().then((value) {
  //     //   print("Value $value");
  //     // });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("disableScreenShot $e");
  //     }
  //   }
  // }

  @override
  void initState(){

    _apiProvider = Provider.of<ApiProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return BackUpKeyBody(
      getKeyStoreJson: getKeyStoreJson,
      getMnemonic: getMnemonic,
      // disableScreenShot: disableScreenShot
    );
  }
}