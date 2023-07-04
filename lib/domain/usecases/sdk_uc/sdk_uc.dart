import 'package:bitriel_wallet/index.dart';

abstract class BitrielSDKUseCase {
  void initBitrielSDK({required String jsFilePath, int nodeIndex = 0});

  void dynamicNetwork() ;

  Future<bool> validateMnemonic(String seed);

  Future<void> importSeed(String seed, {KeyType keyType = KeyType.mnemonic, String? name = "Username", required String? pwd});
}