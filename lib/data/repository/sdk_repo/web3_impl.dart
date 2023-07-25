import 'package:bitriel_wallet/index.dart';

class Web3RepoImpl implements Web3Repository {

  final Web3Blockchain _web3blockchain = Web3Blockchain();

  Web3Client get getBscClient => _web3blockchain.bscClient!;
  Web3Client get getEthClient => _web3blockchain.ethClient!;

  /// Connect Both Ethereum Network and Binance Smart Chain
  @override
  Future<void> web3Init() async {

    await _web3blockchain.initBscClient();
    await _web3blockchain.initEthClient();
    
  }

  Future<List<dynamic>> callWeb3ContractFunc(Web3Client client, DeployedContract contract, ContractFunction function, { List? params }) async {
    return (await client.call(
      contract: contract, 
      function: function, 
      params: params!
    ));
  }
}