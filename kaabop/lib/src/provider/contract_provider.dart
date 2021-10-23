import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/models/lineChart_m.dart';
import 'package:wallet_apps/src/models/token.m.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';
import '../../index.dart';

class ContractProvider with ChangeNotifier {
  Client _httpClient;

  Web3Client _bscClient, _etherClient, _selClient;
  Web3Client get bscClient => _bscClient;
  Web3Client get ethClient => _etherClient;
  Web3Client get selClient => _selClient;

  StreamSubscription<String> streamSubscriptionBsc;
  Stream<String> stream;
  // StreamSubscription<String> streamSubscriptionEth;

  List<TokenModel> token = [];

  final WalletSDK sdk = ApiProvider.sdk;

  final Keyring keyring = ApiProvider.keyring;

  String ethAdd = '';
  bool std;

  // Atd atd = Atd();
  // Kmpi kmpi = Kmpi();
  bool isReady = false;
  bool cancelStream = false;
  StreamSubscription<String> streamSubscription;

  /// To Get Member Variable
  ApiProvider apiProvider = ApiProvider();

  List<SmartContractModel> listContract = [
    /// (0 SEL V1) (1 SEL V2) (2 KIWIGO) (3 ETH) (4 BNB)
    SmartContractModel(
        id: 'selendra',
        address:
            '0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030', //'0x288d3A87a87C284Ed685E0490E5C4cC0883a060a',
        logo: 'assets/SelendraCircle-Blue.png',
        symbol: 'SEL',
        name: "SELENDRA",
        org: 'BEP-20',
        isContain: true,
        lineChartModel: LineChartModel()),
    // SEL V2
    SmartContractModel(
        id: 'selendra v2',
        address:
            '0x46bF747DeAC87b5db70096d9e88debd72D4C7f3C', //'0x30bAb6B88dB781129c6a4e9B7926738e3314Cf1C',
        logo: 'assets/SelendraCircle-Blue.png',
        symbol: 'SEL 2',
        name: "SELENDRA",
        balance: '0',
        org: 'BEP-20',
        isContain: true,
        lineChartModel: LineChartModel()),
    // KIWIGO
    SmartContractModel(
        id: 'kiwigo',
        address:
            '0x78F51cc2e297dfaC4c0D5fb3552d413DC3F71314', //'0x5d3AfBA1924aD748776E4Ca62213BF7acf39d773',
        logo: 'assets/Kiwi-GO-White-1.png',
        symbol: 'KGO',
        name: "KIWIGO",
        balance: '0',
        org: 'BEP-20',
        isContain: true,
        lineChartModel: LineChartModel()),

    // Ethereum
    SmartContractModel(
        id: 'ethereum',
        logo: 'assets/eth.png',
        symbol: 'ETH',
        name: "Ethereum",
        org: '',
        isContain: true,
        lineChartModel: LineChartModel()),
    //BNB
    SmartContractModel(
        id: 'binance smart chain',
        logo: 'assets/bnb.png',
        symbol: 'BNB',
        name: "Binance Coin",
        org: 'Smart Chain',
        isContain: true,
        lineChartModel: LineChartModel()),
    // SmartContractModel(
    //     id: 'REKREAY',
    //     address: '0x9B71571dd5967878356Cab2Bb2E860Fa81Ce46f0',
    //     logo: 'assets/token_logo/rekreay.png',
    //     symbol: 'REKREAY',
    //     name: "REKREAY",
    //     org: 'BEP-20',
    //     isContain: true,
    //     lineChartModel: LineChartModel()),
  ];

  /// List For Display Asset After sort
  List<SmartContractModel> sortListContract = [];

  /// This Function Run After BTC, DOT and SEL Testnet fetched
  ///
  /// Used inside: home.dart, import_user_acc.dart and create_user_info.dart
  void addApiProviderProperty(ApiProvider api) {
    sortListContract.addAll([
      api.btc,
      api.dot,
      api.nativeM,
    ]);

    notifyListeners();
  }

  Future<void> initBscClient() async {
    _httpClient = Client();
    _bscClient = Web3Client(AppConfig.networkList[3].httpUrlTN, _httpClient,
        socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.networkList[3].wsUrlTN)
          .cast<String>();
    });

    // notifyListeners();
  }

  Future<void> initEtherClient() async {
    _httpClient = Client();
    _etherClient = Web3Client(AppConfig.networkList[2].httpUrlTN, _httpClient,
        socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.networkList[2].wsUrlTN)
          .cast<String>();
    });

    notifyListeners();
  }

  Future<void> initSelClient() async {
    _httpClient = Client();
    _selClient = Web3Client(AppConfig.networkList[0].httpUrlTN, _httpClient,
        socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.networkList[0].wsUrlTN)
          .cast<String>();
    });

    notifyListeners();
  }

  /// Sort Asset Portoflio, And aslo add api property
  Future<void> sortAsset(BuildContext context) {
    final api = Provider.of<ApiProvider>(context, listen: false);

    sortListContract.clear();

    /// Added List Contract Into SortListContract
    listContract.forEach((element) {
      sortListContract.addAll({element});
    });

    /// Add BTC, DOT, SEL testnet Into listContract of Contract Provider's Property
    addApiProviderProperty(api);

    if (sortListContract.isNotEmpty) {
      SmartContractModel tmp = SmartContractModel();
      for (int i = 0; i < sortListContract.length; i++) {
        for (int j = i + 1; j < sortListContract.length; j++) {
          tmp = sortListContract[i];
          if ((double.parse(sortListContract[j].balance)) >
              (double.parse(tmp.balance))) {
            sortListContract[i] = sortListContract[j];
            sortListContract[j] = tmp;
          }
        }
      }
    }

    return null;
  }

  Future<bool> getPending(String txHash,
      {@required Web3Client nodeClient}) async {
    // Re-Initialize
    std = null;

    await initBscClient();

    await _bscClient
        .addedBlocks()
        .asyncMap((_) async {
          try {
            // This Method Will Run Again And Again Until we return something
            await nodeClient.getTransactionReceipt(txHash).then((d) {
              // Give Value To std When Request Successfully
              if (d != null) {
                std = d.status;
              }
            });

            // Return Value For True Value And Method GetTrxReceipt Also Terminate
            if (std != null) return std;
          } on FormatException catch (e) {
            // This Error Because can't Convert Hexadecimal number to integer.
            // Note: Transaction is 100% successfully And It's just error becuase of Failure Parse that hexa
            // Example-Error: 0xc, 0x3a, ...
            // Example-Success: 0x1, 0x2, 0,3 ...

            // return True For Facing This FormatException
            if (e.message.toString() == 'Invalid radix-10 number') {
              std = true;
              return std;
            }
          } catch (e) {
            // print("Error $e");
          }
        })
        .where((receipt) => receipt != null)
        .first;

    return std;
  }

  Future<bool> getEthPending(String txHash) async {
    // Re-Initialize
    std = null;

    await initEtherClient();

    await _etherClient
        .addedBlocks()
        .asyncMap((_) async {
          try {
            // This Method Will Run Again And Again Until we return something
            await _etherClient.getTransactionReceipt(txHash).then((d) {
              // Give Value To std When Request Successfully
              if (d != null) {
                std = d.status;
              }
            });

            // Return Value For True Value And Method GetTrxReceipt Also Terminate
            if (std != null) return std;
          } on FormatException catch (e) {
            // This Error Because can't Convert Hexadecimal number to integer.
            // Note: Transaction is 100% successfully And It's just error becuase of Failure Parse that hexa
            // Example-Error: 0xc, 0x3a, ...
            // Example-Success: 0x1, 0x2, 0,3 ...

            // return True For Facing This FormatException
            if (e.message.toString() == 'Invalid radix-10 number') {
              std = true;
              return std;
            }
          } catch (e) {
            print("Error $e");
          }
        })
        .where((receipt) => receipt != null)
        .first;

    return std;
  }

  void subscribeBscbalance(BuildContext context) async {
    await initBscClient();
    final apiPro = Provider.of<ApiProvider>(context, listen: false);
    try {
      stream = _bscClient.addedBlocks();

      // streamSubscriptionBsc = stream.listen((event) async {
      //   await getBscBalance();
      //   await getBscV2Balance();
      //   await getBnbBalance();
      //   await Provider.of<ContractProvider>(context, listen: false)
      //       .getKgoDecimal()
      //       .then((value) async {
      //     await Provider.of<ContractProvider>(context, listen: false)
      //         .getKgoBalance();
      //   });

      //   await isBtcContain(apiPro, context);

      //   await apiPro.getDotChainDecimal();

      // });
    } catch (e) {
      // print(e.message);
    }
  }

  Future<void> isBtcContain(ApiProvider apiPro, BuildContext context) async {
    final res = await StorageServices.fetchData('bech32');

    if (res != null) {
      apiPro.isBtcAvailable('contain');

      apiPro.setBtcAddr(res.toString());
      Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
      await apiPro.getBtcBalance(res.toString());
    }

    notifyListeners();
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

  Future<void> unsubscribeNetwork() async {
    await streamSubscriptionBsc.cancel();

    cancelStream = true;

    //await streamSubscriptionEth.cancel();
    notifyListeners();
  }

  Future<void> getEtherBalance() async {
    await initEtherClient();

    final ethAddr = await StorageServices().readSecure('etherAdd');
    final EtherAmount ethbalance =
        await _etherClient.getBalance(EthereumAddress.fromHex(ethAddr));
    listContract[3].balance =
        ethbalance.getValueInUnit(EtherUnit.ether).toString();

    listContract[3].lineChartModel =
        LineChartModel().prepareGraphChart(listContract[3]);

    notifyListeners();
  }

  Future<DeployedContract> initBsc(String contractAddr) async {
    final String abiCode = await rootBundle.loadString('assets/abi/abi.json');
    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, 'BEP-20'),
      EthereumAddress.fromHex(contractAddr),
    );

    return contract;
  }

  Future<DeployedContract> initEtherContract(String contractAddr) async {
    final String abiCode = await rootBundle.loadString('assets/abi/erc20.json');

    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, 'ERC-20'),
      EthereumAddress.fromHex(contractAddr),
    );

    return contract;
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
    await initEtherClient();
    final gasPrice = await _etherClient.getGasPrice();
    return gasPrice;
  }

  Future<EtherAmount> getSelGasPrice() async {
    await initSelClient();
    final gasPrice = await _selClient.getGasPrice();
    return gasPrice;
  }

  Future<String> getBnbMaxGas(String reciever, String amount) async {
    await initBscClient();
    final ethAddr = await StorageServices().readSecure('etherAdd');

    final maxGas = await _bscClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );

    return maxGas.toString();
  }

  Future<String> getEthMaxGas(String reciever, String amount) async {
    await initEtherClient();
    final ethAddr = await StorageServices().readSecure('etherAdd');

    final maxGas = await _etherClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );
    return maxGas.toString();
  }

  Future<String> getSelMaxGas(String reciever, String amount) async {
    await initSelClient();
    final ethAddr = await StorageServices().readSecure('etherAdd');

    final maxGas = await _selClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: EthereumAddress.fromHex(reciever),
      value: EtherAmount.inWei(BigInt.from(double.parse(amount) * pow(10, 18))),
    );

    return maxGas.toString();
  }

  Future<String> getBep20MaxGas(
      String contractAddr, String reciever, String amount) async {
    await initBscClient();
    final bep20Contract = await initBsc(contractAddr);
    final ethAddr = await StorageServices().readSecure('etherAdd');

    final txFunction = bep20Contract.function('transfer');

    final maxGas = await _bscClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: EthereumAddress.fromHex(contractAddr),
      //gasPrice: EtherAmount.inWei(BigInt.parse('20')),
      data: txFunction.encodeCall(
        [
          EthereumAddress.fromHex(reciever),
          BigInt.from(double.parse(amount) * pow(10, 18))
        ],
      ),
    );

    return maxGas.toString();
  }

  Future<EtherAmount> getBscGasPrice() async {
    await initBscClient();
    final gasPrice = await _bscClient.getGasPrice();
    return gasPrice;
  }

  Future<String> approveToken(
      String privateKey, String tokenAddress, String spenderAddress) async {
    final String _presaleContract =
        "0xeBf7E248689534C2757a20DCfe7ffe0bb04b9e93";
    await initBscClient();
    final contract = await initBsc(tokenAddress);
    final ethFunction = contract.function('approve');

    final credentials = await _bscClient.credentialsFromPrivateKey(privateKey);

    final ethAddr = await StorageServices().readSecure('etherAdd');

    final gasPrice = await _bscClient.getGasPrice();

    final maxGas = await _bscClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: contract.address,
      data: ethFunction.encodeCall(
        [
          EthereumAddress.fromHex(_presaleContract),
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
          EthereumAddress.fromHex(_presaleContract),
          BigInt.parse('1000000000000000042420637374017961984'),
        ],
      ),
      fetchChainIdFromNetworkId: true,
    );

    return approve;
  }

  Future<String> approveSwap(String privateKey) async {
    await initBscClient();
    final contract = await initBsc(listContract[0].address);
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
    final contract = await initEtherContract(contractAddress);

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
    await initBscClient();
    final contract = await initBsc(contractAddress);
    final ethFunction = contract.function(functionName);

    final res = await _bscClient.call(
      contract: contract,
      function: ethFunction,
      params: args,
    );
    return res;
  }

  Future<void> getKgoSymbol() async {
    final res = await query(listContract[2].address, 'symbol', []);
    listContract[2].symbol = res[0].toString();
    listContract[2].isContain = true;
    notifyListeners();
  }

  Future<void> getKgoDecimal() async {
    final res = await query(listContract[2].address, 'decimals', []);
    listContract[2].chainDecimal = res[0].toString();
    //   print("getKgoDecimal ${listContract[2].chainDecimal}");

    notifyListeners();
  }

  Future<void> getKgoBalance() async {
    listContract[2].isContain = true;

    if (ethAdd != '') {
      final res = await query(listContract[2].address, 'balanceOf',
          [EthereumAddress.fromHex(ethAdd)]);

      listContract[2].balance = Fmt.bigIntToDouble(
        res[0] as BigInt,
        int.parse(listContract[2].chainDecimal),
      ).toString();

      listContract[2].lineChartModel =
          LineChartModel().prepareGraphChart(listContract[2]);
    }

    notifyListeners();
  }

  Future<void> getRRBalance() async {
    if (ethAdd != '') {
      final res = await query(listContract[5].address, 'balanceOf',
          [EthereumAddress.fromHex(ethAdd)]);

      listContract[5].balance = Fmt.bigIntToDouble(
        res[0] as BigInt,
        int.parse('0'),
      ).toString();

      // listContract[2].lineChartModel =
      //     LineChartModel().prepareGraphChart(listContract[2]);
    }

    notifyListeners();
  }

  Future<void> getBscDecimal(int indexContract) async {
    try {
      //  print("getBscDecimal address ${listContract[indexContract].address}");
      final res =
          await query(listContract[indexContract].address, 'decimals', []);
      // print("Res");
      listContract[indexContract].chainDecimal = res[0].toString();

      notifyListeners();
    } catch (e) {
      print("Error getBscDecimal $e");
    }
  }

  Future<void> getSymbol() async {
    final res = await query(listContract[0].address, 'symbol', []);

    listContract[0].symbol = res[0].toString();
    notifyListeners();
  }

  Future<void> extractAddress(String privateKey) async {
    initBscClient();
    final credentials = await _bscClient.credentialsFromPrivateKey(
      privateKey,
    );

    if (credentials != null) {
      final addr = await credentials.extractAddress();
      await StorageServices().writeSecure('etherAdd', addr.toString());
    }
  }

  Future<void> getEtherAddr() async {
    try {
      final ethAddr = await StorageServices().readSecure('etherAdd');
      ethAdd = ethAddr;

      print(ethAddr);

      notifyListeners();
    } catch (e) {
      print("getEtherAddr $e");
    }
  }

  Future<void> getBnbBalance() async {
    listContract[4].isContain = true;
    final ethAddr = await StorageServices().readSecure('etherAdd');
    final balance = await _bscClient.getBalance(
      EthereumAddress.fromHex(ethAddr),
    );
    listContract[4].balance =
        balance.getValueInUnit(EtherUnit.ether).toString();

    // Assign Line Graph Chart
    listContract[4].lineChartModel =
        LineChartModel().prepareGraphChart(listContract[4]);

    notifyListeners();
  }

  Future<void> getBscBalance() async {
    // print("BSC ${!cancelStream}");

    listContract[0].isContain = true;
    await getBscDecimal(0);
    // print("ethAdd $ethAdd");
    if (ethAdd != '') {
      final res = await query(listContract[0].address, 'balanceOf',
          [EthereumAddress.fromHex(ethAdd)]);
      listContract[0].balance = Fmt.bigIntToDouble(
        res[0] as BigInt,
        int.parse(listContract[0].chainDecimal),
      ).toString();

      // Assign Line Graph Chart
      listContract[0].lineChartModel =
          LineChartModel().prepareGraphChart(listContract[0]);
    }

    notifyListeners();
  }

  Future<void> getBscV2Balance() async {
    listContract[1].isContain = true;
    await getBscDecimal(1);
    if (ethAdd != '') {
      final res = await query(listContract[1].address, 'balanceOf',
          [EthereumAddress.fromHex(ethAdd)]);
      listContract[1].balance = Fmt.bigIntToDouble(
        res[0] as BigInt,
        int.parse(listContract[1].chainDecimal),
      ).toString();

      // Assign Line Graph Chart
      listContract[1].lineChartModel =
          LineChartModel().prepareGraphChart(listContract[1]);
    }

    notifyListeners();
  }

  Future<void> fetchNonBalance() async {
    // print("fetchNonBalance");
    await initBscClient();
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
    // print("fetchEtherNonBalance");
    await initEtherClient();
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
    await initBscClient();
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
    await initEtherClient();
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

  Future<String> sendTxBsc(
    String contractAddr,
    String chainDecimal,
    String privateKey,
    String reciever,
    String amount,
  ) async {
    await initBscClient();

    final contract = await initBsc(contractAddr);
    final txFunction = contract.function('transfer');
    final credentials = await _bscClient.credentialsFromPrivateKey(privateKey);

    final ethAddr = await StorageServices().readSecure('etherAdd');

    final maxGas = await _bscClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: EthereumAddress.fromHex(contractAddr),
      data: txFunction.encodeCall(
        [
          EthereumAddress.fromHex(reciever),
          BigInt.from(double.parse(amount) * pow(10, 18))
        ],
      ),
    );

    final res = await _bscClient.sendTransaction(
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

  Future<String> sendTxEthCon(
    String contractAddr,
    String chainDecimal,
    String privateKey,
    String reciever,
    String amount,
  ) async {
    await initEtherClient();

    final contract = await initEtherContract(contractAddr);
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

  // Future<void> initKmpi() async {
  //   kmpi.isContain = true;
  //   kmpi.logo = 'assets/koompi_white_logo.png';
  //   kmpi.symbol = 'KMPI';
  //   kmpi.org = 'KOOMPI';
  //   kmpi.id = 'koompi';

  //   await sdk.api.callContract();
  //   await fetchKmpiHash();
  //   fetchKmpiBalance();
  //   notifyListeners();
  // }

  // Future<void> fetchKmpiHash() async {
  //   final res =
  //       await sdk.api.getHashBySymbol(keyring.current.address, kmpi.symbol);
  //   kmpi.hash = res.toString();
  // }

  // Future<void> fetchKmpiBalance() async {
  //   final res = await sdk.api.balanceOfByPartition(
  //       keyring.current.address, keyring.current.address, kmpi.hash);
  //   kmpi.balance = BigInt.parse(res['output'].toString()).toString();

  //   notifyListeners();
  // }

  // Future<void> initAtd() async {
  //   atd.isContain = true;
  //   atd.logo = 'assets/FingerPrint1.png';
  //   atd.symbol = 'ATD';
  //   atd.org = 'KOOMPI';
  //   atd.id = 'koompi';

  //   await sdk.api.initAttendant();
  //   notifyListeners();
  // }

  // Future<void> fetchAtdBalance() async {
  //   final res = await sdk.api.getAToken(keyring.current.address);
  //   atd.balance = BigInt.parse(res).toString();

  //   notifyListeners();
  // }

  Future<void> addToken(String symbol, BuildContext context,
      {String contractAddr, String network}) async {
    if (symbol == 'SEL') {
      if (!listContract[0].isContain) {
        listContract[0].isContain = true;

        await StorageServices.saveBool('SEL', true);

        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol("$symbol (BEP-20)");

        await getSymbol();
        await getBscDecimal(0);
        await getBscBalance();
      }
    } else if (symbol == 'BNB') {
      if (!listContract[4].isContain) {
        listContract[4].isContain = true;

        await StorageServices.saveBool('BNB', true);

        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol(symbol);

        await getBscDecimal(4);
        await getBnbBalance();

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
        await Provider.of<ContractProvider>(context, listen: false)
            .getKgoSymbol();
        await Provider.of<ContractProvider>(context, listen: false)
            .getKgoDecimal()
            .then((value) async {
          await Provider.of<ContractProvider>(context, listen: false)
              .getKgoBalance();
        });
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

  // Future<void> getAStatus() async {
  //   final res = await sdk.api.getAStatus(keyring.keyPairs[0].address);
  //   atd.status = res;
  //   notifyListeners();
  // }

  void setkiwigoMarket(Market kgoMarket, List<List<double>> lineChart,
      String currentPrice, String priceChange24h) {
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
    isReady = true;

    notifyListeners();
  }

  void resetConObject() {
    // listContract[0] = SmartContractModel(
    //   id: 'selendra',
    //   symbol: 'SEL',
    //   logo: 'assets/SelendraCircle-Blue.png',
    //   org: 'BEP-20',
    //   isContain: true,
    // );
    // listContract[4] = SmartContractModel(
    //   id: 'binance smart chain',
    //   logo: 'assets/bnb.png',
    //   symbol: 'BNB',
    //   // org: 'Smart Chain',
    //   isContain: true,
    // );

    token.clear();
    sortListContract.clear();

    notifyListeners();
  }
}
