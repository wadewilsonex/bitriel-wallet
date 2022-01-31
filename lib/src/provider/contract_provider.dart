import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/config/app_config.dart';
import 'package:wallet_apps/src/constants/asset_path.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/lineChart_m.dart';
import 'package:wallet_apps/src/models/token.m.dart';
import 'package:wallet_apps/src/service/contract.dart';
import 'package:wallet_apps/src/service/native.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';
import '../../index.dart';


// import 'package:bip39/bip39.dart' as bip39;
// import 'package:defichaindart/defichaindart.dart';

class ContractProvider with ChangeNotifier {

  Client? _httpClient;
  Web3Client? _bscClient, _etherClient;

  ContractService? _selToken, _selV2, _kgo, _swap, _atd, _bep20, _erc20;
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
  /// (6 DOT) (7 BTC) (8 ATT) (9 SEL Testnet)
  List<SmartContractModel> listContract = [];

  /// This property for ERC-20 and BEP-20 contract added
  /// 
  /// To Easy Manage And Refresh Balance
  List<SmartContractModel> addedContract = [];

  List<SmartContractModel> sortListContract = [];

  SmartContractModel selTestnet = SmartContractModel(
    id: 'selendra',
    logo: 'assets/SelendraCircle-White.png',
    symbol: 'SEL',
    name: "SELENDRA",
    balance: '0.0',
    org: 'Testnet',
    lineChartModel: LineChartModel()
  );

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

  Future<void> initBep20Service(String contract) async {
    final _contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, contract);
    _bep20 = ContractService(_bscClient!, _contract);
  }

  EthereumAddress getEthAddr(String address) => EthereumAddress.fromHex(address);

  ContractProvider() {
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
            address: value['address'] ?? null,
            symbol: value["symbol"],
            org: value["org"],
            isContain: value["isContain"],
            listActivity: [],
            lineChartList: value['lineChartData'],
            lineChartModel: LineChartModel(values: List<FlSpot>.empty(growable: true)),
          )
        );
      });

      // listContract.forEach((element) {
      //   print("${element.symbol} ${element.balance}");
      // });

    } catch (e) {
      print("Error initJson $e");
    }
  }

  void setSELNativeAddr(String addr){
    listContract[0].address = addr;
    sortAsset();
    notifyListeners();
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
      print("Error setSavedList $e");
    }
    return false;
  }

  Future<void> initBscClient() async {
    _httpClient = Client();
    _bscClient = Web3Client(AppConfig.networkList[3].httpUrlMN!, _httpClient!, socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.networkList[3].wsUrlMN!).cast<String>();
    });
  }

  Future<void> initEtherClient() async {
    _httpClient = Client();
    _etherClient = Web3Client(AppConfig.networkList[2].httpUrlMN!, _httpClient!,
      socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.networkList[2].wsUrlMN!).cast<String>();
    });
  }

  Future<void> initSwapContract() async {
    await initBscClient();
    final _contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, AppConfig.swapMainnetAddr);
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
      print("Err addListActivity $e");
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
      print("Err updateNativeTxStt $e");
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
      print("Err updateTxStt $e");
    }
  }

  Future<void> selTokenWallet() async {

    try {

      await initBscClient();
      final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, AppConfig.selV1MainnetAddr);//'0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030');
      //final contract = await initBsc(listContract[0].address);
      _selToken = new ContractService(_bscClient!, contract);

      final balance = await _selToken!.getTokenBalance(getEthAddr(ethAdd));

      final chainDecimal = await _selToken!.getChainDecimal();

      listContract[1].balance = Fmt.bigIntToDouble(
        balance,
        int.parse(chainDecimal.toString()),
      ).toString();

      listContract[1].chainDecimal = chainDecimal.toString();
      listContract[1].lineChartModel = LineChartModel().prepareGraphChart(listContract[1]);
      listContract[1].address = '0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030';
      
      notifyListeners();
    } catch (e) {
      print("Err selNativeTokenWallet $e");
    }
  }

  Future<void> selv2TokenWallet() async {
    try {

      await initBscClient();
      final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, AppConfig.selv2MainnetAddr);//listContract[1].address!);
      //final contract = await initBsc(listContract[1].address);
      _selV2 = new ContractService(_bscClient!, contract);

      final balance = await _selV2!.getTokenBalance(getEthAddr(ethAdd));

      final chainDecimal = await _selV2!.getChainDecimal();

      listContract[2].balance = Fmt.bigIntToDouble(
        balance,
        int.parse(chainDecimal.toString()),
      ).toString();

      listContract[2].chainDecimal = chainDecimal.toString();
      listContract[2].lineChartModel = LineChartModel().prepareGraphChart(listContract[2]); 
      listContract[2].address = '0x46bF747DeAC87b5db70096d9e88debd72D4C7f3C'; //chainDecimal.toString();
      notifyListeners();
    } catch (e) {
      print("Error selv2TokenWallet $e");
    }
  }

  Future<void> kgoTokenWallet() async {
    try {

      await initBscClient();
      final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, listContract[3].address!);
      //final contract = await initBsc(listContract[2].address);
      _kgo = new ContractService(_bscClient!, contract);

      final balance = await _kgo!.getTokenBalance(getEthAddr(ethAdd));
      final chainDecimal = await _kgo!.getChainDecimal();

      listContract[3].balance = Fmt.bigIntToDouble(
        balance,
        int.parse(chainDecimal.toString()),
      ).toString();

      listContract[3].chainDecimal = chainDecimal.toString();
      listContract[3].lineChartModel = LineChartModel().prepareGraphChart(listContract[3]);

      notifyListeners();
    } catch (e) {
      print("Err kgoTokenWallet $e");
    }
  }

  Future<void> ethWallet() async {
    
    try {

      await initEtherClient();
      _eth = new NativeService(_etherClient!);

      final balance = await _eth!.getBalance(getEthAddr(ethAdd));

      listContract[4].balance = balance.toString();
      listContract[4].lineChartModel = LineChartModel().prepareGraphChart(listContract[4]);

      notifyListeners();
    } catch (e) {
      print("Err ethWallet $e");
    }
  }

  Future<void> bnbWallet() async {
    try {

      await initBscClient();
      
      _bnb = new NativeService(_bscClient!);

      final balance = await _bnb!.getBalance(getEthAddr(ethAdd));

      listContract[5].balance = balance.toString();
      listContract[5].lineChartModel = LineChartModel().prepareGraphChart(listContract[5]);

      notifyListeners();
    } catch (e) {
      print("Error bnbWallet $e");
    }
  }

  // Sort Asset Portoflio
  Future? sortAsset() {
    try {

      sortListContract.clear();
      
      listContract.forEach((element) {
        sortListContract.addAll({element});
      });

      addedContract.forEach((element) {
        sortListContract.addAll({element});
      });

      if (sortListContract.isNotEmpty) {
        SmartContractModel tmp = SmartContractModel();
        for (int i = 0; i < sortListContract.length; i++) {
          for (int j = i + 1; j < sortListContract.length; j++) {
            tmp = sortListContract[i];
            // print('sortListContract balance ${double.parse(sortListContract[j].balance)}');
            // print('tmp balance ${double.parse(tmp.balance)}');
            if ( (double.parse(sortListContract[j].balance!)) > (double.parse(tmp.balance!)) ) {
              sortListContract[i] = sortListContract[j];
              sortListContract[j] = tmp;
            }
          }
        }

        notifyListeners();
      }

      // listContract.forEach((element) {
      //   print("${element.symbol} ${element.balance}");
      // });
      
    } catch (e) {
      print("Error sortAsset $e");
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

    final res = await StorageServices.fetchData('bech32');

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
    print('canel stream');
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
      print("Err initBsc $e");
    }
    return null;
  }

  Future<bool> validateEvmAddr(String address) async {

    bool _isValid = false;
    try {
      EthereumAddress.fromHex(address, enforceEip55: true);
      _isValid = true;
    } on ArgumentError {
      // Not valid
    } catch (e) {
      print("Err validateEvmAddr $e");
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
    final ethAddr = await StorageServices().readSecure('etherAdd');

    final maxGas = await _bscClient!.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr!),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );

    return maxGas.toString();
  }

  Future<String> getEthMaxGas(String reciever, String amount) async {
    await initEtherClient();
    final ethAddr = await StorageServices().readSecure('etherAdd');

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
    final ethAddr = await StorageServices().readSecure('etherAdd');

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
      print("Error getBscGasPrice $e");
    }

  }

  Future<String> approveSwap(String privateKey) async {
    try {

      await initBscClient();
      final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, listContract[0].address!);
      // final contract = await initBsc(listContract[0].address);
      final ethFunction = contract.function('approve');

      final credentials = await EthPrivateKey.fromHex(privateKey);//_bscClient!.credentialsFromPrivateKey(privateKey);
      final ethAddr = await StorageServices().readSecure('etherAdd');

      final gasPrice = await _bscClient!.getGasPrice();

      final maxGas = await _bscClient!.estimateGas(
        sender: EthereumAddress.fromHex(ethAddr!),
        to: contract.address,
        data: ethFunction.encodeCall(
          [
            EthereumAddress.fromHex(AppConfig.swapMainnetAddr),
            BigInt.parse('1000000000000000042420637374017961984'),
          ],
        ),
      );
      print("maxGas $maxGas");

      final approve = await _bscClient!.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          gasPrice: gasPrice,
          maxGas: maxGas.toInt(),
          parameters: [
            EthereumAddress.fromHex(AppConfig.swapMainnetAddr),
            BigInt.parse('1000000000000000042420637374017961984'),
          ],
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );

      return approve;
    } catch (e) {
      print("Error approveSwap $e");
    }
    return '';
  }

  Future<dynamic> checkAllowance() async {
    try {

      final ethAddr = await StorageServices().readSecure('etherAdd');
      final res = await query(
        '0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030',//listContract[0].address!,
        'allowance',
        [
          EthereumAddress.fromHex(ethAddr!),
          EthereumAddress.fromHex(AppConfig.swapMainnetAddr)
        ],
      );

      return res.first;
    } catch (e) {
      print("Error checkAllowance $e");
    }
  }

  Future<String> swap(String amount, String privateKey) async {
    try {

      await initBscClient();
      final contract = await initSwapSel(AppConfig.swapMainnetAddr);

      final ethAddr = await StorageServices().readSecure('etherAdd');

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
      print("Error swap $e");
    }
    return '';
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
      print("Error queryEther $e");
    }
    return null;
  }

  Future<List> query(String contractAddress, String functionName, List args) async {

    try {
      await initBscClient();
      final contract = await AppUtils.contractfromAssets(AppConfig.bep20Abi, contractAddress);
      // final contract = await initBsc(contractAddress);
      final ethFunction = contract.function(functionName);

      final res = await _bscClient!.call(
        contract: contract,
        function: ethFunction,
        params: args,
      );
      return res;
    } catch (e) {
      print("Error query $e");
    }
    return [];
  }

  Future<void> extractAddress(String privateKey) async {

    await initBscClient();
    final EthPrivateKey? credentials = await EthPrivateKey.fromHex(privateKey);

    if (credentials != null) {
      final addr = await credentials.extractAddress();
      ethAdd = addr.toString();
      await StorageServices().writeSecure('etherAdd', addr.toString());
    }
  }

  Future<void> getEtherAddr() async {
    try {

      final ethAddr = await StorageServices().readSecure('etherAdd');
      ethAdd = ethAddr!;

      notifyListeners();
    } catch (e) {
      print("Error getEtherAddr $e");
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

    final ethAddr = await StorageServices().readSecure('etherAdd');

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

    // print("Res $res");

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

    final ethAddr = await StorageServices().readSecure('etherAdd');

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

  //   final ethAddr = await StorageServices().readSecure('etherAdd');

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

    final ethAddr = await StorageServices().readSecure('etherAdd');

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

            symbol = await query(contractAddr!, 'symbol', []);
            name = await query(contractAddr, 'name', []);
            decimal = await query(contractAddr, 'decimals', []);
            balance = await query(contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

            tmpBalance = Fmt.bigIntToDouble(
              balance[0] as BigInt,
              int.parse(decimal[0].toString()),
            ).toString();
            
          }

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

          SmartContractModel newContract = SmartContractModel(
            id: name[0].toLowerCase(),
            name: name[0],
            symbol: symbol[0],
            address: contractAddr!,
            org: network == 'Ethereum' ? 'ERC-20' : 'BEP-20',
            isContain: true,
            logo: 'assets/circle.png',
            chainDecimal: decimal[0].toString(),
            listActivity: [],
            balance: tmpBalance.toString(),
            lineChartModel: LineChartModel(),
          );
          
          newContract.lineChartModel = LineChartModel().prepareGraphChart(newContract);
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
          
          addedContract.add(newContract);
        }
      // }
      
      notifyListeners();
    } catch (e) {
      print("Err addAsset $e");
    }
  }

  Future<void> addContractToken(TokenModel tokenModel) async {
    token!.add(tokenModel);
    notifyListeners();
  }

  Future<void> removeEtherToken(String symbol, BuildContext context) async {
    final String? mContractAddr = findContractAddr(symbol);
    if (mContractAddr != null) {
      await StorageServices.removeEthContractAddr(mContractAddr);
      token!.removeWhere(
        (element) => element.symbol!.toLowerCase().startsWith(symbol.toLowerCase()),
      );

      Provider.of<WalletProvider>(context, listen: false).removeTokenSymbol(symbol);
    }
    notifyListeners();
  }

  Future<void> removeToken(String symbol, BuildContext context) async {
    if (symbol == 'SEL') {
      listContract[0].isContain = false;
      await StorageServices.removeKey('SEL');
    } else if (symbol == 'BNB') {
      listContract[4].isContain = false;
      await StorageServices.removeKey('BNB');
    } else if (symbol == 'DOT') {
      await StorageServices.removeKey('DOT');
      // Provider.of<ApiProvider>(context, listen: false).dotIsNotContain();
    } else {
      final mContractAddr = findContractAddr(symbol);
      await StorageServices.removeContractAddr(mContractAddr);
      token!.removeWhere(
        (element) => element.symbol!.toLowerCase().startsWith(
              symbol.toLowerCase(),
            ),
      );
    }
    if (symbol == 'SEL') {
      Provider.of<WalletProvider>(context, listen: false)
          .removeTokenSymbol("$symbol (BEP-20)");
    } else {
      Provider.of<WalletProvider>(context, listen: false)
          .removeTokenSymbol(symbol);
    }
    notifyListeners();
  }

  String findContractAddr(String symbol) {
    final item = sortListContract.firstWhere((element) => element.symbol!.toLowerCase().startsWith(
        symbol.toLowerCase(),
      ),
    );

    print("findContractAddr ${item.address}");
    return item.address!;
  }

  void setkiwigoMarket(Market kgoMarket, List<List<double>> lineChart, String currentPrice, String priceChange24h) {
    listContract[3].marketData = kgoMarket;
    listContract[3].lineChartList = lineChart;
    listContract[3].marketPrice = currentPrice;
    listContract[3].change24h = priceChange24h;

    notifyListeners();
  }

  void setEtherMarket(Market ethMarket, List<List<double>> lineChart, String currentPrice, String priceChange24h) {
    listContract[4].marketData = ethMarket;
    listContract[4].marketPrice = currentPrice;
    listContract[4].change24h = priceChange24h;
    listContract[4].lineChartList = lineChart;

    notifyListeners();
  }

  void setBnbMarket(Market bnbMarket, List<List<double>> lineChart, String currentPrice, String priceChange24h) {
    listContract[5].marketData = bnbMarket;
    listContract[5].marketPrice = currentPrice;
    listContract[5].change24h = priceChange24h;
    listContract[5].lineChartList = lineChart;

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
    print("Logout");
    initJson();
    notifyListeners();
  }
}
