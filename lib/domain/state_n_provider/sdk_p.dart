import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
// ignore: depend_on_referenced_packages
import 'package:polkawallet_sdk/storage/keyring.dart';
// ignore: depend_on_referenced_packages
import 'package:polkawallet_sdk/api/types/networkParams.dart';

class BitrielSDKProvider extends ChangeNotifier{

  /// 1 Delcare SDK & Keyring
  /// SDK for launch hidden webview to run polkadot/js for interacting with substrate
  final WalletSDK _walletSDK = WalletSDK();
  /// Keyring for instance the local storage of key-pair for users.
  /// And Pass Keyring to SDK's Keyring for account management.
  final Keyring _keyring = Keyring();

  List<NetworkParams> nodes = [];

//  = 'assets/js/main.js'
  /// 2 
  void initBitrielSDK({required String jsFilePath, int nodeIndex = 0}) async {
    await rootBundle.loadString(jsFilePath).then((js) async {
      // 2.1. Init Keyring
      await _keyring.init([nodes[nodeIndex].ss58!]);
      await _walletSDK.init(_keyring, jsCode: js);
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