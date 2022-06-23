import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wallet_apps/src/constants/asset_path.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/service/contract.dart';
import 'package:wallet_apps/src/service/native.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import '../../index.dart';


// import 'package:bip39/bip39.dart' as bip39;
// import 'package:defichaindart/defichaindart.dart';

class ContractProvider with ChangeNotifier {

  Client? _httpClient;
  Web3Client? _bscClient, _etherClient;

  ContractService? _selToken, _selV2, _kgo, _swap, _atd, _bep20, _erc20, _conService;
  NativeService? _eth, _bnb;

  StreamSubscription<String>? streamSubscriptionBsc;
  Stream<String>? stream;

  List<TokenModel>? token = [];

  String ethAdd = '';
  bool? std;

  bool isReady = false;

  // To Get Member Variable
  ApiProvider apiProvider = ApiProvider();

  /// (0 SEL Token) (1 SEL V1) (2 SEL V2) (3 KIWIGO) (4 ETH) (5 BNB)
  /// 
  /// (6 DOT) (7 BTC) (8 RekReay) (9 ATT)
  List<SmartContractModel> listContract = [];

  /// This property for ERC-20 and BEP-20 contract added
  /// 
  /// To Easy Manage And Refresh Balance
  List<SmartContractModel> addedContract = [];

  List<SmartContractModel> sortListContract = [];

  SmartContractModel? tmp;

  int mainDecimal = 18;

  ContractService get getSelToken => _selToken!;
  ContractService get getSelv2 => _selV2!;
  ContractService get getKgo => _kgo!;
  ContractService get getSwap => _swap!;
  ContractService get getAtd => _atd!;
  ContractService get getBep20 => _bep20!;
  ContractService get getErc20 => _erc20!;

  NativeService get getBnb => _bnb!;
  NativeService get getEth => _eth!;

  Web3Client get bscClient => _bscClient!;
  
  double mainBalance = 0.0;

  double totalAmount = 0.0;
  
  AppConfig _appConfig = AppConfig();

  Future<void> initBep20Service(String contract) async {
    final _contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, contract);
    _bep20 = ContractService(_bscClient!, _contract);
  }

  EthereumAddress getEthAddr(String address) => EthereumAddress.fromHex(address);

  ContractProvider(){
    initSwapContract();
    initJson();
  }


  /// Fetch Support Contract From Json Inside Asset
  /// 
  /// Run First 
  void initJson() async {
    try {

      final json = await rootBundle.loadString(AssetPath.contractJson);
      final decode = jsonDecode(json);
      
      listContract.clear();
      
      decode.forEach((value){
        listContract.add(
          SmartContractModel(
            id: value['id'],
            name: value["name"],
            logo: value["logo"],
            address: value['address'],
            contract: value['contract'],
            contractTest: value['contract_test'],
            symbol: value["symbol"],
            org: value["org"],
            orgTest: value["org_test"],
            isContain: value["isContain"],
            balance: value["balance"],
            show: value["show"],
            listActivity: [],
            lineChartList: value['lineChartData'],
            lineChartModel: LineChartModel(values: List<FlSpot>.empty(growable: true)),
          )
        );
      });

      notifyListeners();

    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error initJson $e");
    }
  }

  void setSELNativeAddr(String addr){
    listContract[apiProvider.selNativeIndex].address = addr;
    notifyListeners();
  }

  void setDotAddr(String addr, String chainDecimal){
    listContract[apiProvider.dotIndex].address = addr;
    listContract[apiProvider.dotIndex].chainDecimal = chainDecimal;
  }

  Future<bool> setSavedList() async {
    try {

      await StorageServices.fetchAsset(DbKey.listContract).then((value) {
        if (value != null) {
          listContract = List<SmartContractModel>.from(value);
        }
      });

      await StorageServices.fetchAsset(DbKey.addedContract).then((value) {
        if (value != null) {
          addedContract = List<SmartContractModel>.from(value);
        }
      });
      notifyListeners();
          
      return true;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error setSavedList $e");
    }
    return false;
  }

  Future<void> initBscClient() async {
    _httpClient = Client();
    _bscClient = Web3Client( ApiProvider().isMainnet ? AppConfig.networkList[3].httpUrlMN! : AppConfig.networkList[3].httpUrlTN!, _httpClient!, socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.networkList[3].wsUrlMN!).cast<String>();
    });
  }

  Future<void> initEtherClient() async {
    _httpClient = Client();
    _etherClient = Web3Client(ApiProvider().isMainnet ? AppConfig.networkList[2].httpUrlMN! : AppConfig.networkList[2].httpUrlTN!, _httpClient!,
      socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.networkList[2].wsUrlMN!).cast<String>();
    });
  }

  Future<void> initSwapContract() async {
    await initBscClient();
    final _contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, _appConfig.swapAddr);
    _swap = new ContractService(_bscClient!, _contract);
  }

  Future<void> addListActivity(TransactionInfo info, int index, {ContractService? contractService, NativeService? nativeService}) async {
    listContract[index].listActivity = [];
    try {
      listContract[index].listActivity!.add(info);

      if (contractService != null) {
        await updateTxStt(contractService, info, index);
      }

      if (nativeService != null) {
        await updateNativeTxStt(nativeService, info, index);
      }

      notifyListeners();
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err addListActivity $e");
    }
  }

  Future<void> updateNativeTxStt(NativeService nativeService, TransactionInfo info, int index) async {
    try {

      await nativeService.listenTransfer(info.hash!)!.then((value) {
        var item = listContract[index].listActivity!.firstWhere((element) => element.hash == info.hash);
        item.status = value;
      });

      notifyListeners();
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err updateNativeTxStt $e");
    }
  }

  Future<void> updateTxStt(ContractService contractService, TransactionInfo info, int index) async {
    try {

      await contractService.listenTransfer(info.hash!)!.then((value) {
        var item = listContract[index].listActivity!.firstWhere((element) => element.hash == info.hash);
        item.status = value;
      });

      notifyListeners();
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err updateTxStt $e");
    }
  }

  Future<void> selTokenWallet(BuildContext context) async {
    try {

      await initBscClient();
      final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, apiProvider.isMainnet ? listContract[apiProvider.selV1Index].contract! : listContract[apiProvider.selV1Index].contractTest! );//'0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030');
      //final contract = await initBsc(listContract[0].address);
      _selToken = new ContractService(_bscClient!, contract);
      final balance = await _selToken!.getTokenBalance(getEthAddr(ethAdd));

      final chainDecimal = await _selToken!.getChainDecimal();

      listContract[apiProvider.selV1Index].balance = Fmt.bigIntToDouble(
        balance,
        chainDecimal.toInt(),
      ).toString();

      listContract[apiProvider.selV1Index].chainDecimal = chainDecimal.toString();
      listContract[apiProvider.selV1Index].lineChartModel = LineChartModel().prepareGraphChart(listContract[apiProvider.selV1Index]);
      listContract[apiProvider.selV1Index].address = ethAdd;//'0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030';
      
      notifyListeners();
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err selTokenWallet $e");
    }
  }

  Future<void> selv2TokenWallet(BuildContext context) async {
    try {

      await initBscClient();
      final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, apiProvider.isMainnet ? listContract[apiProvider.selV2Index].contract! : listContract[apiProvider.selV2Index].contractTest!);//listContract[1].address!);
      //final contract = await initBsc(listContract[1].address);
      _selV2 = new ContractService(_bscClient!, contract);

      final balance = await _selV2!.getTokenBalance(getEthAddr(ethAdd));

      final chainDecimal = await _selV2!.getChainDecimal();

      listContract[apiProvider.selV2Index].balance = Fmt.bigIntToDouble(
        balance,
        int.parse(chainDecimal.toString()),
      ).toString();

      listContract[apiProvider.selV2Index].chainDecimal = chainDecimal.toString();
      listContract[apiProvider.selV2Index].lineChartModel = LineChartModel().prepareGraphChart(listContract[apiProvider.selV2Index]); 
      listContract[apiProvider.selV2Index].address = ethAdd;//'0x46bF747DeAC87b5db70096d9e88debd72D4C7f3C'; //chainDecimal.toString();
      notifyListeners();
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error selv2TokenWallet $e");
    }
  }

  Future<void> kgoTokenWallet() async {
    if (apiProvider.isMainnet){
      try {

        await initBscClient();
        final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, apiProvider.isMainnet ? listContract[apiProvider.kgoIndex].contract! : listContract[apiProvider.kgoIndex].contractTest!);
        //final contract = await initBsc(listContract[2].address);
        _kgo = new ContractService(_bscClient!, contract);

        final balance = await _kgo!.getTokenBalance(getEthAddr(ethAdd));
        final chainDecimal = await _kgo!.getChainDecimal();

        listContract[apiProvider.kgoIndex].balance = Fmt.bigIntToDouble(
          balance,
          int.parse(chainDecimal.toString()),
        ).toString();

        listContract[apiProvider.kgoIndex].chainDecimal = chainDecimal.toString();
        listContract[apiProvider.kgoIndex].lineChartModel = LineChartModel().prepareGraphChart(listContract[apiProvider.kgoIndex]);
        listContract[apiProvider.kgoIndex].address = ethAdd;

        notifyListeners();
      } catch (e) {
        if (ApiProvider().isDebug == true) print("Err kgoTokenWallet $e");
      }
    }
  }

  Future<void> getBep20Balance({required int contractIndex}) async {
    print("getBep20Balance");
    if (apiProvider.isMainnet){
      try {

        await initBscClient();
        final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, apiProvider.isMainnet ? listContract[contractIndex].contract! : listContract[contractIndex].contractTest!);
        
        _conService = new ContractService(_bscClient!, contract);
        final balance = await _conService!.getTokenBalance(getEthAddr(ethAdd));
        print("balance $balance");
        final chainDecimal = await _conService!.getChainDecimal();
        print("chainDecimal $chainDecimal");

        listContract[contractIndex].balance = Fmt.bigIntToDouble(
          balance,
          int.parse(chainDecimal.toString()),
        ).toString();

        listContract[contractIndex].chainDecimal = chainDecimal.toString();
        listContract[contractIndex].lineChartModel = LineChartModel().prepareGraphChart(listContract[contractIndex]);
        listContract[contractIndex].address = ethAdd;

        notifyListeners();
      } catch (e) {
        if (ApiProvider().isDebug == true) print("Err getBep20Balance $e");
      }
    }
  }

  Future<void> ethWallet() async {
    
    try {

      await initEtherClient();
      _eth = new NativeService(_etherClient!);

      final balance = await _eth!.getBalance(getEthAddr(ethAdd));

      listContract[apiProvider.ethIndex].balance = balance.toString();
      listContract[apiProvider.ethIndex].lineChartModel = LineChartModel().prepareGraphChart(listContract[apiProvider.ethIndex]);
      listContract[apiProvider.ethIndex].address = ethAdd;

      notifyListeners();
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err ethWallet $e");
    }
  }

  Future<void> bnbWallet() async {
    try {

      await initBscClient();
      
      _bnb = new NativeService(_bscClient!);

      final balance = await _bnb!.getBalance(getEthAddr(ethAdd));

      listContract[apiProvider.bnbIndex].balance = balance.toString();
      listContract[apiProvider.bnbIndex].lineChartModel = LineChartModel().prepareGraphChart(listContract[apiProvider.bnbIndex]);
      listContract[apiProvider.bnbIndex].address = ethAdd;
      notifyListeners();
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error bnbWallet $e");
    }
  }

  // Sort Asset Portoflio
  Future? sortAsset() async {
    try {

      mainBalance = 0;
      sortListContract.clear();
      
      await StorageServices.fetchData(DbKey.hdWallet).then((value) {
        listContract[apiProvider.btcIndex].address = value;
      });
      
      // 1. Add Default Asset First
      listContract.forEach((element) {
        // if (element.show!) 
        // print("element.balance! ${element.balance!}");
        if (element.marketPrice!.isNotEmpty) element.money = double.parse(element.balance!.replaceAll(",", "")) * double.parse(element.marketPrice!);
        else element.money = 0.0;
        mainBalance = mainBalance + element.money!;//double.parse(element.balance!.replaceAll(",", ""));
        sortListContract.addAll({element});
      });

      // 2. Add Imported Asset
      addedContract.forEach((element) {
        // print("symbol ${element.symbol}");
        // print("id ${element.id}");
        // print("address ${element.address}");
        // print("symbol ${element.symbol}");
        // print("balance ${element.balance}");
        // print("type ${element.type}");
        // print("logo ${element.logo}");
        // print("org ${element.org}");
        // print("orgTest ${element.orgTest}");
        // print("marketData ${element.marketData}");
        // print("lineChartList ${element.lineChartList}");
        // print("change24h ${element.change24h}");
        // print("marketPrice ${element.marketPrice}");
        // print("name ${element.name}");
        // print("chainDecimal ${element.chainDecimal}");
        // print("contract ${element.contract}");
        // print("contractTest ${element.contractTest}");
        // print("lineChartModel ${element.lineChartModel}!");
        // if (element.show!) 
        // print("value.balance!.replaceAll(',', '') ${value.replaceAll(",", "")}");
        if (element.marketPrice!.isNotEmpty) element.money = double.parse(element.balance!.replaceAll(",", "")) * double.parse(element.marketPrice!);
        else element.money = 0.0;
        mainBalance = mainBalance + element.money!;// + double.parse(element.balance!.replaceAll(",", ""));
        sortListContract.addAll({element});
      });

      // Sort Descending
      if (sortListContract.isNotEmpty) {

        tmp = new SmartContractModel();
        for (int i = 0; i < sortListContract.length; i++) {
          // if (sortListContract[i].balance!.contains(",")) {
          //   sortListContract[i].balance = sortListContract[i].balance!.replaceAll(",", "");
          // } 

          for (int j = i + 1; j < sortListContract.length; j++) {
            tmp = sortListContract[i];
            if ( (double.parse(sortListContract[j].balance!.replaceAll(",", ""))) > (double.parse(sortListContract[i].balance!.replaceAll(",", ""))) ) {
              sortListContract[i] = sortListContract[j];
              sortListContract[j] = tmp!;
            }
          }
        }

      }
      notifyListeners();
      
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error sortAsset $e");
    }
    
    return null;
  }

  Future<void> subscribeBscbalance(BuildContext context) async {
    // await initBscClient();
    // final apiPro = Provider.of<ApiProvider>(context, listen: false);
    // try {
    //   stream = _bscClient.addedBlocks();

    //   streamSubscriptionBsc = stream.listen((event) async {
    //     await getBscBalance();
    //     await SBalance();
    //     await getBnbBalance();
    //     await Provider.of<ContractProvider>(context, listen: false)
    //         .getKgoDecimal()
    //         .then((value) async {
    //       await Provider.of<ContractProvider>(context, listen: false)
    //           .getKgoBalance();
    //     });

    //     await isBtcContain(apiPro, context);

    //     await apiPro.getDotChainDecimal();
    //     // await Future.delayed(const Duration(milliseconds: 5000)).then(
    //     //   (value) => {print('cancel'), streamSubscriptionBsc.cancel()},
    //     // );

    //     // await Provider.of<MarketProvider>(context, listen: false).fetchTokenMarketPrice(context);
    //     // await Provider.of<WalletProvider>(context, listen: false).fillWithMarketData(context);
    //     print("Done");
    //   });
    // } catch (e) {
    //   print(e.message);
    // }
  }

  Future<void> isBtcContain(ApiProvider apiPro, BuildContext context) async {

    final res = await StorageServices.fetchData(DbKey.bech32);

    if (res != null) {
      apiPro.isBtcAvailable('contain', context: context);

      apiPro.setBtcAddr(res.toString());
      Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
      // await apiPro.getBtcBalance(res.toString(), context: context);
    }
  }

  // Future<void> addBtcWallet() async {
  //   print("addBtcWallet");
  //   try {
  //     final seed = bip39.mnemonicToSeed(widget.passPhrase);
  //     final hdWallet = HDWallet.fromSeed(seed);
  //     final keyPair = ECPair.fromWIF(hdWallet.wif!);

  //     final bech32Address = new P2WPKH(data: new PaymentData(pubkey: keyPair.publicKey), network: bitcoin).data!.address;
  //     print("bech32Address $bech32Address");
  //     await StorageServices.storeData(bech32Address, 'bech32');

  //     final res = await ApiProvider().encryptPrivateKey(hdWallet.wif!, _userInfoM.confirmPasswordCon.text);

  //     await StorageServices().writeSecure('btcwif', res);

  //     Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain', context: context);

  //     Provider.of<ApiProvider>(context, listen: false).setBtcAddr(bech32Address!);
  //     Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
  //     await Provider.of<ApiProvider>(context, listen: false).getBtcBalance(hdWallet.address!, context: context);

  //   } catch (e) {
  //     print("Error addBtcWallet $e");
  //   }
  // }

  Future<void> subscribeEthbalance() async {
    // await initEtherClient();
    // try {
    //   var res = _etherClient.addedBlocks();

    //   streamSubscriptionEth = res.listen((event) {
    //     getEtherBalance();
    //   });
    // } catch (e) {
    //   print(e.message);
    // }
    // notifyListeners();
  }

  void unsubscribeNetwork() async {
    await streamSubscriptionBsc!.cancel();

    //await streamSubscriptionEth.cancel();
    notifyListeners();
  }

  Future<DeployedContract> initSwapSel(String contractAddr) async {
    final String abiCode = await rootBundle.loadString('assets/abi/swap.json');
    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, 'Swap'),
      EthereumAddress.fromHex(contractAddr),
    );

    return contract;
  }

  Future<DeployedContract?> initBsc(String contractAddr) async {
    try {

      final String abiCode = await rootBundle.loadString('assets/abi/abi.json');
      final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'BEP-20'),
        EthereumAddress.fromHex(contractAddr),
      );

      return contract;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err initBsc $e");
    }
    return null;
  }

  Future<bool> validateEvmAddr(String address) async {

    bool _isValid = false;
    try {
      EthereumAddress.fromHex(address);
      _isValid = true;
    } on ArgumentError {
      // Not valid
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err validateEvmAddr $e");
    }
    return _isValid;
  }

  Future<EtherAmount> getEthGasPrice() async {
    await initEtherClient();
    final gasPrice = await _etherClient!.getGasPrice();
    return gasPrice;
  }

  Future<void> getBtcMaxGas() async {}

  Future<String> getBnbMaxGas(String reciever, String amount) async {
    await initBscClient();
    final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);

    final maxGas = await _bscClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr!),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );

    return maxGas.toString();
  }

  Future<String> getEthMaxGas(String reciever, String amount) async {
    await initEtherClient();
    final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);

    final maxGas = await _etherClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr!),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );
    return maxGas.toString();
  }

  Future<String> getBep20MaxGas(String contractAddr, String reciever, String amount) async {
    await initBscClient();
    final bep20Contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, contractAddr);
    final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);

    final txFunction = bep20Contract.function('transfer');

    final maxGas = await _bscClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr!),
      to: bep20Contract.address,
      //gasPrice: EtherAmount.inWei(BigInt.parse('20')),
      data: txFunction.encodeCall(
        [
          EthereumAddress.fromHex(reciever),
          BigInt.from(double.parse(amount) * pow(10, 18))
        ],
      ),
    );

    // print(getSelToken.getMaxGas(
    //     EthereumAddress.fromHex(ethAddr),
    //     TransactionInfo(
    //         receiver: EthereumAddress.fromHex(reciever), amount: amount)));

    return maxGas.toString();
  }

  Future<EtherAmount?> getBscGasPrice() async {

    try {

      await initBscClient();
      final gasPrice = await _bscClient!.getGasPrice();
      return gasPrice;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error getBscGasPrice $e");
    }

  }

  Future<String> approveSwap(String privateKey) async {

    try {

      await initBscClient();
      final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, listContract[apiProvider.selV1Index].address!);
      // final contract = await initBsc(listContract[0].address);
      final ethFunction = contract.function('approve');

      final credentials = await EthPrivateKey.fromHex(privateKey);//_bscClient!.credentialsFromPrivateKey(privateKey);
      final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);

      final gasPrice = await _bscClient!.getGasPrice();

      final maxGas = await _bscClient!.estimateGas(
        sender: EthereumAddress.fromHex(ethAddr!),
        to: contract.address,
        data: ethFunction.encodeCall(
          [
            EthereumAddress.fromHex(_appConfig.swapAddr),
            BigInt.parse('1000000000000000042420637374017961984'),
          ],
        ),
      );

      final approve = await _bscClient!.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          gasPrice: gasPrice,
          maxGas: maxGas.toInt(),
          parameters: [
            EthereumAddress.fromHex(_appConfig.swapAddr),
            BigInt.parse('1000000000000000042420637374017961984'),
          ],
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );

      return approve;
    } catch (e) {
      if (ApiProvider().isDebug) print("Error approveSwap $e");
      // return e.toString();
      throw new Exception(e);
    }
  }

  Future<dynamic> checkAllowance() async {
    try {

      final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);
      final res = await query(
        apiProvider.isMainnet ? listContract[apiProvider.selV1Index].contract! : listContract[apiProvider.selV1Index].contractTest!,
        'allowance',
        [
          EthereumAddress.fromHex(ethAddr!),
          EthereumAddress.fromHex(_appConfig.swapAddr)
        ],
      );

      return res.first;
    } catch (e) {
      if (ApiProvider().isDebug) print("Error checkAllowance $e");
      throw new Exception(e);
    }
  }

  Future<String> swap(String amount, String privateKey) async {
    try {

      await initBscClient();
      final contract = await initSwapSel(_appConfig.swapAddr);

      final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);

      final gasPrice = await _bscClient!.getGasPrice();

      final ethFunction = contract.function('swap');

      final credentials = await EthPrivateKey.fromHex(privateKey);//_bscClient!.credentialsFromPrivateKey(privateKey);

      final maxGas = await _bscClient!.estimateGas(
        sender: EthereumAddress.fromHex(ethAddr!),
        to: contract.address,
        data: ethFunction.encodeCall([BigInt.from(double.parse(amount) * pow(10, 18))]),
      );

      final swap = await _bscClient!.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          from: EthereumAddress.fromHex(ethAddr),
          function: ethFunction,
          gasPrice: gasPrice,
          maxGas: maxGas.toInt(),
          parameters: [BigInt.from(double.parse(amount) * pow(10, 18))],
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );

      return swap;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error swap $e");
      throw new Exception(e);
    }
  }

  Future<List?> queryEther(String contractAddress, String functionName, List args) async {
    try {

      await initEtherClient();
      final contract = await AppUtils.contractfromAssets(AppConfig.erc20Abi, contractAddress);
      //final contract = await initEtherContract(contractAddress);

      final ethFunction = contract.function(functionName);

      final res = await _etherClient!.call(
        contract: contract,
        function: ethFunction,
        params: args,
      );

      return res;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error queryEther $e");
    }
    return null;
  }

  Future<List> query(String contractAddress, String functionName, List args) async {
    await initBscClient();
    final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, contractAddress);
    // final contract = await initBsc(contractAddress);
    final function = contract.function(functionName);

    final res = await _bscClient!.call(
      contract: contract,
      function: function,
      params: args,
    );
    return res;
  }

  Future<void> extractAddress(String privateKey) async {

    await initBscClient();
    final EthPrivateKey? credentials = await EthPrivateKey.fromHex(privateKey);

    if (credentials != null) {
      final addr = await credentials.extractAddress();
      ethAdd = addr.toString();
      await StorageServices().writeSecure(DbKey.ethAddr, addr.toString());
    }
  }

  Future<void> getEtherAddr() async {
    try {

      final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);
      ethAdd = ethAddr!;

      notifyListeners();
    } catch (e) {
      if (ApiProvider().isDebug) print("Error getEtherAddr $e");
    }
  }

  Future<void> fetchNonBalance() async {
    await initBscClient();
    for (int i = 0; i < token!.length; i++) {
      if (token![i].org == 'ERC-20') {
        final contractAddr = findContractAddr(token![i].symbol!);
        final decimal = await query(contractAddr, 'decimals', []);

        final balance = await query(contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

        token![i].balance = Fmt.bigIntToDouble(
          balance[0] as BigInt,
          int.parse(decimal[0].toString()),
        ).toString();
      }
    }

    notifyListeners();
  }

  Future<void> fetchEtherNonBalance() async {
    await initEtherClient();
    for (int i = 0; i < token!.length; i++) {
      if (token![i].org == 'ERC-20') {
        final contractAddr = findContractAddr(token![i].symbol!);

        final decimal = await queryEther(contractAddr, 'decimals', []);

        final balance = await queryEther(
            contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

        token![i].balance = Fmt.bigIntToDouble(
          balance![0] as BigInt,
          int.parse(decimal![0].toString()),
        ).toString();
      }
    }

    notifyListeners();
  }

  Future<String> sendTxBnb(
    String privateKey,
    String reciever,
    String amount,
  ) async {
    initBscClient();
    final credentials = await EthPrivateKey.fromHex(//_bscClient!.credentialsFromPrivateKey(
      privateKey.substring(2),
    );

    final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);

    final maxGas = await _bscClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr!),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );

    final res = await _bscClient!.sendTransaction(
      credentials,
      Transaction(
        maxGas: maxGas.toInt(),
        to: EthereumAddress.fromHex(reciever),
        value: EtherAmount.inWei(
          BigInt.from(double.parse(amount) * pow(10, 18)),
        ),
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true,
    );

    return res;
  }

  Future<String> sendTxEther(
    String privateKey,
    String reciever,
    String amount,
  ) async {
    initEtherClient();
    final credentials = await EthPrivateKey.fromHex(//_etherClient!.credentialsFromPrivateKey(
      privateKey.substring(2),
    );

    final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);

    final maxGas = await _etherClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr!),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );

    final res = await _etherClient!.sendTransaction(
      credentials,
      Transaction(
        maxGas: maxGas.toInt(),
        to: EthereumAddress.fromHex(reciever),
        value:
            EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true,
    );
    return res;
  }

  // Future<String> sendTxBsc(
  //   String contractAddr,
  //   String chainDecimal,
  //   String privateKey,
  //   String reciever,
  //   String amount,
  // ) async {
  //   initBscClient();
  //   final contract =
  //       await AppUtils.contractfromAssets(AppConfig.bep20Path, contractAddr);
  //   // final contract = await initBsc(contractAddr);
  //   final txFunction = contract.function('transfer');
  //   final credentials = await _bscClient.credentialsFromPrivateKey(privateKey);

  //   final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);

  //   final maxGas = await _bscClient.estimateGas(
  //     sender: EthereumAddress.fromHex(ethAddr),
  //     to: EthereumAddress.fromHex(contractAddr),
  //     data: txFunction.encodeCall(
  //       [
  //         EthereumAddress.fromHex(reciever),
  //         BigInt.from(double.parse(amount) * pow(10, 18))
  //       ],
  //     ),
  //   );

  //   final res = await _bscClient.sendTransaction(
  //     credentials,
  //     Transaction.callContract(
  //       contract: contract,
  //       function: txFunction,
  //       maxGas: maxGas.toInt(),
  //       parameters: [
  //         EthereumAddress.fromHex(reciever),
  //         BigInt.from(double.parse(amount) * pow(10, 18))
  //       ],
  //     ),
  //     fetchChainIdFromNetworkId: true,
  //   );

  //   return res;
  // }

  Future<String> sendTxEthCon(
    String contractAddr,
    String chainDecimal,
    String privateKey,
    String reciever,
    String amount,
  ) async {
    await initEtherClient();
    final contract = await AppUtils.contractfromAssets(AppConfig.erc20Abi, contractAddr);
    //final contract = await initEtherContract(contractAddr);
    final txFunction = contract.function('transfer');
    final credentials = await EthPrivateKey.fromHex(privateKey);//_etherClient!.credentialsFromPrivateKey(privateKey);

    final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);

    final maxGas = await _etherClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr!),
      to: EthereumAddress.fromHex(contractAddr),
      data: txFunction.encodeCall(
        [
          EthereumAddress.fromHex(reciever),
          BigInt.from(double.parse(amount) * pow(10, 18))
        ],
      ),
    );

    final res = await _etherClient!.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: txFunction,
        maxGas: maxGas.toInt(),
        parameters: [
          EthereumAddress.fromHex(reciever),
          BigInt.from(double.parse(amount) * pow(10, 18))
        ],
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true,
    );

    return res;
  }

  Future<void> addToken(String symbol, BuildContext context, {String? contractAddr, String? network}) async {
    
    try {

      // if (symbol == 'SEL') {
        
      //   if (!listContract[0].isContain!) {
      //     listContract[0].isContain = true;

      //     await StorageServices.saveBool('SEL', true);

      //     Provider.of<WalletProvider>(context, listen: false).addTokenSymbol("$symbol (BEP-20)");

      //   }
      // } else if (symbol == 'BNB') {

      //   if (!listContract[4].isContain!) {
      //     listContract[4].isContain = true;

      //     await StorageServices.saveBool('BNB', true);

      //     Provider.of<WalletProvider>(context, listen: false).addTokenSymbol(symbol);

      //     // await getBscDecimal();
      //     // await getBnbBalance();

      //     listContract[4].lineChartModel = LineChartModel().prepareGraphChart(listContract[0]);
      //   }
      // } else if (symbol == 'DOT') {
      //   if (!listContract[5].isContain!) {
          
      //     await StorageServices.saveBool('DOT', true);

      //     await Provider.of<ApiProvider>(context, listen: false).connectPolNon(context: context);
      //     //Provider.of<ApiProvider>(context, listen: false).isDotContain();
      //     Provider.of<WalletProvider>(context, listen: false).addTokenSymbol(symbol);
      //   }
      // } else if (symbol == 'KGO') {
      //   if (!listContract[5].isContain!) {

      //     Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('KGO (BEP-20)');
      //     // await Provider.of<ContractProvider>(context, listen: false)
      //     //     .getKgoSymbol();
      //     // await Provider.of<ContractProvider>(context, listen: false)
      //     //     .getKgoDecimal()
      //     //     .then((value) async {
      //     //   await Provider.of<ContractProvider>(context, listen: false)
      //     //       .getKgoBalance();
      //     // });
      //   }
      // } else {
        
        if (network != null) {
          
          dynamic symbol;
          dynamic name;
          dynamic decimal;
          dynamic balance;
          dynamic tmpBalance;

          if (network == 'Ethereum'){
            
            symbol = await queryEther(contractAddr!, 'symbol', []);
            name = await queryEther(contractAddr, 'name', []);
            decimal = await queryEther(contractAddr, 'decimals', []);
            balance = await queryEther(contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

            tmpBalance = Fmt.bigIntToDouble(
              balance[0] as BigInt,
              int.parse(decimal[0].toString()),
            ).toString(); 

          } else if (network == 'Binance Smart Chain'){
            print("Query info bep-20 contract");
            symbol = await query(contractAddr!, 'symbol', []);
            name = await query(contractAddr, 'name', []);
            decimal = await query(contractAddr, 'decimals', []);
            balance = await query(contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);
            print("Decimal $decimal");
            tmpBalance = Fmt.bigIntToDouble(
              balance[0] as BigInt,
              int.parse(decimal[0].toString()),
            ).toString();
            
          }
          print("name $name");
          print("symbol $symbol");
          print("finish query");

          // if (network == 'Ethereum') {

          //   final TokenModel mToken = TokenModel();

          //   mToken.symbol = symbol.first.toString();
          //   mToken.decimal = decimal.first.toString();
          //   mToken.balance = balance.first.toString();
          //   mToken.contractAddr = contractAddr;
          //   mToken.org = 'ERC-20';

          //   if (token.isEmpty) {
          //     await addContractToken(mToken);

          //     await StorageServices.saveEthContractAddr(contractAddr);
          //     Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('${symbol[0]} (ERC-20)');
          //   }

          //   if (token.isNotEmpty) {
          //     if (!token.contains(mToken)) {
          //       addContractToken(mToken);

          //       await StorageServices.saveEthContractAddr(contractAddr);
          //       Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('${symbol[0]} (ERC-20)');
          //     }
          //   }
          // } else {
          //   print("symbol ${symbol[0]}");
          //   print("name ${name[0]}");
          //   print("decimal ${decimal[0]}");
          //   print("balance ${balance[0]}");

          //   // if (token.isNotEmpty) {
          //   //   final TokenModel item = token.firstWhere(
          //   //     (element) => element.symbol.toLowerCase() == symbol[0].toString().toLowerCase(), orElse: () => null
          //   //   );

          //   //   if (item == null) {
          //   //     await addContractToken(
          //   //       TokenModel(
          //   //         contractAddr: contractAddr,
          //   //         decimal: decimal[0].toString(),
          //   //         symbol: symbol[0].toString(),
          //   //         balance: balance[0].toString(),
          //   //         org: 'BEP-20',
          //   //       ),
          //   //     );

          //   //     await StorageServices.saveContractAddr(contractAddr);
          //   //     Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('${symbol[0]} (BEP-20)');
          //   //   }
          //   // } else {
          //   //   token.add(
          //   //     TokenModel(
          //   //       contractAddr: contractAddr,
          //   //       decimal: decimal[0].toString(),
          //   //       symbol: symbol[0].toString(),
          //   //       balance: balance[0].toString(),
          //   //       org: 'BEP-20'
          //   //     ),
          //   //   );

          //   //   await StorageServices.saveContractAddr(contractAddr);
          //   //   Provider.of<WalletProvider>(context, listen: false).addTokenSymbol(symbol[0].toString());
          //   // }
          // }

          // SmartContractModel newContract = SmartContractModel(
          //   id: name[0].toLowerCase(),
          //   name: name[0].toLowerCase(),
          //   symbol: symbol[0],
          //   chainDecimal: decimal[0].toString(),
          //   balance: tmpBalance.toString(),
          //   address: ethAdd,
          //   isContain: true,
          //   logo: AppConfig.assetsPath+'circle.png',
          //   listActivity: [],
          //   lineChartModel: LineChartModel(),
          //   type: '',
          //   org: network == 'Ethereum' ? 'ERC-20' : 'BEP-20',
          //   orgTest: network == 'Ethereum' ? 'ERC-20' : 'BEP-20',
          //   marketData: Market(),
          //   lineChartList: [],
          //   change24h: '',
          //   marketPrice: '',
          //   contract: apiProvider.isMainnet ? contractAddr: '',
          //   contractTest: apiProvider.isMainnet ? '' : contractAddr,
          // );

          // Provider.of<MarketProvider>(context, listen: false).id.add(newContract.id!);
          // await Provider.of<MarketProvider>(context, listen: false).queryCoinFromMarket(newContract.id!).then((value){
            
          //   print(value);
          // });
          // print("newContract.marketPrice ${newContract.marketPrice}");
          // newContract.lineChartModel = LineChartModel().prepareGraphChart(newContract);
          // print(newContract.id);
          // print(newContract.name);
          // print(newContract.symbol);
          // print(newContract.address);
          // print(newContract.org);
          // print(newContract.isContain);
          // print(newContract.logo);
          // print(newContract.chainDecimal);
          // print(newContract.listActivity);
          // print(newContract.balance);
          // print(newContract.lineChartModel);
          
          // addedContract.add(newContract);
        }
      // }
      
      notifyListeners();
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err addAsset $e");
      throw e;  
    }
  }

  // Future<void> saveAddedToken() async {
  //   print("saveAddedToken");
  //   await StorageServices.fetchData(DbKey.addedContract).then((value) async {
  //     if (value != null){
  //       List<Map<String, dynamic>> tmp = value;
  //       addedContract.forEach((element) {
  //         tmp.addAll({SmartContractModel.toMap(element)});
  //       });
  //       print("addedContract ${addedContract.toList()}");
  //       await StorageServices.storeData(tmp, DbKey.addedContract);
  //     }
  //   });
  // }

  Future<void> addContractToken(TokenModel tokenModel) async {
    token!.add(tokenModel);
    notifyListeners();
  }

  String findContractAddr(String symbol) {
    final item = sortListContract.firstWhere((element) => element.symbol!.toLowerCase().startsWith(
        symbol.toLowerCase(),
      ),
    );

    return item.address!;
  }

  void setkiwigoMarket(Market kgoMarket, List<List<double>> lineChart, String currentPrice, String priceChange24h) {
    listContract[apiProvider.kgoIndex].marketData = kgoMarket;
    listContract[apiProvider.kgoIndex].lineChartList = lineChart;
    listContract[apiProvider.kgoIndex].marketPrice = currentPrice;
    listContract[apiProvider.kgoIndex].change24h = priceChange24h;

    notifyListeners();
  }

  void setEtherMarket(Market ethMarket, List<List<double>> lineChart, String currentPrice, String priceChange24h) {
    listContract[apiProvider.ethIndex].marketData = ethMarket;
    listContract[apiProvider.ethIndex].marketPrice = currentPrice;
    listContract[apiProvider.ethIndex].change24h = priceChange24h;
    listContract[apiProvider.ethIndex].lineChartList = lineChart;

    notifyListeners();
  }

  void setBnbMarket(Market bnbMarket, List<List<double>> lineChart, String currentPrice, String priceChange24h) {
    listContract[apiProvider.bnbIndex].marketData = bnbMarket;
    listContract[apiProvider.bnbIndex].marketPrice = currentPrice;
    listContract[apiProvider.bnbIndex].change24h = priceChange24h;
    listContract[apiProvider.bnbIndex].lineChartList = lineChart;

    notifyListeners();
  }

  void setReady() {
    isReady = true;
    notifyListeners();
  }

  void resetConObject() {
    token!.clear();
    sortListContract.clear();
    listContract.clear();
    addedContract.clear();
    initJson();
    notifyListeners();
  }
}
