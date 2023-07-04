import 'dart:async';

import 'package:bitriel_wallet/index.dart';

class ImportWalletProvider with ChangeNotifier {

  // final BitrielSDKImpl _sdkImpl = BitrielSDKImpl();

  SDKProvier? _sdkProvier;

  String? password;

  TextEditingController seedController = TextEditingController();

  bool isSeedValid = false;

  void changeState(String seed){
    if (seed.split(" ").toList().length == 12 && seed.split(" ").toList().last != ""){
      isSeedValid = true;
      Timer(const Duration(milliseconds: 100), (){notifyListeners();});
    } else if (isSeedValid) {
      isSeedValid = false;
      Timer(const Duration(milliseconds: 100), (){notifyListeners();});
    }
  }

  void resetState(){
    isSeedValid = false;
  }
}