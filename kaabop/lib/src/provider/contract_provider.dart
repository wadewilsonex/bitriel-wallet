import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/config/app_config.dart';
import 'package:wallet_apps/src/models/lineChart_m.dart';
import 'package:wallet_apps/src/models/token.m.dart';
import 'package:wallet_apps/src/service/contract.dart';
import 'package:wallet_apps/src/service/native.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';
import '../../index.dart';

class ContractProvider with ChangeNotifier {
  Client _httpClient;
  Web3Client _bscClient, _etherClient;

  ContractService _selToken, _selV2, _kgo, _swap;
  NativeService _eth, _bnb;

  StreamSubscription<String> streamSubscriptionBsc;
  Stream<String> stream;

  List<TokenModel> token = [];

  final WalletSDK sdk = ApiProvider.sdk;

  final Keyring keyring = ApiProvider.keyring;

  String ethAdd = '';
  bool std;

  bool isReady = false;

  // To Get Member Variable
  ApiProvider apiProvider = ApiProvider();

  List<SmartContractModel> savedAssetList = [];

  List<SmartContractModel> listContract = [
    // (0 SEL V1) (1 SEL V2) (2 KIWIGO) (3 ETH) (4 BNB)
    SmartContractModel(
      id: 'selendra',
      address: '0x288d3A87a87C284Ed685E0490E5C4cC0883a060a',
      logo: 'assets/SelendraCircle-Blue.png',
      symbol: 'SEL',
      org: 'BEP-20',
      isContain: true,
      listActivity: [],
      lineChartModel: LineChartModel(),
    ),
    // SEL V2
    SmartContractModel(
      id: 'selendra v2',
      address: '0x30bAb6B88dB781129c6a4e9B7926738e3314Cf1C',
      logo: 'assets/SelendraCircle-Blue.png',
      symbol: 'SEL (v2)',
      org: 'BEP-20',
      isContain: true,
      listActivity: [],
      lineChartModel: LineChartModel(),
    ),
    // KIWIGO
    SmartContractModel(
      id: 'kiwigo',
      address: '0x5d3AfBA1924aD748776E4Ca62213BF7acf39d773',
      logo: 'assets/Kiwi-GO-White-1.png',
      symbol: 'KGO',
      org: 'BEP-20',
      isContain: true,
      listActivity: [],
      lineChartModel: LineChartModel(),
    ),
    // Ethereum
    SmartContractModel(
      id: 'ethereum',
      logo: 'assets/eth.png',
      symbol: 'ETH',
      org: '',
      isContain: true,
      listActivity: [],
      lineChartModel: LineChartModel(),
    ),
    //BNB
    SmartContractModel(
      id: 'binance smart chain',
      logo: 'assets/bnb.png',
      symbol: 'BNB',
      org: 'Smart Chain',
      isContain: true,
      listActivity: [],
      lineChartModel: LineChartModel(),
    ),
  ];

  List<SmartContractModel> sortListContract = [];

  ContractService get getSelToken => _selToken;
  ContractService get getSelv2 => _selV2;
  ContractService get getKgo => _kgo;
  ContractService get getSwap => _swap;

  NativeService get bnb => _bnb;
  NativeService get eth => _eth;

  EthereumAddress getEthAddr(String address) =>
      EthereumAddress.fromHex(address);

  ContractProvider() {
    initSwapContract();
  }

  Future<void> setSavedList() async {
    final saved = await StorageServices.fetchAsset('assetData');

    savedAssetList = List.from(saved);

    print('my symbol: ${savedAssetList[0].symbol}');

    notifyListeners();
  }

  Future<void> initBscClient() async {
    _httpClient = Client();
    _bscClient = Web3Client(AppConfig.networkList[3].httpUrlTN, _httpClient,
        socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.networkList[3].wsUrlMN)
          .cast<String>();
    });
  }

  Future<void> initEtherClient() async {
    _httpClient = Client();
    _etherClient = Web3Client(AppConfig.networkList[2].httpUrlMN, _httpClient,
        socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.networkList[2].wsUrlMN)
          .cast<String>();
    });
  }

  Future<void> initSwapContract() async {
    await initBscClient();
    print('initSwap Contract');
    final _contract = await AppUtils.contractfromAssets(AppConfig.bep20Path, "0xE5DD12570452057fc85B8cE9820aD676390f865B");
    _swap = new ContractService(_bscClient, _contract);
  }

  Future<void> selTokenWallet() async {
    print('selToken');
    await initBscClient();
    print(AppConfig.bep20Path);
    print('contract address ${listContract[0].address}');
    print('contract address ${listContract[0].logo}');
    final contract = await AppUtils.contractfromAssets(
        AppConfig.bep20Path, '0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030');

    print('CONTRACT ADDRESS ${contract.address}');
    //final contract = await initBsc(listContract[0].address);
    _selToken = new ContractService(_bscClient, contract);

    //print(contract.address);

    print('my eth addr $ethAdd');

    final balance = await _selToken.getTokenBalance(getEthAddr(ethAdd));

    print('selToken: $balance');

    final chainDecimal = await _selToken.getChainDecimal();

    listContract[0].balance = Fmt.bigIntToDouble(
      balance,
      int.parse(chainDecimal.toString()),
    ).toString();

    listContract[0].chainDecimal = chainDecimal.toString();
    notifyListeners();
  }

  Future<void> selv2TokenWallet() async {
    // await initBscClient();
    // final contract = await AppUtils.contractfromAssets(
    //     AppConfig.bep20Path, listContract[1].address);
    // //final contract = await initBsc(listContract[1].address);
    // _selV2 = new ContractService(_bscClient, contract);

    // final balance = await _selV2.getTokenBalance(getEthAddr(ethAdd));
    // print('selV2: $balance');

    // final chainDecimal = await _selV2.getChainDecimal();

    listContract[1].balance = '0';

    // listContract[1].balance = Fmt.bigIntToDouble(
    //   balance,
    //   int.parse(chainDecimal.toString()),
    // ).toString();

    listContract[1].chainDecimal = '18'; //chainDecimal.toString();
    // notifyListeners();
  }

  void addListActivity(TransactionInfo info, int index,
      {ContractService contractService, NativeService nativeService}) async {
    listContract[index].listActivity.add(info);

    print('add to list activity');

    if (contractService != null) {
      await updateTxStt(contractService, info, index);
    }

    if (nativeService != null) {
      print('update native network');
      await updateNativeTxStt(nativeService, info, index);
    }

    notifyListeners();
  }

  Future<void> updateNativeTxStt(
      NativeService nativeService, TransactionInfo info, int index) async {
    await nativeService.listenTransfer(info.hash).then((value) {
      print('Stt: $value');
      var item = listContract[index]
          .listActivity
          .firstWhere((element) => element.hash == info.hash);
      item.status = value;
    });

    notifyListeners();
  }

  Future<void> updateTxStt(
      ContractService contractService, TransactionInfo info, int index) async {
    await contractService.listenTransfer(info.hash).then((value) {
      print('Stt: $value');
      var item = listContract[index]
          .listActivity
          .firstWhere((element) => element.hash == info.hash);
      item.status = value;
    });

    notifyListeners();
  }

  Future<void> kgoTokenWallet() async {
    // await initBscClient();
    // final contract = await AppUtils.contractfromAssets(
    //     AppConfig.bep20Path, listContract[2].address);
    // //final contract = await initBsc(listContract[2].address);
    // _kgo = new ContractService(_bscClient, contract);

    // final balance = await _kgo.getTokenBalance(getEthAddr(ethAdd));
    // print('kgo: $balance');
    // final chainDecimal = await _kgo.getChainDecimal();

    // listContract[2].balance = Fmt.bigIntToDouble(
    //   balance,
    //   int.parse(chainDecimal.toString()),
    // ).toString();

    listContract[2].balance = '0';

    listContract[2].chainDecimal = '18'; // chainDecimal.toString();
    // notifyListeners();
  }

  Future<void> ethWallet() async {
    await initEtherClient();
    _eth = new NativeService(_etherClient);

    final balance = await _eth.getBalance(getEthAddr(ethAdd));

    print('eth balance: $balance');

    listContract[3].balance = balance.toString();

    listContract[3].lineChartModel =
        LineChartModel().prepareGraphChart(listContract[3]);
  }

  Future<void> bnbWallet() async {
    await initBscClient();
    _bnb = new NativeService(_bscClient);

    final balance = await _bnb.getBalance(getEthAddr(ethAdd));

    print('bnb balance: $balance');

    listContract[4].balance = balance.toString();

    listContract[4].lineChartModel =
        LineChartModel().prepareGraphChart(listContract[3]);
  }

  void addApiProviderProperty(ApiProvider api) {
    listContract.addAll([
      api.btc,
      api.dot,
      api.nativeM,
    ]);

    notifyListeners();
  }

  // Sort Asset Portoflio
  Future<void> sortAsset() {
    sortListContract.clear();
    listContract.forEach((element) {
      sortListContract.addAll({element});
    });

    print('sort list length ${sortListContract.length}');

    if (sortListContract.isNotEmpty) {
      SmartContractModel tmp = SmartContractModel();
      for (int i = 0; i < sortListContract.length; i++) {
        for (int j = i + 1; j < sortListContract.length; j++) {
          tmp = sortListContract[i];
          print('tmp ${tmp.logo}');
          if ((double.parse(sortListContract[j].balance)) >
              (double.parse(tmp.balance))) {
            sortListContract[i] = sortListContract[j];
            sortListContract[j] = tmp;
          }
        }
      }

      notifyListeners();
    }

    print('sort finish');

    return null;
  }

  void subscribeBscbalance(BuildContext context) async {
    // await initBscClient();
    // final apiPro = Provider.of<ApiProvider>(context, listen: false);
    // try {
    //   stream = _bscClient.addedBlocks();

    //   streamSubscriptionBsc = stream.listen((event) async {
    //     await getBscBalance();
    //     await getBscV2Balance();
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
      apiPro.isBtcAvailable('contain');

      apiPro.setBtcAddr(res.toString());
      Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
      await apiPro.getBtcBalance(res.toString());
    }
  }

  void subscribeEthbalance() async {
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
    streamSubscriptionBsc.cancel();

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

  Future<bool> validateEvmAddr(String address) async {
    bool _isValid = false;
    try {
      EthereumAddress.fromHex(address, enforceEip55: true);
      // valid!
      _isValid = true;
    } on ArgumentError {
      // Not valid
    }
    return _isValid;
  }

  Future<EtherAmount> getEthGasPrice() async {
    initEtherClient();
    final gasPrice = await _etherClient.getGasPrice();
    return gasPrice;
  }

  Future<void> getBtcMaxGas() async {}

  Future<String> getBnbMaxGas(String reciever, String amount) async {
    initBscClient();
    final ethAddr = await StorageServices().readSecure('etherAdd');

    final maxGas = await _bscClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );

    return maxGas.toString();
  }

  Future<String> getEthMaxGas(String reciever, String amount) async {
    initEtherClient();
    final ethAddr = await StorageServices().readSecure('etherAdd');

    final maxGas = await _etherClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );
    return maxGas.toString();
  }

  Future<String> getBep20MaxGas(
      String contractAddr, String reciever, String amount) async {
    initBscClient();
    final bep20Contract =
        await AppUtils.contractfromAssets(AppConfig.bep20Path, contractAddr);
    final ethAddr = await StorageServices().readSecure('etherAdd');

    final txFunction = bep20Contract.function('transfer');

    final maxGas = await _bscClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
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

    print('myGas: $maxGas');
    return maxGas.toString();
  }

  Future<EtherAmount> getBscGasPrice() async {
    initBscClient();
    final gasPrice = await _bscClient.getGasPrice();
    return gasPrice;
  }

  Future<String> approveSwap(String privateKey) async {
    await initBscClient();
    final contract = await AppUtils.contractfromAssets(
        AppConfig.bep20Path, listContract[0].address);
    // final contract = await initBsc(listContract[0].address);
    final ethFunction = contract.function('approve');

    final credentials = await _bscClient.credentialsFromPrivateKey(privateKey);

    final ethAddr = await StorageServices().readSecure('etherAdd');

    final gasPrice = await _bscClient.getGasPrice();

    final maxGas = await _bscClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: contract.address,
      data: ethFunction.encodeCall(
        [
          EthereumAddress.fromHex(AppConfig.swapMainnetAddr),
          BigInt.parse('1000000000000000042420637374017961984'),
        ],
      ),
    );

    final approve = await _bscClient.sendTransaction(
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
      fetchChainIdFromNetworkId: true,
    );

    return approve;
  }

  Future<dynamic> checkAllowance() async {
    final ethAddr = await StorageServices().readSecure('etherAdd');
    final res = await query(
      listContract[0].address,
      'allowance',
      [
        EthereumAddress.fromHex(ethAddr),
        EthereumAddress.fromHex(AppConfig.swapMainnetAddr)
      ],
    );

    return res.first;
  }

  Future<String> swap(String amount, String privateKey) async {
    await initBscClient();
    final contract = await initSwapSel(AppConfig.swapMainnetAddr);

    final ethAddr = await StorageServices().readSecure('etherAdd');

    final gasPrice = await _bscClient.getGasPrice();

    final ethFunction = contract.function('swap');

    final credentials = await _bscClient.credentialsFromPrivateKey(privateKey);

    final maxGas = await _bscClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: contract.address,
      data: ethFunction
          .encodeCall([BigInt.from(double.parse(amount) * pow(10, 18))]),
    );

    final swap = await _bscClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        from: EthereumAddress.fromHex(ethAddr),
        function: ethFunction,
        gasPrice: gasPrice,
        maxGas: maxGas.toInt(),
        parameters: [BigInt.from(double.parse(amount) * pow(10, 18))],
      ),
      fetchChainIdFromNetworkId: true,
    );

    return swap;
  }

  Future<List> queryEther(
      String contractAddress, String functionName, List args) async {
    await initEtherClient();
    final contract =
        await AppUtils.contractfromAssets(AppConfig.erc20Path, contractAddress);
    //final contract = await initEtherContract(contractAddress);

    final ethFunction = contract.function(functionName);

    final res = await _etherClient.call(
      contract: contract,
      function: ethFunction,
      params: args,
    );
    return res;
  }

  Future<List> query(
      String contractAddress, String functionName, List args) async {
    initBscClient();
    final contract =
        await AppUtils.contractfromAssets(AppConfig.bep20Path, contractAddress);
    // final contract = await initBsc(contractAddress);
    final ethFunction = contract.function(functionName);

    final res = await _bscClient.call(
      contract: contract,
      function: ethFunction,
      params: args,
    );
    return res;
  }

  Future<void> extractAddress(String privateKey) async {
    initBscClient();

    print('privateKey: $privateKey');
    final credentials = await _bscClient.credentialsFromPrivateKey(
      privateKey,
    );

    if (credentials != null) {
      final addr = await credentials.extractAddress();
      ethAdd = addr.toString();
      await StorageServices().writeSecure('etherAdd', addr.toString());
    }
  }

  Future<void> getEtherAddr() async {
    final ethAddr = await StorageServices().readSecure('etherAdd');
    print(ethAddr);
    ethAdd = ethAddr;

    notifyListeners();
  }

  Future<void> fetchNonBalance() async {
    initBscClient();
    for (int i = 0; i < token.length; i++) {
      if (token[i].org == 'ERC-20') {
        final contractAddr = findContractAddr(token[i].symbol);
        final decimal = await query(contractAddr, 'decimals', []);

        final balance = await query(
            contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

        token[i].balance = Fmt.bigIntToDouble(
          balance[0] as BigInt,
          int.parse(decimal[0].toString()),
        ).toString();
      }
    }

    notifyListeners();
  }

  Future<void> fetchEtherNonBalance() async {
    initEtherClient();
    for (int i = 0; i < token.length; i++) {
      if (token[i].org == 'ERC-20') {
        final contractAddr = findContractAddr(token[i].symbol);

        final decimal = await queryEther(contractAddr, 'decimals', []);

        final balance = await queryEther(
            contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

        token[i].balance = Fmt.bigIntToDouble(
          balance[0] as BigInt,
          int.parse(decimal[0].toString()),
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
    final credentials = await _bscClient.credentialsFromPrivateKey(
      privateKey.substring(2),
    );

    final ethAddr = await StorageServices().readSecure('etherAdd');

    final maxGas = await _bscClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );

    final res = await _bscClient.sendTransaction(
      credentials,
      Transaction(
        maxGas: maxGas.toInt(),
        to: EthereumAddress.fromHex(reciever),
        value: EtherAmount.inWei(
          BigInt.from(double.parse(amount) * pow(10, 18)),
        ),
      ),
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
    final credentials = await _etherClient.credentialsFromPrivateKey(
      privateKey.substring(2),
    );

    final ethAddr = await StorageServices().readSecure('etherAdd');

    final maxGas = await _etherClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );

    final res = await _etherClient.sendTransaction(
      credentials,
      Transaction(
        maxGas: maxGas.toInt(),
        to: EthereumAddress.fromHex(reciever),
        value:
            EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
      ),
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
    initEtherClient();
    final contract =
        await AppUtils.contractfromAssets(AppConfig.erc20Path, contractAddr);
    //final contract = await initEtherContract(contractAddr);
    final txFunction = contract.function('transfer');
    final credentials =
        await _etherClient.credentialsFromPrivateKey(privateKey);

    final ethAddr = await StorageServices().readSecure('etherAdd');

    final maxGas = await _etherClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: EthereumAddress.fromHex(contractAddr),
      data: txFunction.encodeCall(
        [
          EthereumAddress.fromHex(reciever),
          BigInt.from(double.parse(amount) * pow(10, 18))
        ],
      ),
    );

    final res = await _etherClient.sendTransaction(
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
      fetchChainIdFromNetworkId: true,
    );

    return res;
  }

  Future<void> addToken(String symbol, BuildContext context,
      {String contractAddr, String network}) async {
    if (symbol == 'SEL') {
      if (!listContract[0].isContain) {
        listContract[0].isContain = true;

        await StorageServices.saveBool('SEL', true);

        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol("$symbol (BEP-20)");

        // await getSymbol();
        // await getBscDecimal();
        // await getBscBalance();
      }
    } else if (symbol == 'BNB') {
      if (!listContract[4].isContain) {
        listContract[4].isContain = true;

        await StorageServices.saveBool('BNB', true);

        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol(symbol);

        // await getBscDecimal();
        // await getBnbBalance();

        listContract[4].lineChartModel =
            LineChartModel().prepareGraphChart(listContract[0]);
      }
    } else if (symbol == 'DOT') {
      if (!ApiProvider().dot.isContain) {
        await StorageServices.saveBool('DOT', true);

        await ApiProvider().connectPolNon();
        //Provider.of<ApiProvider>(context, listen: false).isDotContain();
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol(symbol);
      }
    } else if (symbol == 'KGO') {
      if (!ApiProvider().dot.isContain) {
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('KGO (BEP-20)');
        // await Provider.of<ContractProvider>(context, listen: false)
        //     .getKgoSymbol();
        // await Provider.of<ContractProvider>(context, listen: false)
        //     .getKgoDecimal()
        //     .then((value) async {
        //   await Provider.of<ContractProvider>(context, listen: false)
        //       .getKgoBalance();
        // });
      }
    } else {
      if (network != null) {
        if (network == 'Ethereum') {
          final symbol = await queryEther(contractAddr, 'symbol', []);
          final decimal = await queryEther(contractAddr, 'decimals', []);
          final balance = await queryEther(
              contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

          final TokenModel mToken = TokenModel();

          mToken.symbol = symbol.first.toString();
          mToken.decimal = decimal.first.toString();
          mToken.balance = balance.first.toString();
          mToken.contractAddr = contractAddr;
          mToken.org = 'ERC-20';

          if (token.isEmpty) {
            addContractToken(mToken);

            await StorageServices.saveEthContractAddr(contractAddr);
            Provider.of<WalletProvider>(context, listen: false)
                .addTokenSymbol('${symbol[0]} (ERC-20)');
          }

          if (token.isNotEmpty) {
            if (!token.contains(mToken)) {
              addContractToken(mToken);

              await StorageServices.saveEthContractAddr(contractAddr);
              Provider.of<WalletProvider>(context, listen: false)
                  .addTokenSymbol('${symbol[0]} (ERC-20)');
            }
          }
        } else {
          final symbol = await query(contractAddr, 'symbol', []);
          final decimal = await query(contractAddr, 'decimals', []);
          final balance = await query(
              contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

          if (token.isNotEmpty) {
            final TokenModel item = token.firstWhere(
                (element) =>
                    element.symbol.toLowerCase() ==
                    symbol[0].toString().toLowerCase(),
                orElse: () => null);

            if (item == null) {
              addContractToken(
                TokenModel(
                  contractAddr: contractAddr,
                  decimal: decimal[0].toString(),
                  symbol: symbol[0].toString(),
                  balance: balance[0].toString(),
                  org: 'BEP-20',
                ),
              );

              await StorageServices.saveContractAddr(contractAddr);
              Provider.of<WalletProvider>(context, listen: false)
                  .addTokenSymbol('${symbol[0]} (BEP-20)');
            }
          } else {
            token.add(
              TokenModel(
                  contractAddr: contractAddr,
                  decimal: decimal[0].toString(),
                  symbol: symbol[0].toString(),
                  balance: balance[0].toString(),
                  org: 'BEP-20'),
            );

            await StorageServices.saveContractAddr(contractAddr);
            Provider.of<WalletProvider>(context, listen: false)
                .addTokenSymbol(symbol[0].toString());
          }
        }
      }
    }
    notifyListeners();
  }

  Future<void> addContractToken(TokenModel tokenModel) async {
    token.add(tokenModel);
    notifyListeners();
  }

  Future<void> removeEtherToken(String symbol, BuildContext context) async {
    final mContractAddr = findContractAddr(symbol);
    if (mContractAddr != null) {
      await StorageServices.removeEthContractAddr(mContractAddr);
      token.removeWhere(
        (element) => element.symbol.toLowerCase().startsWith(
              symbol.toLowerCase(),
            ),
      );

      Provider.of<WalletProvider>(context, listen: false)
          .removeTokenSymbol(symbol);
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
      Provider.of<ApiProvider>(context, listen: false).dotIsNotContain();
    } else {
      final mContractAddr = findContractAddr(symbol);
      await StorageServices.removeContractAddr(mContractAddr);
      token.removeWhere(
        (element) => element.symbol.toLowerCase().startsWith(
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
    final item = token.firstWhere(
      (element) => element.symbol.toLowerCase().startsWith(
            symbol.toLowerCase(),
          ),
    );
    return item.contractAddr;
  }

  void setkiwigoMarket(Market kgoMarket, List<List<double>> lineChart,
      String currentPrice, String priceChange24h) {
    print('kgo all time high ${kgoMarket.ath}');
    listContract[2].marketData = kgoMarket;
    listContract[2].lineChartData = lineChart;
    listContract[2].marketPrice = currentPrice;
    listContract[2].change24h = priceChange24h;
    notifyListeners();
  }

  void setEtherMarket(Market ethMarket, List<List<double>> lineChart,
      String currentPrice, String priceChange24h) {
    listContract[3].marketData = ethMarket;
    listContract[3].marketPrice = currentPrice;
    listContract[3].change24h = priceChange24h;
    listContract[3].lineChartData = lineChart;
    notifyListeners();
  }

  void setBnbMarket(Market bnbMarket, List<List<double>> lineChart,
      String currentPrice, String priceChange24h) {
    listContract[4].marketData = bnbMarket;
    listContract[4].marketPrice = currentPrice;
    listContract[4].change24h = priceChange24h;
    listContract[4].lineChartData = lineChart;
    notifyListeners();
  }

  void setReady() {
    print('isReady: $isReady');
    isReady = true;

    notifyListeners();
  }

  void resetConObject() {
    token.clear();
    notifyListeners();
  }
}
