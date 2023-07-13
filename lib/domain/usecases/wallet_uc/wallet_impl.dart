import 'package:bitriel_wallet/index.dart';

class WalletUcImpl implements WalletUsecases{

  String? _dir;

  BuildContext? _context;
  SDKProvier? sdkProvier;

  set setBuilder(BuildContext ctx){

    _context = ctx;
    sdkProvier ??= Provider.of<SDKProvier>(_context!, listen: false);
  }

  /// 1 fetchCoinsFromLocalStorage
  /// 
  /// Return Index 0 for List Assets
  /// 
  /// Return Index 1 for Added Assets
  @override
  Future<List<List<SmartContractModel>>> fetchCoinsFromLocalStorage() async {

    if (await SecureStorage.isContain(DbKey.listContract) ){

      return [
        await SecureStorage.readData(key: DbKey.listContract).then((value) {
          if (value != null) {
            return mapModel( List<Map<String, dynamic>>.from(json.decode(value)) );
          }
          return [];
        }),

        await SecureStorage.readData(key: DbKey.addedContract).then((value) {
          if (value != null) {
            return mapModel( List<Map<String, dynamic>>.from(json.decode(value)) );
          }
          return [];
        })
      ];

    } else {

      return [
        await fetchCoinFromAssets(),
        []
      ];
    }

  }

  /// 2.
  @override
  Future<List<SmartContractModel>> fetchCoinFromAssets() async {

    _dir = (await getApplicationDocumentsDirectory()).path;

    final jsn = await rootBundle.loadString("assets/json/supported_contract.json");

    return mapModel(List<Map<String, dynamic>>.from(jsonDecode(jsn)));
 
  }

  /// 3.
  List<SmartContractModel> mapModel(List<Map<String, dynamic>> data) {
    
    return data.map((e) {
      return SmartContractModel(
        id: e['id'],
        name: e["name"],
        logo: "$_dir/${e["logo"]}",
        address: e['address'],
        contract: e['contract'],
        contractTest: e['contract_test'],
        symbol: e["symbol"],
        org: e["org"],
        orgTest: e["org_test"],
        isContain: e["isContain"],
        balance: e["balance"],
        show: e["show"],
        maxSupply: e["max_supply"],
        description: e["description"]
        // lineChartList: Provider.of<MarketProvider>(context!, listen: false).sortDataMarket[i]['chart_data'] != null ? List<List<double>>.from(Provider.of<MarketProvider>(context!, listen: false).sortDataMarket[i]['chart_data']) : null, //e['lineChartData'],
        // lineChartList: e['lineChartData'],
        // listActivity: [],
        // lineChartModel: LineChartModel(values: List<FlSpot>.empty(growable: true)),
      );
    }).toList();

  }

  @override
  Future<List<SmartContractModel>> sortCoins(List<SmartContractModel> lst) async {
    try {

      // mainBalance = 0;
      // sortListContract.clear();
      
      // 1. Add Default Asset First
      for (var element in lst) {
        if (element.show! && element.id != "polkadot" && element.id != "kiwigo"){
          
          if (element.marketPrice!.isNotEmpty) {
            element.money = double.parse(element.balance!.replaceAll(",", "")) * double.parse(element.marketPrice!);
          } else {
            element.money = 0.0;
          }

          // mainBalance = mainBalance + element.money!;//double.parse(element.balance!.replaceAll(",", ""));
          // sortListContract.addAll({element});
        } 
      }

      // 2. Add Imported Asset
      // for (var element in addedContract) {
      //   if (element.marketPrice!.isNotEmpty) {
      //     element.money = double.parse(element.balance!.replaceAll(",", "")) * double.parse(element.marketPrice!);
      //   } else {
      //     element.money = 0.0;
      //   }
      //   mainBalance = mainBalance + element.money!;
      //   sortListContract.addAll({element});
        
      // }

      // Sort Descending

      SmartContractModel tmp = SmartContractModel();
      
      for (int i = 1; i < lst.length; i++) {

        for (int j = i + 1; j < lst.length; j++) {
          tmp = lst[i];
          if ( (double.parse(lst[j].balance!.replaceAll(",", ""))) > (double.parse(lst[i].balance!.replaceAll(",", ""))) ) {
            lst[i] = lst[j];
            lst[j] = tmp;
          }
        }
      }
      
    } catch (e) {
      
      if (kDebugMode) {
        
      }
      
    }

    return lst;

  }

  /// Fallback assignment operator: ??=
  /// it assigns a value if the variable is null.
  @override
  Future<EtherAmount> queryCoinsBalance(List<SmartContractModel> lstCoins) async {
    
    print("queryCoinsBalance wallet uc");
    return await sdkProvier!.getSdkProvider.getWeb3Balance(sdkProvier!.getSdkProvider.getEthClient, EthereumAddress.fromHex(sdkProvier!.getSdkProvider.evmAddress!));
    // balance.getValueInUnit(EtherUnit.ether)
  }
  
}