import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';

class AssetUseCaseImpl implements AssetUseCases {

  final AppRepoImpl _appRepoImpl = AppRepoImpl();

  String? dirPath;

  @override
  Future<void> initPath() async {
    await Permission.storage.request().then((pm) async {
      dirPath = (await getApplicationDocumentsDirectory()).path;
    });
  }

  @override
  Future<void> downloadFirstAsset() async {
    try {
      await downloadNArchive(fileName: 'icons.zip');
      logger.d("downloadNArchive");
    } catch (e) {
      logger.d("Error downloadFirstAsset $e");
    }
  }

  @override
  Future<void> downloadSecondAsset() async {

    await downloadNArchive(fileName: 'token_logo.zip');

    await downloadNArchive(fileName: 'nfts.zip');

    await downloadNArchive(fileName: 'default.zip');

    await downloadNArchive(fileName: 'payment.zip');
  }

  @override
  Future<void> downloadNArchive({String? fileName}) async {
    logger.d("downloadNArchive");
    await _appRepoImpl.downloadAsset(fileName: fileName).then((value) async {
      logger.d("value $value");
      // await downloadAsset();
      await AppUtils.archiveFile(await File("$dirPath/$fileName").writeAsBytes(value.bodyBytes));
    });
  }

  Future<bool> checkAlreadyInLocalStorage() async {
    return await Directory("${dirPath!}/${"icons.zip".replaceAll(".zip", "")}").exists();
  }

  Future<void> deleteAllFile() async {

    // isIconsReady = false;
    
    // notifyListeners();

    // Directory("${dirPath!.value}/icons").deleteSync(recursive: true);
    // Directory("${dirPath!.value}/logo").deleteSync(recursive: true);
    // Directory("${dirPath!.value}/token_logo").deleteSync(recursive: true);
    // Directory("${dirPath!.value}/nfts").deleteSync(recursive: true);
    // Directory("${dirPath!.value}/default").deleteSync(recursive: true);
    // Directory("${dirPath!.value}/payment").deleteSync(recursive: true);
  }
}