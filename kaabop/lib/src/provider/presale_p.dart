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

    final res = await AppServices.getPrivateKey("1234", context); 
    final credentials = await _contractP.bscClient.credentialsFromPrivateKey(res);
    final preFunction = _deployedContract.function('order');

    final order = _contractP.bscClient.call(contract: _deployedContract, function: preFunction, params: [
        amount,
        discountRate
      ]);
    // .sendTransaction(
    //   credentials, 
    //   Transaction.callContract(contract: _deployedContract, function: preFunction, parameters: [
    //     amount,
    //     discountRate
    //   ])
    // );

    // _contractP.getPending();    
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