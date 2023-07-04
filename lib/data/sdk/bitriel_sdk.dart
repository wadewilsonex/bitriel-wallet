import 'package:bitriel_wallet/index.dart';

class BitrielSDK {

  /// 1 Delcare SDK & Keyring
  /// SDK for launch hidden webview to run polkadot/js for interacting with substrate
  final WalletSDK walletSDK = WalletSDK();
  /// Keyring for instance the local storage of key-pair for users.
  /// And Pass Keyring to SDK's Keyring for account management.
  final Keyring keyring = Keyring();

  // List<NetworkParams>  = [];

  Future<void> initBitrielSDK({required String jsCode, int nodeIndex = 0, required List<NetworkParams>? nodes}) async {
    // 2.1. Init Keyring
    await keyring.init([nodes![nodeIndex].ss58!]);
    await walletSDK.init(keyring, jsCode: jsCode);
  }

  Future<NetworkParams?> connectNode({required String jsCode, required List<NetworkParams>? nodes}) async {
    // 2.1. Init Keyring
    return await walletSDK.api.connectNode(keyring, nodes!);
  }
  
}