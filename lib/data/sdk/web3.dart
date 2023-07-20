/* Ethereum-Compatible blockchain means both Binance Smart Chain (BSC) and Ethereum Network both are compatible with EVM*/
import 'package:bitriel_wallet/index.dart';

class Web3Blockchain {

  Client? client; 
  Web3Client? bscClient, ethClient;

  Future<void> initBscClient() async {
    client = Client();
    bscClient = Web3Client("https://bsc-dataseed.binance.org/", client!, socketConnector: (){
      return IOWebSocketChannel.connect("wss://bsc-ws-node.nariox.org:443").cast<String>();
    });
    
  }

  Future<void> initEthClient() async {
    client = Client();
    ethClient = Web3Client("https://mainnet.infura.io/v3/93a7248515ca45d0ba4bbbb8c33f1bda", client!, socketConnector: (){
      return IOWebSocketChannel.connect("wss://mainnet.infura.io/ws/v3/93a7248515ca45d0ba4bbbb8c33f1bda").cast<String>();
    });
  }

}