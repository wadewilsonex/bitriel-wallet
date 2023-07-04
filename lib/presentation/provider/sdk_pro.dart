import 'package:bitriel_wallet/index.dart';

class SDKProvier with ChangeNotifier {

  final BitrielSDKImpl _sdkProvier = BitrielSDKImpl();

  BitrielSDKImpl get getSdkProvider => _sdkProvier;

  void connectNetwork(){
    _sdkProvier.initBitrielSDK(jsFilePath: "assets/js/main.js");
  }
  
  Future<void> importSeed(String seed, String pwd) async {
    await _sdkProvier.importSeed(seed, pwd: pwd);
  }
}