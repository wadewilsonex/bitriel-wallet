import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/data/backend/get_request.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';

class AppProvider with ChangeNotifier {

  static BuildContext? buildContext;

  bool? isIconsReady = false;

  ValueNotifier<String>? dirPath = ValueNotifier<String>('');

  File? file;
  
  // ValueNotifier<List<File>>? onBoardingImg = ValueNotifier<List<File>>([
  //   File(''),
  //   File(''),
  //   File(''),
  //   File(''),
  //   File(''),
  //   File(''),
  // ]);

  set setContext(BuildContext ct) {
    buildContext = ct;

    // notifyListeners();
  }
  
  Future<void> downloadFirstAsset() async {

    await Permission.storage.request().then((pm) async {

      if(dirPath!.value.isEmpty){
        dirPath!.value = (await getApplicationDocumentsDirectory()).path;
      }

      // ignore: use_build_context_synchronously
      AppConfig.initIconPath(buildContext!);

      await downloadAsset(fileName: 'icons.zip');

      isIconsReady = true;

      // onBoardingImg!.value = [
      //   File("${dirPath!.value}/icons/setup-1.png"),
      //   File("${dirPath!.value}/icons/setup-2.png"),
      //   File("${dirPath!.value}/icons/setup-3.png"),
      //   File("${dirPath!.value}/icons/google-vector.svg"),
      //   File("${dirPath!.value}/icons/setup-4.png"),
      //   File("${dirPath!.value}/icons/json-file.svg"),
      // ];

      // await downloadAsset(fileName: 'logo.zip');

    });
  }

  Future<void> downloadSecondAsset() async {

    await downloadAsset(fileName: 'token_logo.zip');

    await downloadAsset(fileName: 'nfts.zip');

    await downloadAsset(fileName: 'default.zip');

    await downloadAsset(fileName: 'payment.zip');
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
    // Provider.of<AppProvider>(buildContext!, listen: false).notifyListeners();
  }  

  Future<void> downloadAsset({required String fileName}) async {

    // ignore: unrelated_type_equality_checks
    if ( await Directory("${dirPath!.value}/${fileName.replaceAll(".zip", "")}").exists() == false ){

      await downloadAssets(fileName).then((value) async {

        await getApplicationDocumentsDirectory().then((dir) async {

          await AppUtils.archiveFile(await File("${dir.path}/$fileName").writeAsBytes(value.bodyBytes)).then((files) async {
            
          });
        });
        
      });
      
    }
  }

  Future<void> deleteAllFile() async {

    isIconsReady = false;
    
    notifyListeners();

    Directory("${dirPath!.value}/icons").deleteSync(recursive: true);
    Directory("${dirPath!.value}/logo").deleteSync(recursive: true);
    Directory("${dirPath!.value}/token_logo").deleteSync(recursive: true);
    Directory("${dirPath!.value}/nfts").deleteSync(recursive: true);
    Directory("${dirPath!.value}/default").deleteSync(recursive: true);
    Directory("${dirPath!.value}/payment").deleteSync(recursive: true);
  }
  
}