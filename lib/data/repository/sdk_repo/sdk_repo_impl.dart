import 'package:bitriel_wallet/data/repository/sdk_repo/sdk_repo.dart';
import 'package:bitriel_wallet/index.dart';

class SdkRepoImpl implements SDKRepository {

  final BitrielSDK _bitrielSDK = BitrielSDK();

  Keyring get getKeyring => _bitrielSDK.keyring;
  WalletSDK get getWalletSdk => _bitrielSDK.walletSDK;

  List<NetworkParams> nodes = [];

  final NetworkParams _params = NetworkParams();

  SdkRepoImpl(){
    print("Start init param SdkRepoImpl");
    initParam();
  }

  /// 1.
  /// 
  /// Init Selendra Chain Parameter
  @override
  void initParam(){
    nodes.clear();
    _params.endpoint = 'wss://rpc0.selendra.org';
    _params.ss58 = 204;
    nodes.add(_params);
  }

  /// 2.
  @override
  Future<void> initBitrielSDK({required String jsCode, int nodeIndex = 0}) async {
    await _bitrielSDK.initBitrielSDK(jsCode: jsCode, nodes: nodes);
    await connectNode(jsCode: jsCode);
  }

  /// 3.
  @override
  Future<void> connectNode({required String jsCode}) async {
    await _bitrielSDK.connectNode(jsCode: jsCode, nodes: nodes);
  }
}