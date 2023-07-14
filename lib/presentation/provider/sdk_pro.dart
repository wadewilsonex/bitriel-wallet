import 'package:bitriel_wallet/index.dart';

class SDKProvier with ChangeNotifier {

  final BitrielSDKImpl _sdkProvier = BitrielSDKImpl();

  BitrielSDKImpl get getSdkProvider => _sdkProvier;
  
  bool isConnected = false;

  set setEvmAddress(String value){
    _sdkProvier.evmAddress = value;
    notifyListeners();
  }

  void connectNetwork() async {

    await _sdkProvier.initBitrielSDK(jsFilePath: "assets/js/main.js");
    isConnected = true;
    notifyListeners();
    
  }
  
  Future<List<dynamic>> importSeed(String seed, String pwd) async {
    
    return await _sdkProvier.importSeed(seed, pin: pwd);
  }
  
}