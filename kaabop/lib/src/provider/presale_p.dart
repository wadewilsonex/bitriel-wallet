import 'dart:math';

import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';

class PresaleOrderInfo {
  int id;
  String amount;
  String redeemDateTime;
  bool isBefore;
  bool isClaimed;

  PresaleOrderInfo(
      this.id, this.amount, this.redeemDateTime, this.isBefore, this.isClaimed);
}

class PresaleProvider with ChangeNotifier {
  final String _presaleContract =
      "0xeBf7E248689534C2757a20DCfe7ffe0bb04b9e93"; //Testnet
  DeployedContract _deployedContract;
  ContractProvider _contractP = ContractProvider();

  double estSel = 0.00;

  List<PresaleOrderInfo> presaleOrderInfo = [];

  /// Property for support token
  PresaleConfig presaleConfig = PresaleConfig();

  /* --------------------------Write Contract--------------------- */

  Future<String> redeem(
      {@required String privateKey, @required int orderId}) async {
    String hash;
    try {
      await _contractP.initBscClient();
      final contract = await initPresaleContract();

      final credentials =
          await _contractP.bscClient.credentialsFromPrivateKey(privateKey);
      // final myAddr = await StorageServices().readSecure('etherAdd');

      final redeemFunction = contract.function('redeem');
      final redeemHash = await _contractP.bscClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: redeemFunction,
            maxGas: 2145000,
            parameters: [BigInt.from(orderId)]),
        fetchChainIdFromNetworkId: true,
      );

      hash = redeemHash;
    } catch (e) {}

    return hash;
  }

  Future<String> orderUsingBnb(
      {@required BuildContext context,
      @required double amount,
      @required String privateKey,
      @required int discountRate}) async {
    String hash;
    try {
      await _contractP.initBscClient();
      final contract = await initPresaleContract();

      final credentials =
          await _contractP.bscClient.credentialsFromPrivateKey(privateKey);
      // final myAddr = await StorageServices().readSecure('etherAdd');

      final orderFunction = contract.function('order');
      final orderHash = await _contractP.bscClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: orderFunction,
            maxGas: 2145000,
            value: EtherAmount.inWei(BigInt.from(amount * pow(10, 18))),
            parameters: [BigInt.from(discountRate)]),
        fetchChainIdFromNetworkId: true,
      );

      hash = orderHash;
    } catch (e) {}

    return hash;
  }

  Future<String> orderUsingToken(
      {@required BuildContext context,
      @required String suppTokenAddr,
      @required String privateKey,
      @required double amount,
      @required int discountRate}) async {
    String hash;
    try {
      await _contractP.initBscClient();
      final contract = await initPresaleContract();

      final credentials =
          await _contractP.bscClient.credentialsFromPrivateKey(privateKey);

      final orderToken = contract.function('orderToken');

      print(amount * pow(10, 18));
      final order = await _contractP.bscClient.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract,
              function: orderToken,
              maxGas: 2145000,
              parameters: [
                EthereumAddress.fromHex(suppTokenAddr),
                BigInt.from(amount * pow(10, 18)),
                BigInt.from(discountRate)
              ]),
          fetchChainIdFromNetworkId: true);

      if (order != null) {
        hash = order;
      }
    } catch (e) {}

    return hash;
  }

  Future<String> approvePresale(String privateKey, String tokenAddress) async {
    await _contractP.initBscClient();
    final contract = await _contractP.initBsc(tokenAddress);
    final ethFunction = contract.function('approve');

    final credentials =
        await _contractP.bscClient.credentialsFromPrivateKey(privateKey);

    final ethAddr = await StorageServices().readSecure('etherAdd');

    final gasPrice = await _contractP.bscClient.getGasPrice();

    final maxGas = await _contractP.bscClient.estimateGas(
      sender: EthereumAddress.fromHex(ethAddr),
      to: contract.address,
      data: ethFunction.encodeCall(
        [
          EthereumAddress.fromHex(_presaleContract),
          BigInt.parse('1000000000000000042420637374017961984'),
        ],
      ),
    );

    final approve = await _contractP.bscClient.sendTransaction(
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

  /* --------------------------Read Contract--------------------- */

  /// Deploy Contract Before Use Function
  ///
  /// Use Inside app.dart
  Future<DeployedContract> initPresaleContract() async {
    try {
      final String abiCode =
          await rootBundle.loadString('assets/abi/presale1.json');
      final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'Presale'),
        EthereumAddress.fromHex(_presaleContract),
      );

      notifyListeners();
      return contract;
    } catch (e) {
      print("Error init presale contract $e");
    }
    return null;
  }

  Future<double> checkTokenBalance(String tokenAddress) async {
    final myAddr = await StorageServices().readSecure('etherAdd');
    final balance = await ContractProvider().query(
      tokenAddress,
      'balanceOf',
      [EthereumAddress.fromHex(myAddr)],
    );

    return Fmt.bigIntToDouble(balance[0] as BigInt, 18);
  }

  Future<List> getInvestorOrderIds() async {
    List<dynamic> idRes = [];

    try {
      final myAddr = await StorageServices().readSecure('etherAdd');
      final preFunction = _deployedContract.function('investorOrderIds');
      final res = await _contractP.bscClient.call(
          contract: _deployedContract,
          function: preFunction,
          params: [EthereumAddress.fromHex("$myAddr")]);

      if (res != null) idRes = List.from(res.first);
    } catch (e) {
      // print("getPriceToken $e");
    }

    return idRes;
  }

  Future<dynamic> getOrders(int id) async {
    await _contractP.initBscClient();
    _deployedContract = await initPresaleContract();
    try {
      final preFunction = _deployedContract.function('orders');
      final res = await _contractP.bscClient.call(
          contract: _deployedContract,
          function: preFunction,
          params: [BigInt.from(id)]);

      return res;
    } catch (e) {
      print("getOrder $e");
    }
  }

  // Future

  /// This Function Use To Get Price And Multiply With Input Amount for Investment
  Future<dynamic> getPriceToken({@required String supportedToken}) async {
    try {
      final preFunction = _deployedContract.function('getPriceToken');
      var res = await _contractP.bscClient.call(
          contract: _deployedContract,
          function: preFunction,
          params: [EthereumAddress.fromHex("$supportedToken")]);
      return res;
    } catch (e) {
      print("getPriceToken $e");
    }
  }

  /// Get Price Only BNB
  Future<dynamic> getBNBPrice() async {
    try {
      final preFunction = _deployedContract.function('getPrice');
      var res = await _contractP.bscClient
          .call(contract: _deployedContract, function: preFunction, params: []);

      return res;
    } catch (e) {
      print("getBNBToken $e");
    }
  }

  /// Get Price For Minimum investment
  Future<dynamic> minInvestment() async {
    try {
      print('min');
      _deployedContract = await initPresaleContract();

      final preFunction = _deployedContract.function('minInvestment');
      var res = await _contractP.bscClient
          .call(contract: _deployedContract, function: preFunction, params: []);
      print("Res $res");
      return res;
    } catch (e) {
      // print("getPriceToken $e");
    }
  }

  /// This method run after fetch token per each
  Future<List<Map<String, dynamic>>> fetchAndFillPrice(
      List<Map<String, dynamic>> supportTokenList) async {
    await _contractP.initBscClient();
    _deployedContract = await initPresaleContract();

    for (int i = 0; i < supportTokenList.length; i++) {
      if (i == 0) {
        await getBNBPrice().then((value) {
          supportTokenList[0].addAll(
              {"price": double.parse(value[0].toString()) / pow(10, 8)});
        });
      } else {
        await getPriceToken(supportedToken: supportTokenList[i]['tokenAddress'])
            .then((value) {
          supportTokenList[i].addAll(
              {"price": double.parse(value[0].toString()) / pow(10, 8)});
        });
      }
    }
    notifyListeners();
    return supportTokenList;
  }

  Future<dynamic> checkAllowance(String tokenAddress) async {
    await _contractP.initBscClient();

    final contract = await _contractP.initBsc(tokenAddress);

    final allowanceFunc = contract.function('allowance');

    final ethAddr = await StorageServices().readSecure('etherAdd');

    final res = await _contractP.bscClient
        .call(contract: contract, function: allowanceFunc, params: [
      EthereumAddress.fromHex(ethAddr),
      EthereumAddress.fromHex(_presaleContract),
    ]);

    return res.first;
  }

  /* --------------------------Helper Function--------------------- */

  Future<void> setListOrder() async {
    presaleOrderInfo.clear();
    final orderIds = await getInvestorOrderIds();

    for (int i = 0; i < orderIds.length; i++) {
      final orderInfo = await getOrders(int.parse(orderIds[i].toString()));

      final amt = Fmt.bigIntToDouble(
        orderInfo[1] as BigInt,
        int.parse('18'),
      ).toStringAsFixed(6);
      final timeStamp = AppUtils.timeStampToDateTime(orderInfo[2].toString());
      final isClaimed = orderInfo[3];

      DateTime date = DateTime.now();

      var dt = DateTime.fromMillisecondsSinceEpoch(
          int.parse(orderInfo[2].toString()) * 1000);

      bool isBefore = date.isBefore(dt);

      presaleOrderInfo.add(
        PresaleOrderInfo(int.parse(orderIds[i].toString()), amt, timeStamp,
            isBefore, isClaimed),
      );
    }
    notifyListeners();
  }

  void initEstSel() {
    estSel = 0.00;
    notifyListeners();
  }

  void calEstimateSel(String amt, double assetPrice, int discountRate) {
    //  Ex: BNB amount * BNB price / SEL price after discount
    //   10% disc = 0.027 USD per SEL
    // 20% disc = 0.025 USD per SEL
    // 30% disc = 0.021 USD per

    double _estSel = 0.00;

    final isValid = _isNumeric(amt);

    if (isValid != null && isValid) {
      switch (discountRate) {
        case 10:
          _estSel = double.parse(amt) * assetPrice / 0.027;
          break;
        case 20:
          _estSel = double.parse(amt) * assetPrice / 0.025;
          break;
        case 30:
          _estSel = double.parse(amt) * assetPrice / 0.021;
          break;
      }

      estSel = _estSel;
    }

    notifyListeners();
  }

  double calAmtPrice(String amt, double assetPrice) {
    double _estSel = 0.00;

    final isValid = _isNumeric(amt);

    if (isValid) {
      _estSel = double.parse(amt) * assetPrice;
    }

    return _estSel;
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void setInitEstSel() {
    estSel = 0.00;
    notifyListeners();
  }
}
