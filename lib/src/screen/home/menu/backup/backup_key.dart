import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:wallet_apps/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/screen/home/menu/backup/body_backup_key.dart';

class BackUpKey extends StatefulWidget{

  @override
  State<BackUpKey> createState() => _BackUpKeyState();
}

class _BackUpKeyState extends State<BackUpKey> {

  KeyringStorage? _keyringStorage = KeyringStorage();

  ApiProvider? _apiProvider;

  Future getMnemonic() async {
    final _api = await Provider.of<ApiProvider>(context, listen: false);
    await Component().dialogBox(context).then((value) async {
      if (value != ''){
        _apiProvider = await Provider.of<ApiProvider>(context, listen: false);
        await KeyringPrivateStore([0, 42]).getDecryptedSeed(_api.getKeyring.keyPairs[0].pubKey, value);
      }
    });

  }

  Future<void> getKeyStoreJson(String pass) async {

    final _api = await Provider.of<ApiProvider>(context, listen: false);
    // await FlutterAesEcbPkcs5.decryptString(mnemonic, key);
    await _api.apiKeyring.getDecryptedSeed(_api.getKeyring, "1234");
    
    // print("getBackupKey");
    // Navigator.pop(context);
    // print(_api.getKeyring.current.pubKey);
    // print(pass);
    // try {
    //   // final pairs = await KeyringPrivateStore([0, 42])// (_api.getKeyring.keyPairs[0].pubKey, pass);
    //   print("_api.getKeyring.keyPairs[0].pubKey ${_api.getKeyring.keyPairs[0].pubKey}");
    //   final pairs = await KeyringPrivateStore([_api.isMainnet ? AppConfig.networkList[0].ss58MN! : AppConfig.networkList[0].ss58!]).getDecryptedSeed(_api.getKeyring.keyPairs[0].pubKey, pass);
    //   print("${pairs}");
    //   if (pairs!['seed'] != null) {
    //     await customDialog(context, 'Backup Key', pairs['seed'].toString());
    //   } else {
    //     await customDialog(context, 'Backup Key', 'Incorrect Pin');
    //   }
    // } catch (e) {
    //   //await dialog(context, e.toString(), 'Opps');
    //   print("Error getBackupKey $e");
    // }
  }

  Future<void> disableScreenShot() async {
    try {
      await FlutterScreenshotSwitcher.disableScreenshots();
      // await FlutterScreenshotSwitcher.enableScreenshots().then((value) {
      //   print("Value $value");
      // });
    } catch (e) {}
  }

  @override
  void initState(){
    super.initState();
  }

  Widget build(BuildContext context){
    return BackUpKeyBody(
      getKeyStoreJson: getKeyStoreJson,
      getMnemonic: getMnemonic,
      disableScreenShot: disableScreenShot
    );
  }
}