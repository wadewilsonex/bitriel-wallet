import 'dart:async';

import 'package:bitriel_wallet/index.dart';

class SDKProvier with ChangeNotifier {

  final BitrielSDKImpl _sdkImpl = BitrielSDKImpl();

  BitrielSDKImpl get getSdkImpl => _sdkImpl;
  
  bool isConnected = false;

  bool switchConnection = false;
  bool connectFailed = false;

  final AccountManagementImpl _accountManagementImpl = AccountManagementImpl();

  List<UnverifySeed> get getUnverifyAcc => _accountManagementImpl.unVerifyAccount;

  set setEvmAddress(String value){
    _sdkImpl.evmAddress = value;
    notifyListeners();
  }

  set setBtcAddress(String value){
    _sdkImpl.btcAddress = value;
    notifyListeners();
  }

  List<String> get getLstSelNetwork => _sdkImpl.lstSelendraNetwork;

  // Future<void> fetchNetworkFromGithub() async {

  //   notifyListeners();
  // }

  /// 1.
  void connectNetwork() async {

    await _sdkImpl.fetchNetwork();

    // 1.1. Set Paramter Network

    // 1.2. Connect Network after setup param.
    await _sdkImpl.initBitrielSDK(jsFilePath: "assets/js/main.js");

    isConnected = true;

    notifyListeners();
    
  }

  void setNetworkParamState(int nwIndex) async {

    switchConnection = true;

    _sdkImpl.setNetworkParam(_sdkImpl.lstSelendraNetwork[nwIndex], nwIndex);

    if (_sdkImpl.connectedIndex != 0){

      Timer timer = AppUtils.timer( () async { await _sdkImpl.sdkRepoImpl.connectNode(jsCode: _sdkImpl.jsFile!); });
      print("connnected ${timer.tick}");
      // if (timer)
      // connectedIndex = nwIndex;
      
      // await _storageImpl.writeSecure(DbKey.connectedIndex, json.encode(nwIndex));
    }
  }

  void conectionTerminator(bool connectSuccess){
    print("conectionTerminator $connectSuccess");
    switchConnection = false;
    connectFailed = connectSuccess;

    notifyListeners();
  }
  
  Future<List<dynamic>> importSeed(String seed, String pwd) async {
    return await _sdkImpl.importSeed(seed, pin: pwd);
  }
  
  /// Fetch accounts (Import & Create New) from Local Storage
  /// To Identify status verify at Wallet screen.
  /// And Setup Evm and BTC Address 
  Future<void> fetchAllAccount() async {
    await _accountManagementImpl.fetchAccount();

    setEvmAddress = getUnverifyAcc[0].ethAddress!;
    setBtcAddress = getUnverifyAcc[0].btcAddress!;
  }
}