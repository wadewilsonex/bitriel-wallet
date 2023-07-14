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

  set setBuildContext(BuildContext ctx) => _context = ctx;

  /// 1
  /// 
  /// Get Asset and Sort Asset
  Future<void> getAsset() async {
    
    await _walletUsecases.fetchCoinsFromLocalStorage().then((value) {
      defaultListContract = value[0];
      addedContract = value[1];
    });

    await SecureStorage.writeData(key: DbKey.listContract, encodeValue: json.encode(SmartContractModel.encode(defaultListContract!)) );

    // 0
    assetsFilter();
    // await sortAsset();

    // 2
    await queryEvmBalance();
    // await queryCoinsBalance();
  }

  void assetsFilter() async {

    listEvmNative!.clear();

    defaultListContract!.map((element) {
      
      if (element.isBSC! || element.isEther!) {listEvmNative!.add(element);}
      /// Native include, such as: Polkadot, Substrate and Bitcoin.
      else if (element.isNative!) {listNative!.add(element);}
      else if (element.isBep20!) {listBep20!.add(element);} 
      else if (element.isErc20!) {listErc20!.add(element);} 

    });
  }

  /// 2
  Future<void> sortAsset() async {
    
    sortListContract = await _walletUsecases.sortCoins(defaultListContract!);

    // notifyListeners();
  }


  Future<void> queryNativeBalance() async {
    
    sdkProvier ??= Provider.of<SDKProvier>(_context!, listen: false).getSdkProvider;
    // Filter EVM Coins
    for(var element in listNative!){
      
      // await sdkProvier!.getWeb3Balance(element.isBSC! ? sdkProvier!.getBscClient : sdkProvier!.getEthClient, EthereumAddress.fromHex(sdkProvier!.evmAddress ?? '')).then((value) {
      //   print("${element.symbol} value ${value.getValueInUnit(EtherUnit.ether)}");
      //   element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
      // });
    }
    
  }

  Future<void> queryEvmBalance() async {
    
    sdkProvier ??= Provider.of<SDKProvier>(_context!, listen: false).getSdkProvider;
    // Filter EVM Coins
    for(var element in listEvmNative!){
      
      await sdkProvier!.getEvmBalance(element.isBSC! ? sdkProvier!.getBscClient : sdkProvier!.getEthClient, EthereumAddress.fromHex(sdkProvier!.evmAddress ?? '')).then((value) {
        print("${element.symbol} value ${value.getValueInUnit(EtherUnit.ether)}");
        element.balance = (value.getValueInUnit(EtherUnit.ether)).toString();
      });

    }

  }

  Future<void> queryBep20Balance() async {

    sdkProvier ??= Provider.of<SDKProvier>(_context!, listen: false).getSdkProvider;
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

    sdkProvier ??= Provider.of<SDKProvier>(_context!, listen: false).getSdkProvider;

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