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

  Future<dynamic> signMessage(BuildContext context) async {
    final apiPro = await Provider.of<ApiProvider>(context, listen: false);
    return await apiPro.getSdk.webView!.evalJavascript("settings.signMessage('${Provider.of<ContractProvider>(context, listen: false).ethAdd}')").then((value) async {
      print("resolve $value");
      return await claim(context: context, amount: value['value'], expiredDate: value['expiredAt'], v: value['sig']['v'], r: List<int>.from(value['r']), s: List<int>.from(value['s']));
    });
  }

  /* --------------------Write Contract-------------------- */
  Future<String> claim({String? amount, int? expiredDate, String? v, List<int>? r, List<int>? s, @required BuildContext? context}) async {
    print("airdropTokenAddress");

    try {

      await _contractP!.initBscClient();
      final preFunction = _deployedContract!.function('claim');

          // EthereumAddress.fromHex(v);
          // EthereumAddress.fromHex(r!);
          // EthereumAddress.fromHex(s!);
      // final res = await _contractP!.bscClient.call(
      //   contract: _deployedContract!, 
      //   function: preFunction, 
      //   params: [
      //     BigInt.from(amount! * pow(10, 18)),
      //     BigInt.from(expiredDate!),
      //     v,
      //     BigInt.parse(r!),
      //     BigInt.parse(s!)
      //     // v.codeUnits,
      //     // v.codeUnits
      //     // BigInt.from(int.parse(v)),
      //     // BigInt.from(int.parse(v))
      //     // utf8.encode(r!),
      //     // utf8.encode(s!)
      //   ]
      // );

      // print("Amount ${BigInt.parse(amount!)}");
      // print("Amount $expiredDate");
      // print("Amount ${BigInt.parse(v!)}");
      // print("R $r");
      // print("S $s");
      // print("Utf8 ${utf8.encode(r!)}");
      // print("Utf8 ${utf8.encode(s!)}");

      final getPin = await Component.pinDialogBox(context!);

      final privateKey = await AppServices.getPrivateKey(getPin, context);

      print("privateKey $privateKey");

      if (privateKey != null || privateKey != ''){

        final credentials = await EthPrivateKey.fromHex(privateKey!);

        final res = await _contractP!.bscClient.sendTransaction(
          credentials,
          Transaction.callContract(
            contract: _deployedContract!,
            function: preFunction,
            // maxGas: 2145000,
            parameters: [
              BigInt.parse(amount!),
              BigInt.from(expiredDate!),
              BigInt.parse(v!),
              Uint8List.fromList(r!),//rHash.hashString(HashType.SHA256,  )),
              Uint8List.fromList(s!)//rHash.hashString(HashType.SHA256, s ))
            ]
          ),
          chainId: null,
          fetchChainIdFromNetworkId: true
        );

        print("my res $res");
        return res;
      }
    }  
    on FormatException catch (f){
      print("hello format ${f.message}");
      print("Error format airdropTokenAddress $e");
    }
    catch (e) {
      print("Error airdropTokenAddress $e");
      return ''; 
    }
  
    return '';
  }

}