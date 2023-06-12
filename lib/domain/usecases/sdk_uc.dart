import 'package:bitriel_wallet/data/sdk/bitriel_sdk.dart';
import 'package:bitriel_wallet/index.dart';
import 'package:flutter/services.dart';

class BitrielSDKProvider extends ChangeNotifier{
  
  final BitrielSDK _bitrielSDK = BitrielSDK();

  //  = 'assets/js/main.js'
  /// 2 
  void initBitrielSDK({required String jsFilePath, int nodeIndex = 0}) async {
    await rootBundle.loadString(jsFilePath).then((js) async {
      // 2.1. Init Keyring
      await _bitrielSDK.initBitrielSDK(jsCode: js);
    });
  }

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
  
}