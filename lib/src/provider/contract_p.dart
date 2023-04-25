import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallet_apps/src/constants/asset_path.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/service/contract.dart';
import 'package:wallet_apps/src/service/native.dart';
import 'package:web_socket_channel/io.dart';
import '../../index.dart';

class ContractProvider with ChangeNotifier {

  // Get From App.dart global context
  BuildContext? context;

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

  String? _dir;

  // To Get Member Variable
  ApiProvider apiProvider = ApiProvider();
  MarketProvider? _marketProvider;

  /// (0 SEL Token), (1 SEL V1), (2 SEL V2), (3 KIWIGO), (4 ETH), (5 BNB)
  /// 
  /// (6 DOT), (7 BTC), (8 RekReay), (9 ATT)
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
  Web3Client get ethClient => _etherClient!;

  String get getEtherAddress => ethAdd;
  
  double mainBalance = 0.0;

  double totalAmount = 0.0;
  
  final AppConfig _appConfig = AppConfig();

  Future<void> initBep20Service(String contractAddress) async {
    final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, contractAddress);
    _bep20 = ContractService(_bscClient!, contract);
  }

  Future<void> initErc20Service(String contractAddress) async {
    final contract = await AppUtils.contractfromAssets(AppConfig.erc20Abi, contractAddress);
    _erc20 = ContractService(_etherClient!, contract);
  }

  EthereumAddress getEthAddr(String address) => EthereumAddress.fromHex(address);

  ContractProvider(){
    sortListContract.clear();
    listContract.clear();
    initSwapContract();
    if (listContract.isEmpty){
      initJson();
    }
  }

  /// Fetch Support Contract From Json Inside Asset
  /// 
  /// Run First 
  Future<void> initJson() async {

    _dir = (await getApplicationDocumentsDirectory()).path;

    try {
      
      // True In Case First Time Initialize
      await setSavedList().then((value) async {

        final json = await rootBundle.loadString(AssetPath.contractJson);
        
        final decode = jsonDecode(json);

        sortListContract.clear();
        listContract.clear();
      
        for (int i = 0 ; i < decode.length; i++){

          listContract.add(
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
              listActivity: [],
              lineChartModel: LineChartModel(values: List<FlSpot>.empty(growable: true)),
            )
          );
        }

        await StorageServices.storeData(SmartContractModel.encode(listContract), DbKey.listContract);
        
        notifyListeners();
      });

    } catch (e) {

      if (kDebugMode) {
        debugPrint("Error initJson $e");
      }
    }
  }

  void setSELNativeAddr(String addr){
    listContract[apiProvider.selNativeIndex].address = addr;
    notifyListeners();
  }

  void setDotAddr(String addr, int chainDecimal){
    listContract[apiProvider.dotIndex].address = addr;
    listContract[apiProvider.dotIndex].chainDecimal = chainDecimal;
  }


  Future<bool> setSavedList() async {

    listContract.clear();

    print("Start setSavedList");

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
    print("finish setSavedList");
          
      return listContract.isNotEmpty ? true : false;
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Error setSavedList $e");
        }
      
    }
    return false;
  }

  Future<void> initBscClient() async {

    try {

      _httpClient = Client();
      _bscClient = Web3Client( ApiProvider().isMainnet ? AppConfig.networkList[3].httpUrlMN! : AppConfig.networkList[3].httpUrlTN!, _httpClient!, socketConnector: () {
        return IOWebSocketChannel.connect(AppConfig.networkList[3].wsUrlMN!).cast<String>();
      });
    } catch (e){
      
        if (kDebugMode) {
          debugPrint("Error initBscClient $e");
        }
      
    }

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
    final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, _appConfig.swapAddr);
    _swap = ContractService(_bscClient!, contract);
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
      
        if (kDebugMode) {
          debugPrint("Err addListActivity $e");
        }
      
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
      
        if (kDebugMode) {
          debugPrint("Err updateNativeTxStt $e");
        }
      
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
      
        if (kDebugMode) {
          debugPrint("Err updateTxStt $e");
        }
      
    }
  }

  Future<void> kgoTokenWallet() async {

    debugPrint("ethAdd $ethAdd");
    
    if (apiProvider.isMainnet){
      
      try {

        await initBscClient();
        
        final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, listContract[apiProvider.kgoIndex].contract!);
        
        //final contract = await initBsc(listContract[2].address);
        _kgo = ContractService(_bscClient!, contract);

        dynamic balance = await _kgo!.getTokenBalance(getEthAddr(ethAdd));

        final chainDecimal = await _kgo!.getChainDecimal();

        listContract[apiProvider.kgoIndex].balance = Fmt.bigIntToDouble(
          balance,
          int.parse(chainDecimal.toString()),
        ).toString();


        listContract[apiProvider.kgoIndex].chainDecimal = chainDecimal.toInt();
        listContract[apiProvider.kgoIndex].lineChartModel = LineChartModel().prepareGraphChart(listContract[apiProvider.kgoIndex]);
        listContract[apiProvider.kgoIndex].address = ethAdd;

        notifyListeners();
      } catch (e) {
        
          if (kDebugMode) {
            debugPrint("Err kgoTokenWallet $e");
          }
        
      }
    }
  }

  Future<void> getBep20Balance({required int contractIndex}) async {

    if (apiProvider.isMainnet){
      try {

        await initBscClient();
        final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, apiProvider.isMainnet ? listContract[contractIndex].contract! : listContract[contractIndex].contractTest!);
        
        _conService = ContractService(_bscClient!, contract);
        final balance = await _conService!.getTokenBalance(getEthAddr(ethAdd));
        final chainDecimal = await _conService!.getChainDecimal();

        listContract[contractIndex].balance = Fmt.bigIntToDouble(
          balance,
          int.parse(chainDecimal.toString()),
        ).toString();

        listContract[contractIndex].chainDecimal = chainDecimal.toInt();
        listContract[contractIndex].lineChartModel = LineChartModel().prepareGraphChart(listContract[contractIndex]);
        listContract[contractIndex].address = ethAdd;

        notifyListeners();
      } catch (e) {
        
          if (kDebugMode) {
            debugPrint("Err getBep20Balance $e");
          }
        
      }
    }
  }

  Future<void> ethWallet() async {
    debugPrint("ethWallet");
    try {

      await initEtherClient();
      debugPrint("finish initEtherClient");
      _eth = NativeService(_etherClient!);

      debugPrint("ethAdd $ethAdd");

      final balance = await _eth!.getBalance(getEthAddr(ethAdd));
      
      debugPrint("balance $balance");

      listContract[apiProvider.ethIndex].balance = balance.toString();
      listContract[apiProvider.ethIndex].chainDecimal = 18;
      listContract[apiProvider.ethIndex].lineChartModel = LineChartModel().prepareGraphChart(listContract[apiProvider.ethIndex]);
      listContract[apiProvider.ethIndex].address = ethAdd;

      debugPrint("listContract[apiProvider.ethIndex].address ${listContract[apiProvider.ethIndex].address}");

      notifyListeners();
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Err ethWallet $e");
        }
      
    }
  }

  Future<void> bnbWallet() async {
    try {

      await initBscClient();
      
      _bnb = NativeService(_bscClient!);

      final balance = await _bnb!.getBalance(getEthAddr(ethAdd));
      listContract[apiProvider.bnbIndex].balance = balance.toString();
      listContract[apiProvider.bnbIndex].chainDecimal = 18;
      listContract[apiProvider.bnbIndex].lineChartModel = LineChartModel().prepareGraphChart(listContract[apiProvider.bnbIndex]);
      listContract[apiProvider.bnbIndex].address = ethAdd;
      notifyListeners();
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Error bnbWallet $e");
        }
      
    }
  }

  // Sort Asset Portoflio
  Future? sortAsset() async {
    print("Start sortAsset");
    try {

      mainBalance = 0;
      sortListContract.clear();
      
      // await StorageServices.fetchData(DbKey.hdWallet).then((value) {
      //   listContract[apiProvider.btcIndex].address = value;
      // });

      print("finish fetch market");
      
      // 1. Add Default Asset First
      for (var element in listContract) {
        if (element.show! && element.id != "polkadot"){
          
          if (element.marketPrice!.isNotEmpty) {
            element.money = double.parse(element.balance!.replaceAll(",", "")) * double.parse(element.marketPrice!);
          } else {
            element.money = 0.0;
          }

          mainBalance = mainBalance + element.money!;//double.parse(element.balance!.replaceAll(",", ""));
          sortListContract.addAll({element});
        } 
      }

      // 2. Add Imported Asset
      for (var element in addedContract) {
        if (element.marketPrice!.isNotEmpty) {
          element.money = double.parse(element.balance!.replaceAll(",", "")) * double.parse(element.marketPrice!);
        } else {
          element.money = 0.0;
        }
        mainBalance = mainBalance + element.money!;
        sortListContract.addAll({element});
        
      }

      // Sort Descending
      if (sortListContract.isNotEmpty) {

        tmp = SmartContractModel();
        for (int i = 1; i < sortListContract.length; i++) {

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
      
        if (kDebugMode) {
          debugPrint("Error sortAsset $e");
        }
      
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
    //     //   (value) => {debugPrint('cancel'), streamSubscriptionBsc.cancel()},
    //     // );

    //     // await Provider.of<MarketProvider>(context, listen: false).fetchTokenMarketPrice(context);
    //     // await Provider.of<WalletProvider>(context, listen: false).fillWithMarketData(context);
    //     debugPrint("Done");
    //   });
    // } catch (e) {
    //   debugPrint(e.message);
    // }
  }

  Future<void> isBtcContain(ApiProvider apiPro, BuildContext context) async {

    final res = await StorageServices.fetchData(DbKey.bech32);

    if (res != null) {
      apiPro.isBtcAvailable('contain', context: context);

      // apiPro.setBtcAddr(res.toString());
      Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
      // await apiPro.getBtcBalance(res.toString(), context: context);
    }
  }

  // Future<void> addBtcWallet() async {
  //   debugPrint("addBtcWallet");
  //   try {
  //     final seed = bip39.mnemonicToSeed(widget.passPhrase);
  //     final hdWallet = HDWallet.fromSeed(seed);
  //     final keyPair = ECPair.fromWIF(hdWallet.wif!);

  //     final bech32Address = new P2WPKH(data: new PaymentData(pubkey: keyPair.publicKey), network: bitcoin).data!.address;
  //     debugPrint("bech32Address $bech32Address");
  //     await StorageServices.storeData(bech32Address, 'bech32');

  //     final res = await ApiProvider().encryptPrivateKey(hdWallet.wif!, _userInfoM.confirmPasswordCon.text);

  //     await StorageServices.writeSecure('btcwif', res);

  //     Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain', context: context);

  //     Provider.of<ApiProvider>(context, listen: false).setBtcAddr(bech32Address!);
  //     Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
  //     await Provider.of<ApiProvider>(context, listen: false).getBtcBalance(hdWallet.address!, context: context);

  //   } catch (e) {
  //     debugPrint("Error addBtcWallet $e");
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
    //   debugPrint(e.message);
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
      if (kDebugMode) {
        debugPrint("Err initBsc $e");
      }
    }
    return null;
  }

  Future<bool> validateEvmAddr(String address) async {
    debugPrint("validateEvmAddr $address");
    bool isValid = false;
    try {
      EthereumAddress.fromHex(address);
      isValid = true;
    } on ArgumentError {
      // Not valid
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Err validateEvmAddr $e");
        }
      
    }
    return isValid;
  }

  Future<void> getBtcMaxGas() async {}

  Future<EtherAmount?> getEthGasPrice() async {
    EtherAmount? gasPrice;
    try {

      await initEtherClient();
      gasPrice = await _etherClient!.getGasPrice();
    } catch (e){

      
        if (kDebugMode) {
          debugPrint("Error getEthGasPrice $e");
        }
      
    }
    return gasPrice;
  }

  Future<String> getBnbMaxGas(String reciever, String amount) async {
    await initBscClient();
    final ethAddr = await StorageServices.readSecure(DbKey.ethAddr);

    final maxGas = await _bscClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr!),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );

    return maxGas.toString();
  }

  Future<String> getEthMaxGas(String reciever, String amount, {int chainID = 18}) async {

    debugPrint("receiver $reciever");
    debugPrint("amount $amount");
    await initEtherClient();

    // final ethAddr = await StorageServices.readSecure(DbKey.ethAddr);

    final maxGas = await _etherClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAdd),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, chainID))),
    );
    return maxGas.toString();
  }

  Future<String> getErc20MaxGas(String contractAddr, String reciever, String amount, {required int decimal}) async {
    await initBscClient();

    final erc20Contract = await AppUtils.contractfromAssets(AppConfig.erc20Abi, contractAddr);
    final ethAddr = await StorageServices.readSecure(DbKey.ethAddr);
    final txFunction = erc20Contract.function('transfer');

    final maxGas = await _etherClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr!),
      to: erc20Contract.address,
      // maxPriorityFeePerGas: EtherAmount.inWei(BigInt.from(100)),
      //gasPrice: EtherAmount.inWei(BigInt.parse('20')),
      data: txFunction.encodeCall(
        [
          EthereumAddress.fromHex(reciever),
          BigInt.from(double.parse(amount) * pow(10, decimal))
        ],
      ),
    );

    return maxGas.toString();
  }

  Future<String> getBep20MaxGas(String contractAddr, String reciever, String amount, {required int decimal}) async {
    await initBscClient();

    final bep20Contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, contractAddr);
    final ethAddr = await StorageServices.readSecure(DbKey.ethAddr);
    final txFunction = bep20Contract.function('transfer');

    debugPrint("bep20Contract.address ${bep20Contract.address}");

    final maxGas = await _bscClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr!),
      to: EthereumAddress.fromHex(reciever),//bep20Contract.address,
      // maxPriorityFeePerGas: EtherAmount.inWei(BigInt.from(100)),
      //gasPrice: EtherAmount.inWei(BigInt.parse('20')),
      data: txFunction.encodeCall(
        [
          EthereumAddress.fromHex(reciever),
          BigInt.from(double.parse(amount) * pow(10, decimal))
        ],
      ),
    );

    return maxGas.toString();
  }

  Future<EtherAmount?> getErc20GasPrice() async {
    EtherAmount? gasPrice;
    try {

      await initEtherClient();
      gasPrice = await _etherClient!.getGasPrice();
    } catch (e){

      
        if (kDebugMode) {
          debugPrint("Error getErc20GasPrice $e");
        }
      
    }

    return gasPrice;
  }

  Future<EtherAmount?> getBscGasPrice() async {
    
    EtherAmount? gasPrice;
    try {

      await initBscClient();
      gasPrice = await _bscClient!.getGasPrice();
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Error getBscGasPrice $e");
        }
      
    }

    return gasPrice;
  }

  Future<String> swap(String amount, String privateKey) async {
    try {

      await initBscClient();
      final contract = await initSwapSel(_appConfig.swapAddr);

      final ethAddr = await StorageServices.readSecure(DbKey.ethAddr);

      final gasPrice = await _bscClient!.getGasPrice();

      final ethFunction = contract.function('swap');

      final credentials = EthPrivateKey.fromHex(privateKey);//_bscClient!.credentialsFromPrivateKey(privateKey);

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
      
        if (kDebugMode) {
          debugPrint("Error swap $e");
        }
      
      throw Exception(e);
    }
  }

  Future<List?> queryEther(String contractAddress, String functionName, List args) async {
    
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

  /// Extract Address From PK and Assign to EthAdd Variable
  Future<void> extractAddress(String privateKey) async {

    await initBscClient();
    final EthPrivateKey? credentials = EthPrivateKey.fromHex(privateKey);

    if (credentials != null) {
      debugPrint("credentials.address.toString() ${credentials.address.toString()}");
      // final addr = await credentials.extractAddress();
      ethAdd = credentials.address.toString();

      notifyListeners();
      
      debugPrint("ethAdd $ethAdd");
      await StorageServices.writeSecure(DbKey.ethAddr, credentials.address.toString());

    }
  }

  Future<void> getEtherAddr() async {
    debugPrint("getEtherAddr");
    try {

      // final ethAddr = "0xe11175d356d20b70abcec858c6b82b226e988941";
      final ethAddr = await StorageServices.readSecure(DbKey.ethAddr);
      // debugPrint("ethAddr $ethAddr");
      ethAdd = ethAddr!;

      notifyListeners();
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Error getEtherAddr $e");
        }
      
    }
  }
  Future<void> getBtcAddr() async {
    try {

      listContract[apiProvider.btcIndex].address = await StorageServices.readSecure(DbKey.bech32);
      
      notifyListeners();
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Error getEtherAddr $e");
        }
      
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
    final credentials = EthPrivateKey.fromHex(//_bscClient!.credentialsFromPrivateKey(
      privateKey.substring(2),
    );

    final ethAddr = await StorageServices.readSecure(DbKey.ethAddr);

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
    final credentials = EthPrivateKey.fromHex(//_etherClient!.credentialsFromPrivateKey(
      privateKey.substring(2),
    );

    final ethAddr = await StorageServices.readSecure(DbKey.ethAddr);

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
        value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true,
    );
    return res;
  }

  Future<String> sendTxEthCon(
    String contractAddr,
    String chainDecimal,
    String privateKey,
    String reciever,
    String amount,
    {int? decimal}
  ) async {
    await initEtherClient();
    final contract = await AppUtils.contractfromAssets(AppConfig.erc20Abi, contractAddr);
    final txFunction = contract.function('transfer');
    final credentials = EthPrivateKey.fromHex(privateKey);

    final ethAddr = await StorageServices.readSecure(DbKey.ethAddr);

    final maxGas = await _etherClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr!),
      to: EthereumAddress.fromHex(contractAddr),
      data: txFunction.encodeCall(
        [
          EthereumAddress.fromHex(reciever),
          BigInt.from(double.parse(amount) * pow(10, decimal!))
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
          BigInt.from(double.parse(amount) * pow(10, decimal))
        ],
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true,
    );

    return res;
  }

  Future<void> addToken(String symbol, BuildContext context, {String? contractAddr, String? network}) async {

    _marketProvider ??= Provider.of<MarketProvider>(context, listen: false);
    try {
        
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
            (decimal[0] as BigInt ).toInt(),
          ).toString(); 

        } else if (network == 'BSC'){
          symbol = await query(contractAddr!, 'symbol', []);
          name = await query(contractAddr, 'name', []);
          decimal = await query(contractAddr, 'decimals', []);
          balance = await query(contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);
          tmpBalance = Fmt.bigIntToDouble(
            balance[0] as BigInt,
            int.parse(decimal[0].toString()),
          ).toString();
          
        }

        SmartContractModel newContract = SmartContractModel(
          id: _marketProvider!.lsCoin!.isEmpty ? name[0] : _marketProvider!.queried!['id'],
          name: _marketProvider!.lsCoin!.isEmpty ? name[0] : _marketProvider!.queried!['name'],
          symbol: symbol[0],
          chainDecimal: (decimal[0] as BigInt ).toInt(),
          balance: tmpBalance.toString(),
          address: ethAdd,
          isContain: true,
          logo: _marketProvider!.lsCoin!.isEmpty ? '${AppConfig.assetsPath}circle.png' : _marketProvider!.queried!['image'],// AppConfig.assetsPath+'circle.png',
          listActivity: [],
          lineChartModel: LineChartModel(),
          type: '',
          org: network == 'Ethereum' ? 'ERC-20' : 'BEP-20',
          orgTest: network == 'Ethereum' ? 'ERC-20' : 'BEP-20',
          marketData: Market(),
          lineChartList: [],
          change24h: _marketProvider!.lsCoin!.isEmpty ? '0' : _marketProvider!.queried!['price_change_percentage_24h'].toString(),
          marketPrice: _marketProvider!.lsCoin!.isEmpty ? '' : _marketProvider!.queried!['current_price'].toString(),
          contract: apiProvider.isMainnet ? contractAddr: '',
          contractTest: apiProvider.isMainnet ? '' : contractAddr,
          isAdded: true
        );
        
        newContract.money = ( double.parse(tmpBalance.replaceAll(",", "")) * (_marketProvider!.lsCoin!.isNotEmpty ? _marketProvider!.queried!['price_change_percentage_24h'] : 1.0) );
        
        addedContract.add(newContract);
      }
      
      notifyListeners();
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Err addAsset $e");
        }
      
      rethrow;  
    }
  }

  // Future<void> saveAddedToken() async {
  //   debugPrint("saveAddedToken");
  //   await StorageServices.fetchData(DbKey.addedContract).then((value) async {
  //     if (value != null){
  //       List<Map<String, dynamic>> tmp = value;
  //       addedContract.forEach((element) {
  //         tmp.addAll({SmartContractModel.toMap(element)});
  //       });
  //       debugPrint("addedContract ${addedContract.toList()}");
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

  void setMarketToAsset(int index, Market market, List<List<double>> lineChart, String currentPrice, String priceChange24h) {

    print("index ${index}");
    print("index ${listContract[index].id}");
    print("market ${market}");
    print("currentPrice ${currentPrice}");
    print("priceChange24h ${priceChange24h}");
    print("lineChart ${lineChart}");

    listContract[index].marketData = market;
    listContract[index].marketPrice = currentPrice;
    listContract[index].change24h = priceChange24h;
    listContract[index].lineChartList = lineChart;

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
