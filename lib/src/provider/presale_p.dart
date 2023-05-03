import 'dart:math';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';

class PresaleOrderInfo {

  int id;
  String amount;
  String redeemDateTime;
  bool isBefore;
  bool isClaimed;

  PresaleOrderInfo(this.id, this.amount, this.redeemDateTime, this.isBefore, this.isClaimed);
}

class PresaleProvider with ChangeNotifier {
  
  final String _presaleContract = PresaleConfig().mainNet;
  DeployedContract? _deployedContract;
  ContractProvider? _contractP;
  
  set setConProvider(ContractProvider? con){
    _contractP = con;
    notifyListeners();
  }

  double estSel = 0.00;

  List<PresaleOrderInfo> presaleOrderInfo = [];

  /// Property for support token
  PresaleConfig presaleConfig = PresaleConfig();

  // PresaleProvider(){
  //   initPresaleContract();
  // }

  /* --------------------------Write Contract--------------------- */

  Future<String?> redeem({@required String? privateKey, @required int? orderId}) async {
    String? hash;
    try {
      await _contractP!.initBscClient();
      final contract = await initPresaleContract();

      final credentials = EthPrivateKey.fromHex(privateKey!);
      // final myAddr = await StorageServices.readSecure(DbKey.ethAddr);

      final redeemFunction = contract!.function('redeem');
      final redeemHash = await _contractP!.bscClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: redeemFunction,
          maxGas: 2145000,
          parameters: [BigInt.from(orderId!)]
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );

      hash = redeemHash;
    } catch (e) {
      if (kDebugMode) {
        
      }
    }

    return hash;
  }

  Future<String?> orderUsingBnb({ 
    @required BuildContext? context,
    @required double? amount,
    @required String? privateKey,
    @required int? discountRate
  }) async {

    String? hash;
    try {
      
      await _contractP!.initBscClient();
      final contract = await initPresaleContract();

      final credentials = EthPrivateKey.fromHex(privateKey!);
      // final myAddr = await StorageServices.readSecure(DbKey.ethAddr);

      final orderFunction = contract!.function('order');
      final orderHash = await _contractP!.bscClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: orderFunction,
          maxGas: 2145000,
          value: EtherAmount.inWei(BigInt.from(amount! * pow(10, 18))),
          parameters: [BigInt.from(discountRate!)
          ]
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );

      hash = orderHash;
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }

    return hash;
  }

  Future<String?> orderUsingToken({
    @required BuildContext? context,
    @required String? suppTokenAddr,
    @required String? privateKey,
    @required double? amount,
    @required int? discountRate
  }) async {
    String? hash;
    try {
      await _contractP!.initBscClient();
      final contract = await initPresaleContract();

      final credentials = EthPrivateKey.fromHex(privateKey!);

      final orderToken = contract!.function('orderToken');

      final order = await _contractP!.bscClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: orderToken,
          maxGas: 2145000,
          parameters: [
            EthereumAddress.fromHex(suppTokenAddr!),
            BigInt.from(amount! * pow(10, 18)),
            BigInt.from(discountRate!)
          ]
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true
      );

      hash = order;

    } catch (e) {
      if (kDebugMode) {
        
      }
    }

    return hash;
  }

  Future<String> approvePresale(String privateKey, String tokenAddress) async {
    try {

      await _contractP!.initBscClient();
      final contract = await _contractP!.initBsc(tokenAddress);
      final ethFunction = contract!.function('approve');

      final credentials = EthPrivateKey.fromHex(privateKey);

      final gasPrice = await _contractP!.bscClient.getGasPrice();

      final maxGas = await _contractP!.bscClient.estimateGas(
        sender: EthereumAddress.fromHex(_contractP!.ethAdd),
        to: contract.address,
        data: ethFunction.encodeCall(
          [
            EthereumAddress.fromHex(_presaleContract),
            BigInt.parse('1000000000000000042420637374017961984'),
          ],
        ),
      );

      final approve = await _contractP!.bscClient.sendTransaction(
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
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );

      return approve;
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
    return '';
  }

  /* --------------------------Read Contract--------------------- */

  /// Deploy Contract Before Use Function
  ///
  /// Use Inside app.dart
  Future<DeployedContract?> initPresaleContract() async {
    
      if (kDebugMode) {
        
      }
    
    try {
      final String abiCode = await rootBundle.loadString('${AppConfig.abiPath}presale1.json');
      _deployedContract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'Presale'),
        EthereumAddress.fromHex(_presaleContract),
      );

      notifyListeners();
      return _deployedContract;
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
    return null;
  }

  Future<double> checkTokenBalance(String tokenAddress, {@required BuildContext? context}) async {
    try {

      final balance = await ContractProvider().query(
        tokenAddress,
        'balanceOf',
        [EthereumAddress.fromHex(_contractP!.ethAdd)],
      );

      return Fmt.bigIntToDouble(balance[0] as BigInt, 18);
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
    return 0.0;
  }

  Future<List> getInvestorOrderIds() async {

    List<dynamic> idRes = [];

    try {
      
      final preFunction = _deployedContract!.function('investorOrderIds');
      final List res = await _contractP!.bscClient.call(
        contract: _deployedContract!,
        function: preFunction,
        params: [EthereumAddress.fromHex(_contractP!.ethAdd)]
      );

      if (res.isNotEmpty) idRes = List.from(res.first);
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }

    return idRes;
  }

  Future<dynamic> getOrders(int id) async {
    try {
      await _contractP!.initBscClient();
      _deployedContract = await initPresaleContract();
      final preFunction = _deployedContract!.function('orders');
      final res = await _contractP!.bscClient.call(
        contract: _deployedContract!,
        function: preFunction,
        params: [BigInt.from(id)]
      );

      return res;
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
  }

  /// This Function Use To Get Price And Multiply With Input Amount for Investment
  Future<dynamic> getPriceToken({@required String? supportedToken}) async {

    try {
      await _contractP!.initBscClient();
      final preFunction = _deployedContract!.function('getPriceToken');
      var res = await _contractP!.bscClient.call(
        contract: _deployedContract!,
        function: preFunction,
        params: [EthereumAddress.fromHex("$supportedToken")]
      );
      return res;
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
  }

  /// Get Price Only BNB
  Future<dynamic> getBNBPrice() async {
    try {
      // await _contractP.initBscClient();
      final preFunction = _deployedContract!.function('getPrice');
      var res = await _contractP!.bscClient.call(contract: _deployedContract!, function: preFunction, params: []);

      return res;
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
  }

  /// Get Price For Minimum investment
  Future<dynamic> minInvestment() async {
    try {
      _deployedContract = await initPresaleContract();

      final preFunction = _deployedContract!.function('minInvestment');
      var res = await _contractP!.bscClient.call(contract: _deployedContract!, function: preFunction, params: []);
      return res;
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
  }

  /// This method run after fetch token per each
  Future<List<Map<String, dynamic>>> fetchAndFillPrice(List<Map<String, dynamic>> supportTokenList) async {
    try {

      _deployedContract = await initPresaleContract();

      for (int i = 0; i < supportTokenList.length; i++) {
        if (i == 0) {
          await getBNBPrice().then((value) {
            supportTokenList[0].addAll({"price": double.parse(value[0].toString()) / pow(10, 8)});
          });
        } else {
          await getPriceToken(supportedToken: supportTokenList[i]['tokenAddress']).then((value) {
            supportTokenList[i].addAll({"price": double.parse(value[0].toString()) / pow(10, 8)});
          });
        }
      }
      notifyListeners();
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
    return supportTokenList;
  }

  Future<dynamic> checkAllowance(String tokenAddress) async {
    
    await _contractP!.initBscClient();

    final contract = await _contractP!.initBsc(tokenAddress);

    final allowanceFunc = contract!.function('allowance');

    final res = await _contractP!.bscClient.call(contract: contract, function: allowanceFunc, params: [
      EthereumAddress.fromHex(_contractP!.ethAdd),
      EthereumAddress.fromHex(_presaleContract),
    ]);

    return res.first;
  }

  /* --------------------------Helper Function--------------------- */

  Future<void> setListOrder() async {
    
      if (kDebugMode) {
        
      }
    
    try {

      presaleOrderInfo.clear();
      final orderIds = await getInvestorOrderIds();

      for (int i = 0; i < orderIds.length; i++) {
        final orderInfo = await getOrders(int.parse(orderIds[i].toString()));

        final amt = Fmt.bigIntToDouble(
          orderInfo[1] as BigInt,
          int.parse('18'),
        ).toStringAsFixed(6);

        dynamic timeStamp = AppUtils.timeStampToDate(int.parse(orderInfo[2].toString()));

        final isClaimed = orderInfo[3];

        DateTime date = DateTime.now();

        var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(orderInfo[2].toString()) * 10000);

        bool isBefore = date.isBefore(dt);

        presaleOrderInfo.add(PresaleOrderInfo(int.parse(orderIds[i].toString()), amt, timeStamp, isBefore, isClaimed));
      }
      notifyListeners();
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
  }

  void initEstSel() {
    estSel = 0.00;
    notifyListeners();
  }

  void calEstimateSel(String amt, double assetPrice, int discountRate) {
    // Ex: BNB amount * BNB price / SEL price after discount
    // 10% disc = 0.027 USD per SEL
    // 20% disc = 0.025 USD per SEL
    // 30% disc = 0.021 USD per

    double estSel = 0.00;

    final bool isValid = _isNumeric(amt);

    if (isValid) {
      switch (discountRate) {
        case 10:
          estSel = double.parse(amt) * assetPrice / 0.027;
          break;
        case 20:
          estSel = double.parse(amt) * assetPrice / 0.025;
          break;
        case 30:
          estSel = double.parse(amt) * assetPrice / 0.021;
          break;
      }

      estSel = estSel;
    }

    notifyListeners();
  }

  double calAmtPrice(String amt, double assetPrice) {
    double estSel = 0.00;

    final isValid = _isNumeric(amt);

    if (isValid) {
      estSel = double.parse(amt) * assetPrice;
    }

    return estSel;
  }

  bool _isNumeric(String? str) {
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
