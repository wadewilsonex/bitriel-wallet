import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/account.m.dart';

class ReceiveWalletProvider with ChangeNotifier {
  
  GlobalKey<ScaffoldState>? globalKey;
  GlobalKey keyQrShare = GlobalKey();

  GetWalletMethod method = GetWalletMethod();

  /// For DropDown
  int assetsIndex = 0;
  List<Map<String, dynamic>>? lsContractSymbol;
  AccountM? accountM = AccountM();

  void getAccount(AccountM account){
    if (accountM != null){
      accountM!.name = account.name;
      accountM!.address = account.address;
      accountM!.pubKey = account.pubKey;
      accountM!.addressIcon = account.addressIcon;
    }
  }
}