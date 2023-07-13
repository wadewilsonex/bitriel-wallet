import 'package:bitriel_wallet/index.dart';

class WalletProvider with ChangeNotifier {

  final WalletUcImpl _walletUsecases = WalletUcImpl();

  List<SmartContractModel>? listContract = [];
  List<SmartContractModel>? addedContract = [];
  List<SmartContractModel>? sortListContract = [];

  set setBuilderContext(BuildContext ctx) => _walletUsecases.setBuilder = ctx;

  /// 1
  /// 
  /// Get Asset and Sort Asset
  Future<void> getAsset() async {
    
    await _walletUsecases.fetchCoinsFromLocalStorage().then((value) {
      listContract = value[0];
      addedContract = value[1];
    });

    await SecureStorage.writeData(key: DbKey.listContract, encodeValue: json.encode(SmartContractModel.encode(listContract!)) );

    await sortAsset();

    // await queryCoinsBalance();
  }

  /// 2
  Future<void> sortAsset() async {
    
    sortListContract = await _walletUsecases.sortCoins(listContract!);

    notifyListeners();
  }

  Future<void> queryCoinsBalance() async {
    print("queryCoinsBalance");
    await _walletUsecases.queryCoinsBalance(sortListContract!);
    // .then((value) {
    //   print("value ${value.getValueInUnit(EtherUnit.ether)}");
    // });
    // notifyListeners();
  }
}