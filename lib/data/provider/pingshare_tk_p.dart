import 'package:wallet_apps/index.dart';

/// PING SHARE TOKEN
class PingShareTKProvider extends ChangeNotifier {

  Future<void> init() async {
    // _nftContractAddr = dotenv.get('NFT');
  }

  /// First Step
  /// 
  Future<void> initNFTContract(BuildContext context) async {

    // try {
    //   _provider = Provider.of<ContractProvider>(context, listen: false);

    //   // Contract Object
    //   _deployedContract = await AppUtils.contractfromAssets(AppConfig.mdwAbi, _nftContractAddr!, contractName: "MDWTicket");
      
    //   // Init Web3 Client
    //   _mdwClient = Web3Client(ApiProvider().isMainnet ? AppConfig.networkList[4].httpUrlMN! : AppConfig.networkList[4].httpUrlTN!, Client());
    // } catch (e) {
    //   debugPrint("Err initNFTContract $e");
    // }
  }

  /// Second Step
  /// 
  Future<void> fetchItemsByAddress() async {
    // model.tickets = [];
    // // Initialize Contract Service Object With Contract Object
    // debugPrint("_provider!.ethAdd ${_provider!.ethAdd}");
    // try {
    //   debugPrint("deployContract");
    //   await _mdwClient!.call(
    //     contract: _deployedContract!, 
    //     function: _deployedContract!.function("fetchItemsByAddress"), 
    //     params: [
    //       EthereumAddress.fromHex(_provider!.ethAdd),
    //       BigInt.from(1)
    //     ]
    //   ).then((value) {
    //     model.tickets = List<BigInt>.from(value[0]);
        
    //     notifyListeners();
    //   });
    // } catch (e) {
    //   debugPrint("Err fetchItemsByAddress $e");
    // }
  }

}