import 'package:bitriel_wallet/index.dart';

class BitrielSDK {

  /// 1 Delcare SDK & Keyring
  /// SDK for launch hidden webview to run polkadot/js for interacting with substrate
  final WalletSDK _walletSDK = WalletSDK();
  /// Keyring for instance the local storage of key-pair for users.
  /// And Pass Keyring to SDK's Keyring for account management.
  final Keyring _keyring = Keyring();

  Keyring get getKeyring => _keyring;
  WalletSDK get getWalletSdk => _walletSDK;

  List<NetworkParams> nodes = [];

  Future<void> initBitrielSDK({required String jsCode, int nodeIndex = 0}) async {
    // 2.1. Init Keyring
    await _keyring.init([nodes[nodeIndex].ss58!]);
    await _walletSDK.init(_keyring, jsCode: jsCode);
  }
  
}