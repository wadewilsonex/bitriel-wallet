import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/mdw_m.dart';
import 'package:wallet_apps/src/service/contract.dart';

/// Meta Doers World
class MDWProvider extends ChangeNotifier {

  String? _nftContractAddr;

  ContractProvider? _provider;

  DeployedContract? _deployedContract;
  
  ContractService? _mdwContractService;

  Web3Client? _mdwClient;

  MDWModel model = MDWModel();

  Future<void> init() async {
    print("init");
    _nftContractAddr = dotenv.get('NFT');
  }

  /// First Step
  /// 
  Future<void> initNFTContract(BuildContext context) async {

    try {
      _provider = Provider.of<ContractProvider>(context, listen: false);

      // Contract Object
      _deployedContract = await AppUtils.contractfromAssets(AppConfig.mdwAbi, _nftContractAddr!, contractName: "MDWTicket");
      
      // Init Web3 Client
      _mdwClient = Web3Client(ApiProvider().isMainnet ? AppConfig.networkList[4].httpUrlMN! : AppConfig.networkList[4].httpUrlTN!, Client());
    } catch (e) {
      print("Err initNFTContract $e");
    }
  }

  /// Second Step
  /// 
  Future<void> fetchItemsByAddress() async {
    model.tickets = [];
    // Initialize Contract Service Object With Contract Object
    print("_provider!.ethAdd ${_provider!.ethAdd}");
    try {
      print("deployContract");
      await _mdwClient!.call(
        contract: _deployedContract!, 
        function: _deployedContract!.function("fetchItemsByAddress"), 
        params: [
          EthereumAddress.fromHex(_provider!.ethAdd),
          BigInt.from(1)
        ]
      ).then((value) {
        model.tickets = List<BigInt>.from(value[0]);
        
        notifyListeners();
      });
    } catch (e) {
      print("Err fetchItemsByAddress $e");
    }
  }

}