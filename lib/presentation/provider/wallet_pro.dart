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
    // await sortAsset();

    
    // 2
    await queryNativeBalance();
    await queryEvmBalance();
    await queryBep20Balance();
    await queryErc20Balance();
    // await queryCoinsBalance();
  }

  void assetsFilter() async {

    listEvmNative!.clear();

    defaultListContract!.every((element) {
      
      if (element.isBSC! || element.isEther!) {listEvmNative!.add(element);}
      /// Native include, such as: Polkadot, Substrate and Bitcoin.
      else if (element.isNative!) {listNative!.add(element);}
      else if (element.isBep20!) {listBep20!.add(element);} 
      else if (element.isErc20!) {listErc20!.add(element);} 

      return true;
    });
  }

  /// 2
  Future<void> sortAsset() async {
    
    sortListContract = await _walletUsecases.sortCoins(defaultListContract!);

    // notifyListeners();
  }


  Future<void> queryNativeBalance() async {
    print("queryNativeBalance");
    sdkProvier ??= Provider.of<SDKProvier>(_context!, listen: false).getSdkImpl;
    print("listNative ${listNative!.length}");
    // Filter EVM Coins
    for(var element in listNative!){
      
      if (element.symbol!.toLowerCase() != 'polkadot'){

        if (element.symbol!.toLowerCase() == 'btc'){
          element.balance = await sdkProvier!.getBtcBalance();
        } else {
          element.balance = await sdkProvier!.fetchSELAddress();
        }
        print("${element.symbol} ${element.balance}");
      }
      // await sdkProvier!.getWeb3Balance(element.isBSC! ? sdkProvier!.getBscClient : sdkProvier!.getEthClient, EthereumAddress.fromHex(sdkProvier!.evmAddress ?? '')).then((value) {
      //   print("${element.symbol} value ${value.getValueInUnit(EtherUnit.ether)}");
      //   element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
      // });
    }
    
  }

  Future<void> queryEvmBalance() async {
    
    print("queryEvmBalance");
    sdkProvier ??= Provider.of<SDKProvier>(_context!, listen: false).getSdkImpl;
    // Filter EVM Coins
    for(var element in listEvmNative!){
      print("sdkProvier!.evmAddress ${sdkProvier!.evmAddress}");
      await sdkProvier!.getEvmBalance(element.isBSC! ? sdkProvier!.getBscClient : sdkProvier!.getEthClient, EthereumAddress.fromHex(sdkProvier!.evmAddress ?? '')).then((value) {
        print("${element.symbol} value ${value.getValueInUnit(EtherUnit.ether)}");
        element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
      });

      print("${element.symbol} ${element.balance}");

    }

  }

  Future<void> queryBep20Balance() async {

    print("queryBep20Balance");
    sdkProvier ??= Provider.of<SDKProvier>(_context!, listen: false).getSdkImpl;

    for( var bep20 in listBep20!){
      
      if (bep20.symbol!.toLowerCase() == "usdt"){
        print("bep20.platform![0]['contract'] ${bep20.platform![0]['contract']}");
        bep20.balance = (await _walletUsecases.getContractBalance(sdkProvier!.getBscClient, "assets/json/abi/bep20.json", bep20.platform![0]['contract'])).toString();
      }
      else {
        bep20.balance = (await _walletUsecases.getContractBalance(sdkProvier!.getBscClient, "assets/json/abi/bep20.json", bep20.contract!)).toString();
      }
      
      print("${bep20.symbol} ${bep20.balance}");
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

    print("queryErc20Balance");
    sdkProvier ??= Provider.of<SDKProvier>(_context!, listen: false).getSdkImpl;

    for( var erc20 in listErc20!){

      if (erc20.symbol!.toLowerCase() == "usdt"){
        erc20.balance = (await _walletUsecases.getContractBalance(sdkProvier!.getEthClient, "json/abi/erc20.json", erc20.platform![1]['contract'])).toString();
      }
      else {
        erc20.balance = (await _walletUsecases.getContractBalance(sdkProvier!.getEthClient, "json/abi/erc20.json", erc20.contract!)).toString();
      }
      
      print("${erc20.symbol} ${erc20.balance}");
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

}