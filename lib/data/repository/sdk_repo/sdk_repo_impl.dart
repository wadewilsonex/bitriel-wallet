import 'package:bitriel_wallet/data/repository/sdk_repo/sdk_repo.dart';
import 'package:bitriel_wallet/index.dart';

class SdkRepoImpl implements SDKRepository {

  final BitrielSDK _bitrielSDK = BitrielSDK();

  Keyring get getKeyring => _bitrielSDK.keyring;
  WalletSDK get getWalletSdk => _bitrielSDK.walletSDK;

  List<NetworkParams> nodes = [];

  final NetworkParams _params = NetworkParams();

  /// 1.
  /// 
  /// Init Selendra Chain Parameter
  @override
  void setNetworkParam({String? network, int ss58 = 204}){
    nodes.clear();
    _params.endpoint = network;
    _params.ss58 = ss58;
    nodes.add(_params);

    print("_params.endpoint ${_params.endpoint}");
  }

  /// 2.
  @override
  Future<void> initBitrielSDK({required String jsCode}) async {
    await _bitrielSDK.initBitrielSDK(jsCode: jsCode, nodes: nodes);
    await connectNode(jsCode: jsCode);
  }

  /// 3.
  @override
  Future<void> connectNode({required String jsCode}) async {
    await _bitrielSDK.connectNode(jsCode: jsCode, nodes: nodes);
  }

  Future<String> querySELAddress(String address) async {
    
    // Get SEL native Address From Account 
    return await _bitrielSDK.walletSDK.webView!.evalJavascript("account.getBalance(api, '$address', 'Balance')").then((value) {
      return Fmt.balance(
        value['freeBalance'].toString(),
        18,
      );

    });
  }
  

  Future<void> disconnectNode() async {
    await _bitrielSDK.walletSDK.webView!.evalJavascript("settings.disconnect()");
  }

  @override
  /// Web3 
  /// 
  Future<bool> validateWeb3Address(String addr) async {

    return await _bitrielSDK.walletSDK.webView!.evalJavascript('wallets.validateEtherAddr("$addr")');
  }
  
}