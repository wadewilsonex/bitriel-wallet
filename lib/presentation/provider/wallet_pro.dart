import 'package:bitriel_wallet/index.dart';

class WalletProvider with ChangeNotifier {

  final WalletUcImpl _walletUsecases = WalletUcImpl();

  List<SmartContractModel>? defaultListContract;

  List<SmartContractModel>? listEvmNative;
  List<SmartContractModel>? listNative;
  List<SmartContractModel>? listBep20;
  List<SmartContractModel>? listErc20;
  
  List<SmartContractModel>? addedContract;
  List<SmartContractModel>? sortListContract;

  BuildContext? _context;

  SDKProvider? sdkProvider;

  MarketUCImpl marketUCImpl = MarketUCImpl();
  

  set setBuildContext(BuildContext ctx) {
    
    _context = ctx;
    _walletUsecases.setBuilder = ctx;
    sdkProvider = Provider.of<SDKProvider>(_context!, listen: false);

  }

  void switchChange(bool value){
    sdkProvider!.setIsMainnet = value;
  }

  void initState(){

    defaultListContract = [];
    listEvmNative = [];
    listNative = [];
    listBep20 = [];
    listErc20 = [];
    addedContract = [];
    sortListContract = [];

  }

  /// 1
  /// 
  /// Get Asset and Sort Asset
  Future<void> getAsset() async {

    initState();
    
    try {

      await _walletUsecases.fetchCoinsFromLocalStorage().then((value) {
        defaultListContract = value[0];
        addedContract = value[1];
      });

      print("defaultListContract ${defaultListContract!.length}");
      print("addedContract ${addedContract!.length}");

      await SecureStorage.writeData(key: DbKey.listContract, encodeValue: json.encode(SmartContractModel.encode(defaultListContract!)) );

      print("sdkProvider!.isMainnet.value ${sdkProvider!.isMainnet.value}");
      if (sdkProvider!.isMainnet.value == true) {

        await assetStateManipulate();
        
      }
      //  else {

      //   await coinsTestnet();
        
      // }
    } catch (e) {
      print("Error getAsset $e");
    }

  }

  /// List Only EVM coins and SEL
  Future<void> coinsTestnet()async {
    
    print("coinsTestnet");
    defaultListContract!.every((element) {
        
      if ( (element.isBSC! || element.isEther!) && element.show == true ) {
        print("element ${element.symbol}");
        print("element ${element.isBSC}");
        listEvmNative!.add(element);
      }
      else if (element.isNative! && element.show == true && element.symbol!.toLowerCase() == "sel") {listNative!.add(element);}
      
      return true;
    });

    addedContract!.every((element) {
      print("addedContract addedContract addedContract $element");
      if (element.isBep20! && element.show == true) {listBep20!.add(element);} 
      else if (element.isErc20! && element.show == true) {listErc20!.add(element);} 

      return true;
    });

    await queryEvmBalance();
    print("finish queryEvmBalance");
    await queryBep20Balance();
    print("finish queryBep20Balance");
    // await queryErc20Balance();
    print("finish queryErc20Balance");

    sortAsset();
  }

  /// List All Support Token in Mainnet
  Future<void> assetStateManipulate() async {
    
    // 0
    assetsFilter();

    // 1
    await queryNativeBalance();
    await queryEvmBalance();
    await queryBep20Balance();
    // await queryErc20Balance();

    sortAsset();
    // await queryCoinsBalance();
  }

  void assetsFilter() async {
    
    print("assetsFilter");

    listEvmNative!.clear();

    defaultListContract!.every((element) {
      
      if ( (element.isBSC! || element.isEther!) && element.show == true ) {listEvmNative!.add(element);}
      /// Native include, such as: Polkadot, Substrate and Bitcoin.
      else if (element.isNative! && element.show == true) {listNative!.add(element);}
      else if (element.isBep20! && element.show == true) {listBep20!.add(element);} 
      else if (element.isErc20! && element.show == true) {listErc20!.add(element);} 

      return true;
    });

    // addedContract!.every((element) {
    //   if (element.isBep20! && element.show == true) {listBep20!.add(element);} 
    //   else if (element.isErc20! && element.show == true) {listErc20!.add(element);} 

    //   return true;
    // });

    sortListContract!.clear();
  }

  // Start Fetch Balance Each Coins

  Future<void> queryNativeBalance() async {

    // Filter EVM Coins
    for(var element in listNative!){
      
      if (element.symbol!.toLowerCase() != 'polkadot'){

        if (element.symbol!.toLowerCase() == 'btc'){
          element.balance = await _walletUsecases.getBtcBalance();
        } else {
          element.balance = await _walletUsecases.fetchSELAddress();
        }
        sortListContract!.add(element);
      }
      // await sdkProvider!.getSdkImpl.getWeb3Balance(element.isBSC! ? sdkProvider!.getSdkImpl.getBscClient : sdkProvider!.getSdkImpl.getEthClient, EthereumAddress.fromHex(sdkProvider!.getSdkImpl.evmAddress ?? '')).then((value) {
      //   print("${element.symbol} value ${value.getValueInUnit(EtherUnit.ether)}");
      //   element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
      // });
    }

    notifyListeners();
    
  }

  Future<void> queryEvmBalance() async {

    // Filter EVM Coins
    for(var element in listEvmNative!){

      // print("element ${element.symbol}");
      await sdkProvider!.getSdkImpl.getEvmBalance(
        sdkProvider!.getSdkImpl.getBscClient,
        // sdkProvider!.getSdkImpl.getBscClient, 
        EthereumAddress.fromHex(sdkProvider!.getSdkImpl.evmAddress ?? '')
      ).then((value) {
        element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
      });

      sortListContract!.add(element);
      
    }
    
    notifyListeners();

  }

  Future<void> queryBep20Balance() async {

    print("queryBep20Balance");

    for( var bep20 in listBep20!){
      
      print(bep20.symbol!);

      if (bep20.symbol!.toLowerCase() == "usdt" && sdkProvider!.isMainnet.value == true){
        sdkProvider!.getSdkImpl.bscDeployedContract = await sdkProvider!.getSdkImpl.deployContract("assets/json/abi/bep20.json", "0x55d398326f99059ff775485246999027b3197955");
        bep20.balance = (await _walletUsecases.getContractBalance(sdkProvider!.getSdkImpl.getBscClient, sdkProvider!.getSdkImpl.bscDeployedContract!, sdkProvider!.getSdkImpl.evmAddress ))[0].toString();
        print("bep20.balance ${bep20.balance}");
      }
      // else {
      //   print("Testnet");
      //   print("bep20.name ${bep20.name}");
      //   print("bep20.contract! ${bep20.contract!}");
      //   sdkProvider!.getSdkImpl.bscDeployedContract = await sdkProvider!.getSdkImpl.deployContract("assets/json/abi/bep20.json", bep20.contract! );
      //   await _walletUsecases.getContractBalance(sdkProvider!.getSdkImpl.getBscClient, sdkProvider!.getSdkImpl.bscDeployedContract!).then((value) {
      //     bep20.balance = (value[0] / BigInt.from(pow(10, 18))).toString();
      //   });
      // }

      sortListContract!.add(bep20);
    }

    // await _walletUsecases.getContractBalance("json/abi/bep20.json", );
    // for (var element in sortListContract!) {
    //   if (element.isBep20!){
    //     await sdkProvider!.getSdkImpl.getWeb3Balance(sdkProvider!.getSdkImpl.getBscClient, EthereumAddress.fromHex(sdkProvider!.getSdkImpl.evmAddress ?? ''))
    //     .then((value) {
    //       print("value ${value.getValueInUnit(EtherUnit.ether)}");
    //       element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
    //     });
    //   } 
    //   else if (element.isErc20!) {
    //     if (element.isBep20!){
    //     await sdkProvider!.getSdkImpl.getWeb3Balance(sdkProvider!.getSdkImpl.getEthClient, EthereumAddress.fromHex(sdkProvider!.getSdkImpl.evmAddress ?? ''))
    //       .then((value) {
    //         print("value ${value.getValueInUnit(EtherUnit.ether)}");
    //         element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
    //       });
    //     }
    //   }
    // }
    notifyListeners();

  }

  Future<void> queryErc20Balance() async {

    for( var erc20 in listErc20!){

      if (erc20.symbol!.toLowerCase() == "usdt"){

        erc20.balance = (await _walletUsecases.getContractBalance(sdkProvider!.getSdkImpl.getEthClient, sdkProvider!.getSdkImpl.etherDeployedContract!, sdkProvider!.getSdkImpl.evmAddress))[0].toString();

      }
      else {
        erc20.balance = (await _walletUsecases.getContractBalance(sdkProvider!.getSdkImpl.getEthClient, sdkProvider!.getSdkImpl.etherDeployedContract!, sdkProvider!.getSdkImpl.evmAddress))[0].toString();
      }
      
      sortListContract!.add(erc20);

    }
    // for (var element in sortListContract!) {
    //   if (element.isBep20!){
    //     await sdkProvider!.getSdkImpl.getWeb3Balance(sdkProvider!.getSdkImpl.getBscClient, EthereumAddress.fromHex(sdkProvider!.getSdkImpl.evmAddress ?? ''))
    //     .then((value) {
    //       print("value ${value.getValueInUnit(EtherUnit.ether)}");
    //       element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
    //     });
    //   } 
    //   else if (element.isErc20!) {
    //     if (element.isBep20!){
    //     await sdkProvider!.getSdkImpl.getWeb3Balance(sdkProvider!.getSdkImpl.getEthClient, EthereumAddress.fromHex(sdkProvider!.getSdkImpl.evmAddress ?? ''))
    //       .then((value) {
    //         print("value ${value.getValueInUnit(EtherUnit.ether)}");
    //         element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
    //       });
    //     }
    //   }
    // }
    notifyListeners();

  }

  /// 2
  Future<void> sortAsset() async {
    
    sortListContract = await _walletUsecases.sortCoins( sortListContract!, addedCoin: addedContract);

    print("After sort $sortListContract");

    notifyListeners();
  }

}