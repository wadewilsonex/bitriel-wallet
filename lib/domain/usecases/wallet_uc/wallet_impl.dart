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
    if ( (await SecureStorage.isContain(DbKey.listContract) || (await SecureStorage.isContain(DbKey.addedContract)) ) ){

      return [
        await SecureStorage.readData(key: DbKey.listContract).then((value) {
          if (value != null) {
            return SmartContractModel.decode(value);
          }
          return [];
        }),

        await SecureStorage.readData(key: DbKey.addedContract).then((value) {
          if (value != null) {
            return SmartContractModel.decode(value);
          }
          return [];
        })
      ];

    } else {

      return [
        await fetchCoinFromAssets(),
        // []
        await SecureStorage.readData(key: DbKey.addedContract).then((value) {
          if (value != null) {
            return SmartContractModel.decode(value);
          }
          return [];
        })
      ];
    }

  }

  /// 2.
  @override
  Future<List<SmartContractModel>> fetchCoinFromAssets() async {
    
    _dir = (await getApplicationDocumentsDirectory()).path;

    final jsn = await rootBundle.loadString("assets/json/supported_contract.json");

    return await SmartContractModel.decode(jsn);// mapModel(List<Map<String, dynamic>>.from(jsonDecode(jsn)));
 
  }

  @override
  Future<List<SmartContractModel>> sortCoins(List<SmartContractModel> lst, {List<SmartContractModel>? addedCoin}) async {
    
    try {

      // mainBalance = 0;
      // sortListContract.clear();
      // 1. Add Default Asset First
      for (var element in lst) {
        if (element.show! && element.id != "polkadot" && element.id != "kiwigo"){
          
          if (element.marketPrice!.isNotEmpty && element.balance != null) {
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

      // SmartContractModel tmp = SmartContractModel();
      
      // for (int i = 1; i < lst.length; i++) {

      //   for (int j = i + 1; j < lst.length; j++) {
      //     tmp = lst[i];
      //     if ( (double.parse(lst[j].balance!.replaceAll(",", ""))) > (double.parse(lst[i].balance!.replaceAll(",", ""))) ) {
      //       lst[i] = lst[j];
      //       lst[j] = tmp;
      //     }
      //   }
      // }
      
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