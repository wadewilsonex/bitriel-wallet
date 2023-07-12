import 'package:bitriel_wallet/index.dart';

class WalletUcImpl implements WalletUsecases{

  List<SmartContractModel>? listContract = [];
  List<SmartContractModel>? sortListContract = [];
  String? _dir;

  @override
  Future<void> fetchCoinFromLocal() async {
    
    _dir = (await getApplicationDocumentsDirectory()).path;

    final jsn = await rootBundle.loadString("assets/json/supported_contract.json");
    final decode = jsonDecode(jsn);

      sortListContract!.clear();
      listContract!.clear();
    
      for (int i = 0 ; i < decode.length; i++){

        if (i == 5){

          // ethAdd = decode[i]['address'];
        }

        listContract!.add(
          SmartContractModel(
            id: decode[i]['id'],
            name: decode[i]["name"],
            logo: "$_dir/${decode[i]["logo"]}",
            address: decode[i]['address'],
            contract: decode[i]['contract'],
            contractTest: decode[i]['contract_test'],
            symbol: decode[i]["symbol"],
            org: decode[i]["org"],
            orgTest: decode[i]["org_test"],
            isContain: decode[i]["isContain"],
            balance: decode[i]["balance"],
            show: decode[i]["show"],
            maxSupply: decode[i]["max_supply"],
            description: decode[i]["description"],
            // lineChartList: Provider.of<MarketProvider>(context!, listen: false).sortDataMarket[i]['chart_data'] != null ? List<List<double>>.from(Provider.of<MarketProvider>(context!, listen: false).sortDataMarket[i]['chart_data']) : null, //decode[i]['lineChartData'],
            // lineChartList: decode[i]['lineChartData'],
            // listActivity: [],
            // lineChartModel: LineChartModel(values: List<FlSpot>.empty(growable: true)),
          )
        );
      }

      await SecureStorage.writeData(key: DbKey.listContract, encodeValue: json.encode(SmartContractModel.encode(listContract!)) );
  }
}