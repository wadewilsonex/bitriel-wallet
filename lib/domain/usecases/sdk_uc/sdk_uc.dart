import 'package:bitriel_wallet/index.dart';

abstract class BitrielSDKUseCase {
  
  /* Substrate */
  Future<void> initBitrielSDK({required String jsFilePath, int nodeIndex = 0});

  void dynamicNetwork() ;

  Future<bool> validateMnemonic(String seed);
  Future<List<dynamic>> importSeed(String seed, {KeyType keyType = KeyType.mnemonic, String? name = "Username", required String? pin});

  Future<SeedBackupData?> getPrivateKeyFromSeeds(KeyPairData keypair, String pin);

  Future<String> generateSeed();

  /* Web3 */
  Future<void> extractEvmAddress(String pk);

}