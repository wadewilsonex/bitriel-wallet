import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/account.m.dart';

class ReceiveWalletProvider with ChangeNotifier {
  
  GlobalKey<ScaffoldState>? globalKey;
  GlobalKey keyQrShare = GlobalKey();

  GetWalletMethod method = GetWalletMethod();
  int initialValue = 0;
  List<Map<String, dynamic>>? lsContractSymbol;
  AccountM? accountM = AccountM();

  void getAccount(ApiProvider apiProvider){
    if (accountM != null){
      accountM = apiProvider.accountM;

      notifyListeners();
    }
  }
}