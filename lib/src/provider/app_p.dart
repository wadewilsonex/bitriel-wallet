import 'package:wallet_apps/index.dart';

class AppProvider with ChangeNotifier {

  static BuildContext? buildContext;

  String? dirPath;

  set setContext(BuildContext ct) {
    buildContext = ct;

    // notifyListeners();
  }
  
}