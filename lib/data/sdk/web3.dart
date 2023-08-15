/* Ethereum-Compatible blockchain means both Binance Smart Chain (BSC) and Ethereum Network both are compatible with EVM*/
import 'package:bitriel_wallet/index.dart';

class Web3Blockchain {

  Client? client; 
  Web3Client? bscClient, ethClient;

  bool isMainnet = false;

  set setIsMainnet(bool value) {
    isMainnet = value;
  }

  /// BSC
  String bscUrlMainnet = "https://bsc-dataseed.binance.org/";
  String bscUrlTestnet = "https://data-seed-prebsc-2-s1.binance.org:8545/";

  String bscwsMainnet = "wss://bsc-ws-node.nariox.org:443";
  String bscwsTestnet = "wss://bsc-ws-node.nariox.org:443";

  /// Link Of rpc testnet 
  // https://developer.arbitrum.io/node-running/node-providers#rpc-endpoints

  /// Ethereum
  // String ethUrlMainnet = "https://arb1.arbitrum.io/rpc";
  // String ethUrlTestnet = "https://goerli-rollup.arbitrum.io/rpc";

  // String ethwsMainnet = "wss://arb1.arbitrum.io/feed";
  // String ethwsTestnet = "wss://goerli-rollup.arbitrum.io/feed";
  // String ethUrlMainnet = "https://arbitrum-mainnet.infura.io/93a7248515ca45d0ba4bbbb8c33f1bda";
  
  String ethUrlMainnet = "https://mainnet.infura.io/v3/cc2b23795b984a859b1ead3e058b3bcf";
  String ethUrlTestnet = "https://goerli.infura.io/v3/cc2b23795b984a859b1ead3e058b3bcf";

  String ethwsMainnet = "wss://mainnet.infura.io/ws/v3/cc2b23795b984a859b1ead3e058b3bcf";
  String ethwsTestnet = "wss://goerli.infura.io/ws/v3/cc2b23795b984a859b1ead3e058b3bcf";

  Future<void> initBscClient() async {
    client = Client();
    bscClient = Web3Client( isMainnet ? bscUrlMainnet : bscUrlTestnet, client!, socketConnector: (){
      return IOWebSocketChannel.connect( isMainnet ? bscwsMainnet : bscwsTestnet ).cast<String>();
    });
    
  }

  Future<void> initEthClient() async {
    client = Client();
    ethClient = Web3Client( isMainnet ? ethUrlMainnet : ethUrlTestnet, client!, socketConnector: (){
      return IOWebSocketChannel.connect(isMainnet ? ethwsMainnet : ethwsTestnet).cast<String>();
    });

  }

}