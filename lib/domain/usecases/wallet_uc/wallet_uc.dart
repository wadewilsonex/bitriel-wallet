import 'package:bitriel_wallet/index.dart';

abstract class WalletUsecases {

  // set setContext(BuildContext ctx);
  Future<void> fetchCoinsFromLocalStorage();
  Future<void> fetchCoinFromAssets();
  Future<void> sortCoins(List<SmartContractModel> lst);

  Future<void> getCoinsBalance(SDKProvier sdkProvier, List<SmartContractModel> lstCoins);

}