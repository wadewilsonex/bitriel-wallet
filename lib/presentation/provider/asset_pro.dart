import 'package:bitriel_wallet/index.dart';

class AssetProvider with ChangeNotifier{

  final AssetUseCaseImpl? assetUCImlp = AssetUseCaseImpl();

  String get dirPath => assetUCImlp!.dirPath!;

  bool isDownloadedAsset = false;

  Future<void> downloadFirstAsset() async {
    
    await assetUCImlp!.initPath();

    if (await assetUCImlp!.checkAlreadyInLocalStorage() == false){
      // Add your logic here if needed
      await assetUCImlp!.downloadFirstAsset();
    }

    isDownloadedAsset = true;
    // Notify listeners if needed
    notifyListeners();
  }
}