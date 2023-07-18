import 'dart:async';

import 'package:bitriel_wallet/index.dart';

class SDKProvier with ChangeNotifier {

  final BitrielSDKImpl _sdkImpl = BitrielSDKImpl();

  BitrielSDKImpl get getSdkImpl => _sdkImpl;
  
  bool isConnected = false;

  bool connectFailed = false;

  final AccountManagementImpl _accountManagementImpl = AccountManagementImpl();

  List<UnverifySeed> get getUnverifyAcc => _accountManagementImpl.unVerifyAccount;

  set setBuildContext(BuildContext ctx) => _sdkImpl.setBuildContext = ctx;

  set setEvmAddress(String value){
    _sdkImpl.evmAddress = value;
    notifyListeners();
  }

  set setBtcAddress(String value){
    _sdkImpl.btcAddress = value;
    notifyListeners();
  }

  List<String> get getLstSelNetwork => _sdkImpl.lstSelendraNetwork;

  /// 1.
  void connectNetwork() async {

    await _sdkImpl.fetchNetwork();

    // 1.1. Set Paramter Network

    // 1.2. Connect Network after setup param.
    await _sdkImpl.initBitrielSDK(jsFilePath: "assets/js/main.js");

    isConnected = true;

    notifyListeners();
    
  }

  /// Change Network
  Future<void> setNetworkParamState(String network, int nwIndex, Function modalBottomSetState) async {

    if (_sdkImpl.connectedIndex != nwIndex){

      dialogLoading(_sdkImpl.context!);

      isConnected = false;

      await _sdkImpl.setNetworkParam(network, nwIndex, connectionTerminator: connectionTerminator, modalBottomSetState: modalBottomSetState);
    }
  }

  /// Terminator Function If Can't connection Network in 13seconds.
  /// 
  /// connectionTerminator not inside sdk_uc because we need to use notifyListeners of Sdk Provider.
  /// 
  void connectionTerminator(bool isSuccess, Function changeModalBottomState) async {

    // Close Dialog Loading
    // ignore: use_build_context_synchronously
    Navigator.pop(_sdkImpl.context!);
    // Close modalBottomDialog
    Navigator.pop(_sdkImpl.context!);
    
    if (isSuccess == true) {
      changeModalBottomState(() {});

      _sdkImpl.connectedIndex = _sdkImpl.connectedIndex == 0 ? 1 : 0;

      isConnected = true;

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(_sdkImpl.context!).showSnackBar(
        const SnackBar(content: Text("Connection Success"))
      );
        
      // Store Index of new Network connect successful.
      await SecureStorage.writeData(key: DbKey.connectedIndex, encodeValue: json.encode(_sdkImpl.connectedIndex));
    }

    // Connection Failed
    else {

      // In this connect failed:
      // Reset Set Param To previous Network sdk_uc_impl.dart file line 83
      _sdkImpl.setNetworkParam(_sdkImpl.lstSelendraNetwork[_sdkImpl.connectedIndex], _sdkImpl.connectedIndex);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(_sdkImpl.context!).showSnackBar(
        const SnackBar(content: Text("Connect RP1 failed"))
      );
    }

    connectFailed = isSuccess;
    
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