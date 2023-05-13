import 'package:http/http.dart';
import 'package:wallet_apps/index.dart';

class EventProvider with ChangeNotifier {

  final String _contractAddr = "0x5Cf7e674595dea418BD7E0ad173905de5082bB3D";
  
  // ignore: unnecessary_nullable_for_final_variable_declarations, prefer_final_fields
  bool _isAdmin = true;
  bool _isValidQr = false;

  get getIsAdmin => _isAdmin;
  get getIsValidQr => _isValidQr;

  Web3Client? _web3client;
  final Client _client = Client();
  DeployedContract? deployedContract;

  initEventContract() async {
    
    
    _web3client = Web3Client('https://rpc0-indranet.selendra.org/evm', _client);
    deployedContract = await getContract();

    notifyListeners();
  }

  Future<DeployedContract> getContract() async {
    
    String abi = await rootBundle.loadString('assets/abi/NftTicket.json');
    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(abi, 'NftTicket'), 
      EthereumAddress.fromHex(_contractAddr)
    );

    return contract;
  }

  // get Balance Of
  // recipient = receiver
  Future<List<dynamic>> queryBalanceOf({String recipient = '0xa7f5f726B2395Af66A2A4F5Cb6FD903E596c37c7'}) async {
    

    try {
      await _web3client!.call(
        contract: deployedContract!, 
        function: deployedContract!.function('balanceOf'), 
        params: [

          EthereumAddress.fromHex(recipient)
        ]
      );
    } catch (e) {

    }
    return [];
  }

  // List NFT ID (Token) 
  // recipient = receiver
  Future<List<dynamic>> queryTokenOf({String recipient = '0xa7f5f726B2395Af66A2A4F5Cb6FD903E596c37c7'}) async {
    

    try {
      await _web3client!.call(
        contract: deployedContract!, 
        function: deployedContract!.function('recipient'), 
        params: [

          EthereumAddress.fromHex(recipient)
        ]
      );
    } catch (e) {
      
    }
    return [];
  }

  // Ticket Redeem
  Future<List<dynamic>> redeemQRCodeTicket() async {
    

    try {
      await _web3client!.call(
        contract: deployedContract!, 
        function: deployedContract!.function('redeemWithSignature'), 
        params: [
          EthPrivateKey.fromHex("0x"),
          [1],

        ]
      );
    } catch (e) {
      
    }
    return [];
  }

  bool qrValidator(String qr){
    
    try {
      Map<String, dynamic> decode = json.decode(qr);

      if ( (decode.containsKey('type')) && (decode.containsKey('data'))){
        if ( (decode['data'].containsKey('tokenOwner')) && (decode['data'].containsKey('tokenIds')) && (decode['data'].containsKey('_signature'))  ){

          _isValidQr = true;
        }
      }
    } catch (e) {
      
      return false;
    }

    return _isValidQr;

  }

}