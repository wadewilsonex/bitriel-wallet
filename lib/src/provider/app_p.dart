import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';

class AppProvider with ChangeNotifier {

  static BuildContext? buildContext;

  String? dirPath;

  set setContext(BuildContext ct) {
    buildContext = ct;

    // notifyListeners();
  }
  
  void downloadAndSaveAsset() async {

    await Permission.storage.request().then((pm) async {
      print("allAssets");
      Provider.of<AppProvider>(buildContext!, listen: false).dirPath ??= (await getApplicationDocumentsDirectory()).path;
      // ignore: use_build_context_synchronously
      AppConfig.initIconPath(buildContext!);

      await downloadAsset(fileName: 'icons.zip');
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
      Provider.of<AppProvider>(buildContext!, listen: false).notifyListeners();

      await downloadAsset(fileName: 'logo.zip');

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
      Provider.of<AppProvider>(buildContext!, listen: false).notifyListeners();

      await downloadAsset(fileName: 'token_logo.zip');
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
      Provider.of<AppProvider>(buildContext!, listen: false).notifyListeners();

      await downloadAsset(fileName: 'nfts.zip');
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
      Provider.of<AppProvider>(buildContext!, listen: false).notifyListeners();

      await downloadAsset(fileName: 'default.zip');
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
      Provider.of<AppProvider>(buildContext!, listen: false).notifyListeners();

      await downloadAsset(fileName: 'payment.zip');
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
      Provider.of<AppProvider>(buildContext!, listen: false).notifyListeners();

    });
  }

  Future<void> downloadAsset({required String fileName}) async {

    print("downloadAsset $fileName");
    String dir = (await getApplicationDocumentsDirectory()).path;

    print(await Directory("$dir/${fileName.replaceAll(".zip", "")}").exists());

    // ignore: unrelated_type_equality_checks
    if ( await Directory("$dir/${fileName.replaceAll(".zip", "")}").exists() == false ){

      await downloadAssets(fileName).then((value) async {

        await getApplicationDocumentsDirectory().then((dir) async {

          await AppUtils.archiveFile(await File("${dir.path}/$fileName").writeAsBytes(value.bodyBytes)).then((files) async {
            
            // await readFile(fileName);
          });
        });
        
      });

      // ignore: use_build_context_synchronously
      Provider.of<AppProvider>(buildContext!, listen: false).dirPath = dir;

      Provider.of<AppProvider>(buildContext!, listen: false).notifyListeners();
      
      print("Finish downloadAsset");
    } else {
      print("Just read");
      // ignore: use_build_context_synchronously
      Provider.of<AppProvider>(buildContext!, listen: false).dirPath = dir;
      // await readFile(fileName);
    }
  }
  
}