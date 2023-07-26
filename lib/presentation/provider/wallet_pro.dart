import 'package:bitriel_wallet/index.dart';

class WalletProvider with ChangeNotifier {

  final WalletUcImpl _walletUsecases = WalletUcImpl();

  List<SmartContractModel>? defaultListContract = [];

  List<SmartContractModel>? listEvmNative = [];
  List<SmartContractModel>? listNative = [];
  List<SmartContractModel>? listBep20 = [];
  List<SmartContractModel>? listErc20 = [];
  
  List<SmartContractModel>? addedContract = [];
  List<SmartContractModel>? sortListContract = [];

  BuildContext? _context;

  BitrielSDKImpl? sdkProvier;

  set setBuildContext(BuildContext ctx) {
    _context = ctx;
    _walletUsecases.setBuilder = ctx;
  }

  /// 1
  /// 
  /// Get Asset and Sort Asset
  Future<void> getAsset() async {
    
    await _walletUsecases.fetchCoinsFromLocalStorage().then((value) {
      defaultListContract = value[0];
      addedContract = value[1];
    });

    print("defaultListContract $defaultListContract");

    await SecureStorage.writeData(key: DbKey.listContract, encodeValue: json.encode(SmartContractModel.encode(defaultListContract!)) );

    // 0
    assetsFilter();

    // 1
    await queryNativeBalance();
    await queryEvmBalance();
    await queryBep20Balance();
    await queryErc20Balance();

    print("sortListContract.length ${sortListContract!.length}");

    sortAsset();
    // await queryCoinsBalance();
  }

  void assetsFilter() async {

    listEvmNative!.clear();

    defaultListContract!.every((element) {
      
      if (element.isBSC! || element.isEther!) {listEvmNative!.add(element);}
      /// Native include, such as: Polkadot, Substrate and Bitcoin.
      else if (element.isNative!) {listNative!.add(element);}
      else if (element.isBep20! &&  element.show == true) {listBep20!.add(element);} 
      else if (element.isErc20!) {listErc20!.add(element);} 

      return true;
    });

    sortListContract!.clear();
  }


  Future<void> queryNativeBalance() async {
    
    sdkProvier ??= Provider.of<SDKProvider>(_context!, listen: false).getSdkImpl;

    // Filter EVM Coins
    for(var element in listNative!){
      
      if (element.symbol!.toLowerCase() != 'polkadot'){

        if (element.symbol!.toLowerCase() == 'btc'){
          element.balance = await sdkProvier!.getBtcBalance();
        } else {
          element.balance = await sdkProvier!.fetchSELAddress();
        }
        sortListContract!.add(element);
      }
      // await sdkProvier!.getWeb3Balance(element.isBSC! ? sdkProvier!.getBscClient : sdkProvier!.getEthClient, EthereumAddress.fromHex(sdkProvier!.evmAddress ?? '')).then((value) {
      //   print("${element.symbol} value ${value.getValueInUnit(EtherUnit.ether)}");
      //   element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
      // });
    }
    
  }

  Future<void> queryEvmBalance() async {
    
    print("queryEvmBalance");
    sdkProvier ??= Provider.of<SDKProvider>(_context!, listen: false).getSdkImpl;
    // Filter EVM Coins
    for(var element in listEvmNative!){
      await sdkProvier!.getEvmBalance(element.isBSC! ? sdkProvier!.getBscClient : sdkProvier!.getEthClient, EthereumAddress.fromHex(sdkProvier!.evmAddress ?? '')).then((value) {
        element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
      });

      sortListContract!.add(element);
    }

  }

  Future<void> queryBep20Balance() async {

    sdkProvier ??= Provider.of<SDKProvider>(_context!, listen: false).getSdkImpl;

    for( var bep20 in listBep20!){
      
      if (bep20.symbol!.toLowerCase() == "usdt"){
        bep20.balance = (await _walletUsecases.getContractBalance(sdkProvier!.getBscClient, "assets/json/abi/bep20.json", bep20.platform![0]['contract']))[0].toString();
      }
      else {
        bep20.balance = (await _walletUsecases.getContractBalance(sdkProvier!.getBscClient, "assets/json/abi/bep20.json", bep20.contract!))[0].toString();
      }

      sortListContract!.add(bep20);
    }
    // await _walletUsecases.getContractBalance("json/abi/bep20.json", );
    // for (var element in sortListContract!) {
    //   if (element.isBep20!){
    //     await sdkProvier!.getWeb3Balance(sdkProvier!.getBscClient, EthereumAddress.fromHex(sdkProvier!.evmAddress ?? ''))
    //     .then((value) {
    //       print("value ${value.getValueInUnit(EtherUnit.ether)}");
    //       element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
    //     });
    //   } 
    //   else if (element.isErc20!) {
    //     if (element.isBep20!){
    //     await sdkProvier!.getWeb3Balance(sdkProvier!.getEthClient, EthereumAddress.fromHex(sdkProvier!.evmAddress ?? ''))
    //       .then((value) {
    //         print("value ${value.getValueInUnit(EtherUnit.ether)}");
    //         element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
    //       });
    //     }
    //   }
    // }

  }

  Future<void> queryErc20Balance() async {

    sdkProvier ??= Provider.of<SDKProvider>(_context!, listen: false).getSdkImpl;

    for( var erc20 in listErc20!){

      if (erc20.symbol!.toLowerCase() == "usdt"){
        erc20.balance = (await _walletUsecases.getContractBalance(sdkProvier!.getEthClient, "json/abi/erc20.json", erc20.platform![1]['contract']))[0].toString();
      }
      else {
        erc20.balance = (await _walletUsecases.getContractBalance(sdkProvier!.getEthClient, "json/abi/erc20.json", erc20.contract!))[0].toString();
      }
      
      sortListContract!.add(erc20);
    }
    // for (var element in sortListContract!) {
    //   if (element.isBep20!){
    //     await sdkProvier!.getWeb3Balance(sdkProvier!.getBscClient, EthereumAddress.fromHex(sdkProvier!.evmAddress ?? ''))
    //     .then((value) {
    //       print("value ${value.getValueInUnit(EtherUnit.ether)}");
    //       element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
    //     });
    //   } 
    //   else if (element.isErc20!) {
    //     if (element.isBep20!){
    //     await sdkProvier!.getWeb3Balance(sdkProvier!.getEthClient, EthereumAddress.fromHex(sdkProvier!.evmAddress ?? ''))
    //       .then((value) {
    //         print("value ${value.getValueInUnit(EtherUnit.ether)}");
    //         element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
    //       });
    //     }
    //   }
    // }

  }

  /// 2
  Future<void> sortAsset() async {
    
    // sortListContract = 
    await _walletUsecases.sortCoins(sortListContract!);

    // notifyListeners();
  }

}