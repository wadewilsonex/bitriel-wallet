abstract class AssetUseCases {

  /// Get path of the application
  Future<void> initPath();
  /// This Function Download Only Icon file (icons.zip)
  Future<void> downloadFirstAsset();
  /// fileName the file name to download on github
  /// 
  /// Files: token_logo.zip, logo.zip, nfts.zip, default.zip, payment.zip
  Future<void> downloadSecondAsset();
  /// fileName the file name to download on github
  /// 
  /// Such as: icons.zip, logo.zip, etc
  Future<void> downloadNArchive({String fileName});
}