abstract class AddAssetUsecase {

  Future<void> validateWeb3Address();
  Future<bool> validateSubstrateAddress(String addr);
  Future<void> addAsset();
  
}