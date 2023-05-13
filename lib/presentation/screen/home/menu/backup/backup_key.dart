// import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:wallet_apps/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/presentation/screen/home/menu/backup/body_backup_key.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';

class BackUpKey extends StatefulWidget{

  final KeyPairData? acc;

  const BackUpKey({Key? key, required this.acc}) : super(key: key);

  @override
  State<BackUpKey> createState() => _BackUpKeyState();
}

class _BackUpKeyState extends State<BackUpKey> {

  ApiProvider? _apiProvider;

  Future getMnemonic() async {
    await Component().dialogBox(context).then((value) async {
      if (value != ''){
        await _apiProvider!.getSdk.api.keyring.getDecryptedSeed(_apiProvider!.getKeyring, widget.acc!, value);
      }
    });

  }

  Future<void> getKeyStoreJson(String pass) async {
    // await _apiProvider!.getSdk.api.keyring.getDecryptedSeed(_apiProvider!.getKeyring, _apiProvider!.getKeyring.current, "1234");
    
  }

  // Future<void> disableScreenShot() async {
  //   try {
  //     await FlutterScreenshotSwitcher.disableScreenshots();
  //     // await FlutterScreenshotSwitcher.enableScreenshots().then((value) {
  //     //   debugPrint("Value $value");
  //     // });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       debugPrint("disableScreenShot $e");
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
      acc: widget.acc,
      getKeyStoreJson: getKeyStoreJson,
      getMnemonic: getMnemonic,
      // disableScreenShot: disableScreenShot
    );
  }
}