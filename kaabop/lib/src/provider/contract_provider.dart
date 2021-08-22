import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/models/token.m.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';
import '../../index.dart';

class ContractProvider with ChangeNotifier {
  Client _httpClient;

  Web3Client _bscClient, _etherClient, _selClient;

  StreamSubscription<String> streamSubscriptionBsc;
  StreamSubscription<String> streamSubscriptionEth;

  List<TokenModel> token = [];

  final WalletSDK sdk = ApiProvider.sdk;

  final Keyring keyring = ApiProvider.keyring;

  String ethAdd = '';

  Atd atd = Atd();
  Kmpi kmpi = Kmpi();
  bool isReady = false;
  Coin selBsc = Coin(
    id: 'selendra',
    logo: 'assets/SelendraCircle-Blue.png',
    symbol: 'SEL',
    org: 'BEP-20',
    isContain: true,
  );
  Coin selBscV2 = Coin(
    id: 'selendra v2',
    logo: 'assets/SelendraCircle-Blue.png',
    symbol: 'SEL (v2)',
    org: 'BEP-20',
    isContain: true,
  );

  Coin kgoBsc = Coin(
    id: 'kiwigo',
    logo: 'assets/Kiwi-GO-White-1.png',
    symbol: 'KGO',
    org: 'BEP-20',
    isContain: true,
  );

  Coin etherNative = Coin(
    id: 'ethereum',
    logo: 'assets/eth.png',
    symbol: 'ETH',
    org: '',
    isContain: true,
  );

  Coin bnbSmartChain = Coin(
    id: 'binance smart chain',
    logo: 'assets/bnb.png',
    symbol: 'BNB',
    org: 'Smart Chain',
    isContain: true,
  );

  Future<void> initBscClient() async {
    _httpClient = Client();
    _bscClient =
        Web3Client(AppConfig.bscMainNet, _httpClient, socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.bscWs).cast<String>();
    });
  }

  Future<void> initEtherClient() async {
    _httpClient = Client();
    _etherClient =
        Web3Client(AppConfig.etherMainet, _httpClient, socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.etherWs).cast<String>();
    });
  }

  Future<void> initSelClient() async {
    _httpClient = Client();
    _selClient =
        Web3Client(AppConfig.selTestnet, _httpClient, socketConnector: () {
      return IOWebSocketChannel.connect(AppConfig.selWs).cast<String>();
    });
  }

  Future<bool> getPending(String txHash) async {
    await initBscClient();

    final res = await _bscClient
        .addedBlocks()
        .asyncMap((_) => _bscClient.getTransactionReceipt(txHash))
        .where((receipt) => receipt != null)
        .first;

    return res.status;
  }

  void subscribeBscbalance() async {
    // await initBscClient();
    // try {
    //   var res = _bscClient.addedBlocks();

    //   streamSubscriptionBsc = res.listen((event) {
    //     getBscBalance();
    //     getBscV2Balance();
    //     getBnbBalance();
    //     getKgoBalance();
    //   });
    // } catch (e) {
    //   print(e.message);
    // }
    // notifyListeners();
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
    // await streamSubscriptionBsc.cancel();
    //await streamSubscriptionEth.cancel();
    notifyListeners();
  }

  Future<void> getEtherBalance() async {
    await initEtherClient();

    final ethAddr = await StorageServices().readSecure('etherAdd');
    final EtherAmount ethbalance =
        await _etherClient.getBalance(EthereumAddress.fromHex(ethAddr));
    etherNative.balance = ethbalance.getValueInUnit(EtherUnit.ether).toString();

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
    final bep20Contract = await initBsc(contractAddr);
    final ethAddr = await StorageServices().readSecure('etherAdd');

    final txFunction = bep20Contract.function('transfer');
    final maxGas = await _bscClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: EthereumAddress.fromHex(reciever),
      data: txFunction.encodeCall(
        [
          EthereumAddress.fromHex(reciever),
          BigInt.from(double.parse(amount) * pow(10, 18))
        ],
      ),
    );

    return maxGas.toString();
  }

  Future<EtherAmount> getSelGasPrice() async {
    initSelClient();
    final gasPrice = await _selClient.getGasPrice();
    return gasPrice;
  }

  Future<EtherAmount> getBscGasPrice() async {
    initBscClient();
    final gasPrice = await _bscClient.getGasPrice();
    return gasPrice;
  }

  Future<DeployedContract> initEtherContract(String contractAddr) async {
    final String abiCode = await rootBundle.loadString('assets/abi/erc20.json');

    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, 'ERC-20'),
      EthereumAddress.fromHex(contractAddr),
    );

    return contract;
  }

  Future<String> approveSwap(String privateKey) async {
    await initBscClient();
    final contract = await initBsc(AppConfig.selV1MainnetAddr);
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
      AppConfig.selV1MainnetAddr,
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
    initBscClient();
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
    final res = await query(AppConfig.kgoAddr, 'symbol', []);

    kgoBsc.symbol = res[0].toString();
    kgoBsc.isContain = true;
    notifyListeners();
  }

  Future<void> getKgoDecimal() async {
    final res = await query(AppConfig.kgoAddr, 'decimals', []);
    kgoBsc.chainDecimal = res[0].toString();

    notifyListeners();
  }

  Future<void> getKgoBalance() async {
    selBsc.isContain = true;

    if (ethAdd != '') {
      final res = await query(
          AppConfig.kgoAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

      kgoBsc.balance = Fmt.bigIntToDouble(
        res[0] as BigInt,
        int.parse(kgoBsc.chainDecimal),
      ).toString();
    }

    notifyListeners();
  }

  Future<void> getBscDecimal() async {
    final res = await query(AppConfig.selV1MainnetAddr, 'decimals', []);

    selBsc.chainDecimal = res[0].toString();

    notifyListeners();
  }

  Future<void> getSymbol() async {
    final res = await query(AppConfig.selV1MainnetAddr, 'symbol', []);

    selBsc.symbol = res[0].toString();
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
    final ethAddr = await StorageServices().readSecure('etherAdd');
    ethAdd = ethAddr;

    notifyListeners();
  }

  Future<void> getBnbBalance() async {
    bnbSmartChain.isContain = true;
    initBscClient();
    final ethAddr = await StorageServices().readSecure('etherAdd');
    final balance = await _bscClient.getBalance(
      EthereumAddress.fromHex(ethAddr),
    );

    bnbSmartChain.balance = balance.getValueInUnit(EtherUnit.ether).toString();

    notifyListeners();
  }

  Future<void> getBscV2Balance() async {
    selBscV2.isContain = true;
    await getBscDecimal();
    if (ethAdd != '') {
      final res = await query(AppConfig.selv2MainnetAddr, 'balanceOf',
          [EthereumAddress.fromHex(ethAdd)]);
      selBscV2.balance = Fmt.bigIntToDouble(
        res[0] as BigInt,
        int.parse(selBsc.chainDecimal),
      ).toString();
    }

    notifyListeners();
  }

  Future<void> getBscBalance() async {
    selBsc.isContain = true;
    await getBscDecimal();
    if (ethAdd != '') {
      final res = await query(AppConfig.selV1MainnetAddr, 'balanceOf',
          [EthereumAddress.fromHex(ethAdd)]);
      selBsc.balance = Fmt.bigIntToDouble(
        res[0] as BigInt,
        int.parse(selBsc.chainDecimal),
      ).toString();
    }

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

    final res = await _bscClient.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(reciever),
        value: EtherAmount.inWei(
          BigInt.from(double.parse(amount) * pow(10, 18)),
        ),
      ),
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
    final credentials = await _bscClient.credentialsFromPrivateKey(
      privateKey.substring(2),
    );

    final res = await _etherClient.sendTransaction(
      credentials,
      Transaction(
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
    initBscClient();

    final contract = await initBsc(contractAddr);
    final txFunction = contract.function('transfer');
    final credentials = await _bscClient.credentialsFromPrivateKey(privateKey);

    final res = await _bscClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: txFunction,
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
    initEtherClient();

    final contract = await initEtherContract(contractAddr);
    final txFunction = contract.function('transfer');
    final credentials =
        await _etherClient.credentialsFromPrivateKey(privateKey);

    final res = await _etherClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: txFunction,
        parameters: [
          EthereumAddress.fromHex(reciever),
          BigInt.from(double.parse(amount) * pow(10, 18))
        ],
      ),
      fetchChainIdFromNetworkId: true,
    );

    return res;
  }

  Future<void> initKmpi() async {
    kmpi.isContain = true;
    kmpi.logo = 'assets/koompi_white_logo.png';
    kmpi.symbol = 'KMPI';
    kmpi.org = 'KOOMPI';
    kmpi.id = 'koompi';

    await sdk.api.callContract();
    await fetchKmpiHash();
    fetchKmpiBalance();
    notifyListeners();
  }

  Future<void> fetchKmpiHash() async {
    final res =
        await sdk.api.getHashBySymbol(keyring.current.address, kmpi.symbol);
    kmpi.hash = res.toString();
  }

  Future<void> fetchKmpiBalance() async {
    final res = await sdk.api.balanceOfByPartition(
        keyring.current.address, keyring.current.address, kmpi.hash);
    kmpi.balance = BigInt.parse(res['output'].toString()).toString();

    notifyListeners();
  }

  Future<void> initAtd() async {
    atd.isContain = true;
    atd.logo = 'assets/FingerPrint1.png';
    atd.symbol = 'ATD';
    atd.org = 'KOOMPI';
    atd.id = 'koompi';

    await sdk.api.initAttendant();
    notifyListeners();
  }

  Future<void> fetchAtdBalance() async {
    final res = await sdk.api.getAToken(keyring.current.address);
    atd.balance = BigInt.parse(res).toString();

    notifyListeners();
  }

  Future<void> addToken(String symbol, BuildContext context,
      {String contractAddr, String network}) async {
    if (symbol == 'KMPI') {
      if (!kmpi.isContain) {
        initKmpi().then((value) async {
          await StorageServices.saveBool(kmpi.symbol, true);
        });
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol(symbol);
      }
    } else if (symbol == 'SEL') {
      if (!selBsc.isContain) {
        selBsc.isContain = true;

        await StorageServices.saveBool('SEL', true);

        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol("$symbol (BEP-20)");

        await getSymbol();
        await getBscDecimal();
        await getBscBalance();
      }
    } else if (symbol == 'BNB') {
      if (!bnbSmartChain.isContain) {
        bnbSmartChain.isContain = true;

        await StorageServices.saveBool('BNB', true);

        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol(symbol);

        await getBscDecimal();
        getBnbBalance();
      }
    } else if (symbol == 'ATD') {
      if (!atd.isContain) {
        initAtd().then((value) async {
          await StorageServices.saveBool(atd.symbol, true);
          Provider.of<WalletProvider>(context, listen: false)
              .addTokenSymbol(symbol);
        });
      }
    } else if (symbol == 'DOT') {
      if (!ApiProvider().dot.isContain) {
        await StorageServices.saveBool('DOT', true);

        ApiProvider().connectPolNon();
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol(symbol);
      }
    } else if (symbol == 'KGO') {
      if (!ApiProvider().dot.isContain) {
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('KGO (BEP-20)');
        Provider.of<ContractProvider>(context, listen: false).getKgoSymbol();
        Provider.of<ContractProvider>(context, listen: false)
            .getKgoDecimal()
            .then((value) {
          Provider.of<ContractProvider>(context, listen: false).getKgoBalance();
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
    if (symbol == 'KMPI') {
      kmpi.isContain = false;
      await StorageServices.removeKey('KMPI');
    } else if (symbol == 'ATD') {
      atd.isContain = false;
      await StorageServices.removeKey('ATD');
    } else if (symbol == 'SEL') {
      selBsc.isContain = false;
      await StorageServices.removeKey('SEL');
    } else if (symbol == 'BNB') {
      bnbSmartChain.isContain = false;
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

  Future<void> getAStatus() async {
    final res = await sdk.api.getAStatus(keyring.keyPairs[0].address);
    atd.status = res;
    notifyListeners();
  }

  void setEtherMarket(Market ethMarket, List<List<double>> lineChart,
      String currentPrice, String priceChange24h) {
    etherNative.marketData = ethMarket;
    etherNative.marketPrice = currentPrice;
    etherNative.change24h = priceChange24h;
    etherNative.lineChartData = lineChart;
    notifyListeners();
  }

  void setBnbMarket(Market bnbMarket, List<List<double>> lineChart,
      String currentPrice, String priceChange24h) {
    bnbSmartChain.marketData = bnbMarket;
    bnbSmartChain.marketPrice = currentPrice;
    bnbSmartChain.change24h = priceChange24h;
    bnbSmartChain.lineChartData = lineChart;
    notifyListeners();
  }

  void setkiwigoMarket(Market kgoMarket, List<List<double>> lineChart,
      String currentPrice, String priceChange24h) {
    kgoBsc.marketData = kgoMarket;
    kgoBsc.lineChartData = lineChart;
    kgoBsc.marketPrice = currentPrice;
    kgoBsc.change24h = priceChange24h;
    notifyListeners();
  }

  void setReady() {
    isReady = true;

    notifyListeners();
  }

  void resetConObject() {
    atd = Atd();
    kmpi = Kmpi();
    selBsc = Coin(
      id: 'selendra',
      symbol: 'SEL',
      logo: 'assets/SelendraCircle-Blue.png',
      org: 'BEP-20',
      isContain: true,
    );
    bnbSmartChain = Coin(
      id: 'binance smart chain',
      logo: 'assets/bnb.png',
      symbol: 'BNB',
      // org: 'Smart Chain',
      isContain: true,
    );

    token.clear();

    notifyListeners();
  }
}
