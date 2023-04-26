import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';

class AppProvider with ChangeNotifier {

  static BuildContext? buildContext;

  bool? isIconsReady = false;

  String? dirPath;

  File? file;
  
  List<File>? onBoardingImg = [
    File(''),
    File(''),
    File(''),
    File(''),
    File(''),
    File(''),
  ];

  set setContext(BuildContext ct) {
    buildContext = ct;

    // notifyListeners();
  }
  
  Future<void> downloadFirstAsset() async {

    await Permission.storage.request().then((pm) async {
      print("allAssets");
      Provider.of<AppProvider>(buildContext!, listen: false).dirPath ??= (await getApplicationDocumentsDirectory()).path;
      // ignore: use_build_context_synchronously
      AppConfig.initIconPath(buildContext!);

      await downloadAsset(fileName: 'icons.zip');
      isIconsReady = true;

      onBoardingImg = [
        File("$dirPath/icons/setup-1.png"),
        File("$dirPath/icons/setup-2.png"),
        File("$dirPath/icons/setup-3.png"),
        File("$dirPath/icons/google-vector.svg"),
        File("$dirPath/icons/setup-4.png"),
        File("$dirPath/icons/json-file.svg"),
      ];
      
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
      Provider.of<AppProvider>(buildContext!, listen: false).notifyListeners();

      await downloadAsset(fileName: 'logo.zip');

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
      Provider.of<AppProvider>(buildContext!, listen: false).notifyListeners();

    });
  }

  Future<void> downloadSecondAsset() async {

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
  }  

  Future<void> downloadAsset({required String fileName}) async {

    print("downloadAsset $fileName");
    String dir = (await getApplicationDocumentsDirectory()).path;

    // ignore: unrelated_type_equality_checks
    if ( await Directory("$dir/${fileName.replaceAll(".zip", "")}").exists() == false ){

      await downloadAssets(fileName).then((value) async {

        await getApplicationDocumentsDirectory().then((dir) async {

          await AppUtils.archiveFile(await File("${dir.path}/$fileName").writeAsBytes(value.bodyBytes)).then((files) async {
            
            // await readFile(fileName);

            Provider.of<AppProvider>(buildContext!, listen: false).notifyListeners();
          });
        });
        
      });
      
      print("Finish downloadAsset");
    } else {
      print("Just read");
      // ignore: use_build_context_synchronously
      Provider.of<AppProvider>(buildContext!, listen: false).dirPath = dir;
      // await readFile(fileName);
    }
  }

  Future<void> deleteAllFile() async {

    isIconsReady = false;
    
    notifyListeners();

    Directory("$dirPath/icons").deleteSync(recursive: true);
    Directory("$dirPath/logo").deleteSync(recursive: true);
    Directory("$dirPath/token_logo").deleteSync(recursive: true);
    Directory("$dirPath/nfts").deleteSync(recursive: true);
    Directory("$dirPath/default").deleteSync(recursive: true);
    Directory("$dirPath/payment").deleteSync(recursive: true);
  }
  
}