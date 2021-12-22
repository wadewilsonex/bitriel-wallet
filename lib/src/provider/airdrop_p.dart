import 'dart:math';

import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';

class AirDropProvider with ChangeNotifier {

  final String contract = "0xb0DB809A5e28be3981771B5bbD6066E7996845Ca";

  DeployedContract? _deployedContract;
  ContractProvider? _contractP;

  AirDropProvider(){
    initContract();
  }

  /// Assign contract provider parameter
  set setConProvider(ContractProvider? con){
    _contractP = con;

    notifyListeners();
  }

  Future<DeployedContract> initContract() async {
    try {

      final String abi = await rootBundle.loadString(AppConfig.abiPath+"airdrop.json");
      _deployedContract = DeployedContract(
        ContractAbi.fromJson(abi, "AirdropClaim"),
        EthereumAddress.fromHex(contract)
      );
      
      notifyListeners();
    } catch (e){
      print("Error initContract $e");
    }

    return _deployedContract!;
  }

  /* --------------------Read Contract-------------------- */
  Future<void> airdropTokenAddress() async {
    print("airdropTokenAddress");
    try {

      await _contractP!.initBscClient();
      print("Finish contractP");
      final preFunction = _deployedContract!.function('airdropTokenAddress');
      print("finish preFunction");
      final res = await _contractP!.bscClient.call(
        contract: _deployedContract!, 
        function: preFunction, 
        params: []
      );

      print(res);
    } catch (e) {
      print("Error airdropTokenAddress $e");
    }
  }

  /* --------------------Write Contract-------------------- */
  Future<void> claim({double? amount, int? expiredDate, String? v, String? r, String? s}) async {
    print("airdropTokenAddress");
    try {

      await _contractP!.initBscClient();
      print("Finish contractP");
      final preFunction = _deployedContract!.function('claim');
      print("finish preFunction");
      final res = await _contractP!.bscClient.call(
        contract: _deployedContract!, 
        function: preFunction, 
        params: [
          BigInt.from(amount! * pow(10, 18)),
          BigInt.from(expiredDate! * pow(10, 18)),
          // BigInt.from(v!),
        ]
      );

      print(res);
    } catch (e) {
      print("Error airdropTokenAddress $e");
    }
  }

}