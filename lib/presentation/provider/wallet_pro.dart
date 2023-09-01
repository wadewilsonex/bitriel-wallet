import 'dart:math';

import 'package:bitriel_wallet/index.dart';

class WalletProvider with ChangeNotifier {

  final WalletUcImpl _walletUsecases = WalletUcImpl();

  List<SmartContractModel>? defaultListContract;

  List<SmartContractModel>? listEvmNative;
  List<SmartContractModel>? listNative;
  List<SmartContractModel>? listBep20;
  List<SmartContractModel>? listErc20;
  
  List<SmartContractModel>? addedContract;
  List<SmartContractModel>? sortListContract = [];

  BuildContext? _context;

  SDKProvider? sdkProvider;
  WalletProvider? walletProvider;

  MarketUCImpl marketUCImpl = MarketUCImpl();
  
  set setBuildContext(BuildContext ctx) {
    
    _context = ctx;
    _walletUsecases.setBuilder = ctx;
    sdkProvider = Provider.of<SDKProvider>(_context!, listen: false);
    walletProvider = Provider.of<WalletProvider>(_context!, listen: false);

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

    if (defaultListContract == null || defaultListContract!.isEmpty){

      initState();
      
      try {

        await _walletUsecases.fetchCoinsFromLocalStorage().then((value) {
          defaultListContract = value[0];
          addedContract = value[1];
        });

        await SecureStorage.writeData(key: DbKey.listContract, encodeValue: json.encode(SmartContractModel.encode(defaultListContract!)) );

        if (sdkProvider!.isMainnet.value == true) {

          await assetStateManipulate();
          
        }
        else {

          await coinsTestnet();
          
        }

      } catch (e) {
        print("Error getAsset $e");
      }
    }

  }

  /// List Only EVM coins and SEL
  Future<void> coinsTestnet()async {
    print("coinsTestnet");
    
    try {
      defaultListContract!.every((element) {

        if ( (element.isBSC! || element.isEther!) && element.show == true ) {
          element.address = sdkProvider!.getSdkImpl.evmAddress!;
          listEvmNative!.add(element);
        }
        else if (element.isNative! && element.show == true && element.symbol!.toLowerCase() == "sel") {listNative!.add(element);}
        
        return true;
      });

      addedContract!.every((element) {

        element.address = sdkProvider!.getSdkImpl.evmAddress!;

        if (element.isBep20! && element.show == true) {listBep20!.add(element);} 
        else if (element.isErc20! && element.show == true) {listErc20!.add(element);} 

        return true;
      });

      await queryNativeBalance();
      await queryEvmBalance();
      await queryBep20Balance();
      await queryErc20Balance();

      sortAsset();
    } catch (e) {
      print("Error coinsTestnet $e");
    }
  }

  /// List All Support Token in Mainnet
  Future<void> assetStateManipulate() async {
    
    print("assetStateManipulate");
    // 0
    assetsFilter();

    // 1
    await queryNativeBalance();
    await queryEvmBalance();
    await queryBep20Balance();
    await queryErc20Balance();

    await sortAsset();
  }

  void assetsFilter() async {

    listEvmNative!.clear();

    defaultListContract!.every((element) {
      
      if ( (element.isBSC! || element.isEther!) && element.show == true ) {listEvmNative!.add(element);}
      /// Native include, such as: Polkadot, Substrate and Bitcoin.
      else if (element.isNative! && element.show == true) {listNative!.add(element);}
      else if (element.isBep20! && element.show == true) {listBep20!.add(element);} 
      else if (element.isErc20! && element.show == true) {listErc20!.add(element);} 

      return true;
    });

    addedContract!.every((element) {
      if (element.isBep20! && element.show == true) {listBep20!.add(element);} 
      else if (element.isErc20! && element.show == true) {listErc20!.add(element);} 

      return true;
    });

    sortListContract!.clear();
  }

  // Start Fetch Balance Each Coins

  Future<void> queryNativeBalance() async {

    // Filter EVM Coins
    for(var element in listNative!){
      
      if (element.symbol!.toLowerCase() != 'polkadot'){

        if (element.symbol!.toLowerCase() == 'btc'){

          element.address = sdkProvider!.getSdkImpl.btcAddress;
          element.balance = await _walletUsecases.getBtcBalance();

        } else {
          
          element.address = sdkProvider!.getSdkImpl.getKeyring.current.address;
          element.balance = await _walletUsecases.fetchSELAddress();
        }

        sortListContract!.add(element);
      }
      
    }

    notifyListeners();
    
  }

  Future<void> queryEvmBalance() async {

    // Filter EVM Coins
    for(var element in listEvmNative!){

      // print("element ${element.symbol}");
      await sdkProvider!.getSdkImpl.getEvmBalance(
        element.isEther! ? sdkProvider!.getSdkImpl.getEthClient : sdkProvider!.getSdkImpl.getBscClient,
        // sdkProvider!.getSdkImpl.getBscClient, 
        EthereumAddress.fromHex(sdkProvider!.getSdkImpl.evmAddress ?? '')
      ).then((value) {
        element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
      });

      element.address = sdkProvider!.getSdkImpl.evmAddress;

      sortListContract!.add(element);
      
    }
    
    notifyListeners();

  }

  Future<void> queryBep20Balance() async {

    print("queryBep20Balance");
    try {
      for( var bep20 in listBep20!){

        print("bep20.symbol ${bep20.symbol}");
        print("bep20.symbol ${bep20.address}");

        sdkProvider!.getSdkImpl.bscDeployedContract = await sdkProvider!.getSdkImpl.deployContract("assets/json/abi/bep20.json", bep20.contract!);
        if (bep20.symbol!.toLowerCase() == "usdt" && sdkProvider!.isMainnet.value == true){

          bep20.address = sdkProvider!.getSdkImpl.evmAddress;

          await _walletUsecases.getContractBalance(sdkProvider!.getSdkImpl.getBscClient, sdkProvider!.getSdkImpl.bscDeployedContract!, sdkProvider!.getSdkImpl.evmAddress ).then((value) {
            
            print("Blanace ${bep20.balance}");
            bep20.address = sdkProvider!.getSdkImpl.evmAddress;
            bep20.balance = (value[0] / BigInt.from(pow(10, bep20.chainDecimal ?? 18 ))).toString();
          });
          
        }
        else {
          await _walletUsecases.getContractBalance(sdkProvider!.getSdkImpl.getBscClient, sdkProvider!.getSdkImpl.bscDeployedContract!, sdkProvider!.getSdkImpl.evmAddress).then((value) {
            bep20.balance = (value[0] / BigInt.from(pow(10, bep20.chainDecimal! ))).toString();
          });
        }

        walletProvider!.marketUCImpl.lstMarket.value.every((mkData) {
          if (mkData.symbol == bep20.symbol){
            print("mkData.symbol == element.symbol ${mkData.symbol == bep20.symbol}");
            bep20.marketPrice = mkData.price.toString();
            return true;
          }
          return false;
        });

        bep20.address = sdkProvider!.getSdkImpl.evmAddress;

        print("balance ${bep20.balance}");

        sortListContract!.add(bep20);
      }

      notifyListeners();
    } catch (e) {
      print("Error queryBep20Balance $e");
    }

  }

  Future<void> queryErc20Balance() async {

    for( var erc20 in listErc20!){

      sdkProvider!.getSdkImpl.etherDeployedContract = await sdkProvider!.getSdkImpl.deployContract("assets/json/abi/erc20.json", erc20.contract!);
      
      if (erc20.symbol!.toLowerCase() == "usdt"){
        
        erc20.balance = (await _walletUsecases.getContractBalance(sdkProvider!.getSdkImpl.getEthClient, sdkProvider!.getSdkImpl.etherDeployedContract!, sdkProvider!.getSdkImpl.evmAddress))[0].toString();

      }
      else {
        erc20.balance = (await _walletUsecases.getContractBalance(sdkProvider!.getSdkImpl.getEthClient, sdkProvider!.getSdkImpl.etherDeployedContract!, sdkProvider!.getSdkImpl.evmAddress))[0].toString();
      }
        
      erc20.address = sdkProvider!.getSdkImpl.evmAddress;
      
      sortListContract!.add(erc20);

    }
    notifyListeners();

  }

  /// 2
  Future<void> sortAsset() async {
    
    sortListContract = await _walletUsecases.sortCoins(sortListContract!, addedCoin: addedContract);

    for (var element in sortListContract!) {

      walletProvider!.marketUCImpl.lstMarket.value.every((mkData) {
        print("mkData.symbol ${mkData.symbol}");
        print("element.symbol ${element.symbol}");
        if (mkData.symbol == element.symbol){
          print("mkData.symbol == element.symbol ${mkData.symbol == element.symbol}");
          element.marketPrice = mkData.price.toString();
          return false;
        }
        return true;
      });
    }

    notifyListeners();
  }

  Future<void> storeAssets() async {
    
    await SecureStorage.writeData(key: DbKey.listContract, encodeValue: json.encode(SmartContractModel.encode(defaultListContract!)) );
    await SecureStorage.writeData(key: DbKey.addedContract, encodeValue: json.encode(SmartContractModel.encode(addedContract!)) );
  }

}