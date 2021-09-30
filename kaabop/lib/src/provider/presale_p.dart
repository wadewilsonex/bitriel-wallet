import 'dart:ffi';
import 'dart:math';

import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';

class PresaleProvider with ChangeNotifier {

  final String _presaleContract = "0xE0b8d681F8b26F6D897CC3922be0357C9116A852"; //Testnet
  DeployedContract _deployedContract;
  ContractProvider _contractP = ContractProvider();

  /// Property for support token
  PresaleConfig presaleConfig = PresaleConfig();

  /* --------------------------Write Contract--------------------- */

  /// 
  Future<void> orderBnbToken({@required BuildContext context, @required double amount, @required int discountRate}) async {
    print("AMount $amount");
    print("Discount rate $discountRate");
    try {

      final privateKey = await AppServices.getPrivateKey("1111", context);
      final credentials = await _contractP.bscClient.credentialsFromPrivateKey(privateKey);
      final myContractAddr = await StorageServices().readSecure('etherAdd');
      print("myContractAddr $myContractAddr");

      final preFunction = _deployedContract.function('order');
      print("preFunction");
      // final gasPrice = await _contractP.bscClient.getGasPrice();
      // final maxGas = await _contractP.bscClient.estimateGas(
      //   sender: EthereumAddress.fromHex(myContractAddr),
      //   to: _deployedContract.address,
      //   value: EtherAmount.inWei(BigInt.from(amount)),
      //   // data: preFunction.encodeCall([
      //   //   // BigInt.from(amount * pow(10, 18))]
      //   //   number
      //   // ]),
      // );
      // print("maxGas ${[BigInt.from(amount * pow(10, 18))]}");
      // print("Function ${preFunction.encodeCall([BigInt.from(100000000000000000)])}");
      // final hash = await approve(privateKey);

      // BUSD Contract
      // final ercDeploy = await _contractP.initBsc("0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee");
      // print("ercDeploy $ercDeploy");

      // final approve = ercDeploy.function('approve');

      // final maxGas = await _contractP.bscClient.estimateGas(
      //   sender: EthereumAddress.fromHex(myContractAddr),
      //   to: ercDeploy.address,
      //   data: approve.encodeCall(
      //     [
      //       EthereumAddress.fromHex(_presaleContract),
      //       BigInt.parse('1000000000000000042420637374017961984'),
      //     ],
      //   ),
      // );


      // final gasPrice = await _contractP.bscClient.getGasPrice();

      // final approveRes = await _contractP.bscClient.sendTransaction(
      //   credentials,
      //   Transaction.callContract(
      //     contract: ercDeploy,
      //     function: approve,
      //     gasPrice: gasPrice,
      //     maxGas: maxGas.toInt(),
      //     parameters: [
      //       EthereumAddress.fromHex(_presaleContract),
      //       BigInt.parse('1000000000000000042420637374017961984'),
      //     ],
      //   ),
      //   fetchChainIdFromNetworkId: true,
      // );

      // print("Approve res $approveRes");

      // final approveStatus = await _contractP.getPending(approveRes, nodeClient: _contractP.bscClient);
      // print("approveStatus $approveStatus");

      // final allowance = await _contractP.query(
      //   "0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee",
      //   'allowance',
      //   [
      //     EthereumAddress.fromHex(myContractAddr), // Correct
      //     EthereumAddress.fromHex(_presaleContract) // Correct
      //   ],
      // );

      // print("Allowance $allowance");

      final order = await _contractP.bscClient.sendTransaction(
        credentials, 
        Transaction.callContract(
          contract: _deployedContract, 
          function: preFunction, 
          // gasPrice: gasPrice,
          // maxGas: maxGas.toInt(),
          parameters: [
            EthereumAddress.fromHex("0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee"),
            BigInt.from(amount),
            BigInt.from(discountRate)
          ]
        ),
        fetchChainIdFromNetworkId: true
      );

      // _contractP.getPending();    
    } catch (e) {
      print("Error orderBnbToken $e");
    }
  }

  Future<String> approve(String pKey) async {
    String _hash;

    try {
      final hash = await _contractP.approveSwap(pKey);
      print("Has $hash");

      if (hash != null) {
        _hash = hash;
      }
    } catch (e) {
    }
    return _hash;
  }
  
  /* --------------------------Read Contract--------------------- */

  /// Deploy Contract Before Use Function
  /// 
  /// Use Inside app.dart
  Future<DeployedContract> initPresaleContract() async {
    try {

      final String abiCode = await rootBundle.loadString('assets/abi/presale.json');
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

  /// This Function Use To Get Price And Multiply With Input Amount for Investment
  Future<dynamic> getPriceToken({@required String supportedToken}) async {
    try{
      final preFunction = _deployedContract.function('getPriceToken');
      var res = await _contractP.bscClient.call(contract: _deployedContract, function: preFunction, params: [EthereumAddress.fromHex("$supportedToken")]);
      return res;
    } catch (e) {
      print("getPriceToken $e");
    }
  }

  /// Get Price Only BNB
  Future<dynamic> getBNBPrice() async {
    print("getBNBPrice function");
    try{
      final preFunction = _deployedContract.function('getPrice');
      var res = await _contractP.bscClient.call(contract: _deployedContract, function: preFunction, params: []);
      print("Response $res");
      return res;
    } catch (e) {
      print("getBNBToken $e");
    }
  }

  /// Get Price For Minimum investment
  Future<dynamic> minInvestment() async {
    try{
      final preFunction = _deployedContract.function('minInvestment');
      var res = await _contractP.bscClient.call(contract: _deployedContract, function: preFunction, params: []);
      print("Res $res");
      return res;
    } catch (e) {
      // print("getPriceToken $e");
    }
  }

  /// This method run after fetch token per each
  Future<List<Map<String, dynamic>>> fetchAndFillPrice(List<Map<String, dynamic>> supportTokenList) async {
    print("supportTokenList ${supportTokenList.length}");
    await _contractP.initBscClient();
    _deployedContract = await initPresaleContract();
    
    for(int i = 0; i < supportTokenList.length; i++){
      if (i == 0){
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
    return supportTokenList;
  }
}