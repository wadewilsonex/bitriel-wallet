import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/account.m.dart';

class ReceiveWalletProvider with ChangeNotifier {
  
  GlobalKey<ScaffoldState>? globalKey;
  GlobalKey keyQrShare = GlobalKey();

  GetWalletMethod method = GetWalletMethod();
  int initialValue = 0;
  List<Map<String, dynamic>>? lsContractSymbol;
  AccountM? accountM = AccountM();

  void getAccount(AccountM acocunt){
    if (accountM != null){
      accountM!.name = acocunt.name;
      accountM!.address = acocunt.address;
      accountM!.pubKey = acocunt.pubKey;
      accountM!.addressIcon = acocunt.addressIcon;

      notifyListeners();
    }
  }
}