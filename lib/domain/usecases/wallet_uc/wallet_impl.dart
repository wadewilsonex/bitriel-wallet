import 'package:bitriel_wallet/index.dart';

class WalletUcImpl implements WalletUsecases{

  String? _dir;

  BitrielSDKImpl? _bitrielSDKImpl;
  BuildContext? _context;

  set setBuilder(BuildContext ctx){

    _context = ctx;

    _bitrielSDKImpl = Provider.of<SDKProvider>(ctx, listen: false).getSdkImpl;
  }

  /// 1 fetchCoinsFromLocalStorage
  /// 
  /// Return Index 0 for List Assets
  /// 
  /// Return Index 1 for Added Assets
  @override
  Future<List<List<SmartContractModel>>> fetchCoinsFromLocalStorage() async {
    // if ( (await SecureStorage.isContain(DbKey.listContract) || (await SecureStorage.isContain(DbKey.addedContract)) ) ){
    //   print("Return storage");
    //   return [
    //     await SecureStorage.readData(key: DbKey.listContract).then((value) {
    //       if (value != null) {
    //         return mapModel( List<Map<String, dynamic>>.from(json.decode(value)) );
    //       }
    //       return [];
    //     }),

    //     await SecureStorage.readData(key: DbKey.addedContract).then((value) {
    //       print("addedContract shit $value");
    //       if (value != null) {
    //         return mapModel( List<Map<String, dynamic>>.from(json.decode(value)) );
    //       }
    //       return [];
    //     })
    //   ];

    // } else {

    //   print("Return from asset");

      return [
        await fetchCoinFromAssets(),
        // []
        await SecureStorage.readData(key: DbKey.addedContract).then((value) {
          print("addedContract shit $value");
          if (value != null) {
            return mapModel( List<Map<String, dynamic>>.from(json.decode(value)) );
          }
          return [];
        })
      ];
    // }

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
        symbol: e["symbol"],
        org: e["org"],
        isBSC: e["is_bsc"],
        isEther: e["is_ether"],
        isNative: e["is_native"],
        isBep20: e["is_bep20"],
        isErc20: e["is_erc20"],
        balance: e["balance"],
        show: e["show"],
        maxSupply: e["max_supply"],
        description: e["description"],
        platform: e['platform'] == null ? [] : List<Map<String, dynamic>>.from(e['platform'])
        // lineChartList: Provider.of<MarketProvider>(context!, listen: false).sortDataMarket[i]['chart_data'] != null ? List<List<double>>.from(Provider.of<MarketProvider>(context!, listen: false).sortDataMarket[i]['chart_data']) : null, //e['lineChartData'],
        // lineChartList: e['lineChartData'],
        // listActivity: [],
        // lineChartModel: LineChartModel(values: List<FlSpot>.empty(growable: true)),
      );
    }).toList();

  }

  @override
  Future<List<SmartContractModel>> sortCoins(List<SmartContractModel> lst, {List<SmartContractModel>? addedCoin}) async {
    
    print("sortCoins");
    
    try {

      // mainBalance = 0;
      // sortListContract.clear();
      // 1. Add Default Asset First
      for (var element in lst) {
        if (element.show! && element.id != "polkadot" && element.id != "kiwigo"){
          
          if (element.marketPrice!.isNotEmpty && element.money != null) {
            element.money = double.parse(element.balance!.replaceAll(",", "")) * double.parse(element.marketPrice ?? '0.0');
          } else {
            element.money = 0.0;
          }

          // mainBalance = mainBalance + element.money!;//double.parse(element.balance!.replaceAll(",", ""));
          // sortListContract.addAll({element});
        } 
      }

      // 2. Add Imported Asset
      // for (var element in addedCoin!) {
      //   print("addedCoin ${element.symbol}");
      //   if (element.marketPrice!.isNotEmpty) {
      //     element.money = double.parse(element.balance!.replaceAll(",", "")) * double.parse(element.marketPrice!);
      //   } else {
      //     element.money = 0.0;
      //   }
      //   // mainBalance = mainBalance + element.money!;
      //   // sortListContract.addAll({element});
      //   lst.add(element);
      // }

      // Sort Descending

      SmartContractModel tmp = SmartContractModel();
      
      // for (int i = 1; i < lst.length; i++) {

      //   for (int j = i + 1; j < lst.length; j++) {
      //     tmp = lst[i];
      //     if ( (double.parse(lst[j].balance!.replaceAll(",", ""))) > (double.parse(lst[i].balance!.replaceAll(",", ""))) ) {
      //       lst[i] = lst[j];
      //       lst[j] = tmp;
      //     }
      //   }
      // }

      print("After short sort ");
      for (var element in lst) {
        print("addedCoin ${element.symbol}");
      }
      
    } catch (e) {
      print("error sortCoins $e");
      if (kDebugMode) {
        
      }
      
    }

    return lst;

  }

  Future<String> fetchSELAddress() async {
    
    // return "0";
    return await _bitrielSDKImpl!.sdkRepoImpl.querySELAddress(_bitrielSDKImpl!.getKeyring.current.address!);

  }

  Future<String> queryBtcBalance() async {
    _bitrielSDKImpl = Provider.of<SDKProvider>(_context!, listen: false).getSdkImpl;
    // return await _httpRequestImpl.fetchAddrUxtoBTC(_bitrielSDKImpl!.btcAddress!).then((value) {

    // });
    return "0";
  }

  Future<String> getBtcBalance() async {

    int totalSatoshi = 0;
    Response res = await HttpRequestImpl().fetchAddrUxtoBTC(_bitrielSDKImpl!.btcAddress!);
    
    List<dynamic> decode = json.decode(res.body);

    if (decode.isEmpty) {
        // contract.listContract[btcIndex].balance = '0';
    } else {
      for (final i in decode) {
        if (i['status']['confirmed'] == true) {
          totalSatoshi += int.parse(i['value'].toString());
        }
      }

      // contract.listContract[btcIndex].balance = (totalSatoshi / bitcoinSatFmt).toString();
    }
    return totalSatoshi.toString();

  }

  /// Fallback assignment operator: ??=
  /// it assigns a value if the variable is null.
  @override
  Future<EtherAmount> getCoinsBalance(SDKProvider sdkProvier, List<SmartContractModel> lstCoins) async {
    
    return await sdkProvier.getSdkImpl.getEvmBalance(sdkProvier.getSdkImpl.getEthClient, EthereumAddress.fromHex(sdkProvier.getSdkImpl.evmAddress!));
    // balance.getValueInUnit(EtherUnit.ether)
  }

  /// BEP20 & ERC-20
  Future<List<dynamic>> getContractBalance(Web3Client client, DeployedContract deployedContract, String? addr) async {
    // Get Web3 Balance
    return await _bitrielSDKImpl!.callWeb3ContractFunc(client, deployedContract, 'balanceOf', params: [EthereumAddress.fromHex(addr!)]);

  }
  
}