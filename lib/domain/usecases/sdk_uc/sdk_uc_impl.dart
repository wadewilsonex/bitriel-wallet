import 'package:bitriel_wallet/index.dart';

class BitrielSDKImpl implements BitrielSDKUseCase{
  
  final SdkRepoImpl _bitrielSDKImpl = SdkRepoImpl();

  //  = 'assets/js/main.js'
  /// 2 
  @override
  void initBitrielSDK({required String jsFilePath, int nodeIndex = 0}) async {
    await rootBundle.loadString(jsFilePath).then((js) async {
      // 2.1. Init Keyring
      await _bitrielSDKImpl.initBitrielSDK(jsCode: js);
    });
  }

  @override
  void dynamicNetwork() async {
    // Asign Network
    // await StorageServices.fetchData(DbKey.sldNetwork).then((nw) async {
    //   /// Get Endpoint form Local DB
    //   /// 
    //   if (nw != null){

    //     selNetwork = nw;
    //   } else {
    //     selNetwork = isMainnet ? AppConfig.networkList[0].wsUrlMN : AppConfig.networkList[0].wsUrlTN;

    //   }

    //   await StorageServices.storeData(selNetwork, DbKey.sldNetwork);
      
    // });
  }

  @override
  Future<bool> validateMnemonic(String seed) async { 
    return await _bitrielSDKImpl.getWalletSdk.api.keyring.checkMnemonicValid(seed);
  }

  @override
  Future<void> importSeed(String seed, {KeyType keyType = KeyType.mnemonic, String? name = "Username", required String? pwd}) async {

    await _bitrielSDKImpl.getWalletSdk.api.keyring.importAccount(
      _bitrielSDKImpl.getKeyring, 
      keyType: keyType, 
      key: seed, 
      name: name!, 
      password: pwd!
    );
  }
  
  @override
  Future<String> generateSeed() async {
    return ( await _bitrielSDKImpl.getWalletSdk.api.keyring.generateMnemonic(_bitrielSDKImpl.getKeyring.ss58!) ).mnemonic!;
  }
  
}