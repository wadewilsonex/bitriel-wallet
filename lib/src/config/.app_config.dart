/* This file hold app configurations. */
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/network_params.dart';

class AppConfig {
  // QR Embedded
  static String logoQrEmbedded = "assets/SelendraQr-1.png";

  /*Google spreedsheet id for claim airdrop */
  static const spreedSheetId = '1hFKqaUe1q_6A-b-_ZnEAC574d51fCi1bTWQKCluHF2E';

  /*Coingecko api url fetch asset price */
  static String coingeckoBaseUrl = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=';
   //'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=
    // ''';

  static const erc20Abi = 'assets/abi/erc20.json';

  static const bep20Abi = 'assets/abi/bep20.json';

  static const swapAbi = 'assets/abi/swap.json';

  static const atdAbi = 'assets/abi/atd.json';

  static const mdwAbi = 'assets/abi/MDWTicket.json';

  late ApiProvider api;
  late String swapAddr;

  AppConfig(){
    if (ApiProvider().isMainnet){
      swapAddr = '0xa857d61c5802C4e299a5B972DE1ACCaD085cE765';
    } else {
      swapAddr = '0xE5DD12570452057fc85B8cE9820aD676390f865B';
    }
  }

  /*All network list that bitriel wallet support*/
  static List<NetworkParams> networkList = [
    /// [0]= selendra, [1]= polkadot, [2] = ethereum, [3] = binance smart chain
    /// [4] HardHat 
    
    NetworkParams(
      httpUrlTN: 'https://rpc.testnet.selendra.org/',
      httpUrlMN: 'https://app.selendra.org/',
      wsUrlTN: 'wss://rpc-testnet.selendra.org', // TheNatte (1)
      // wsUrlTN: 'wss://rpc-sabay-testnet.selendra.org', // Sabay (2)
      // wsUrlMN: 'wss://rpc-mainnet2.selendra.org', // Ocean (2)
      // wsUrlMN: 'wss://rpc-mainnet.selendra.org', // Sabay (1)
      wsUrlMN: 'wss://rpc0.selendra.org', // ReleayChain (1)
      ss58: 204,
      ss58MN: 204
    ),
    
    NetworkParams(
      wsUrlMN: 'wss://rpc.polkadot.io',
      wsUrlTN: 'wss://westend-rpc.polkadot.io',
      ss58: 0,
    ),

    // Ethereum
    NetworkParams(
      httpUrlMN: 'https://mainnet.infura.io/v3/93a7248515ca45d0ba4bbbb8c33f1bda',
      wsUrlMN: 'wss://mainnet.infura.io/ws/v3/93a7248515ca45d0ba4bbbb8c33f1bda',
      httpUrlTN: 'https://rinkeby.infura.io/v3/93a7248515ca45d0ba4bbbb8c33f1bda',
      wsUrlTN: 'wss://rinkeby.infura.io/ws/v3/93a7248515ca45d0ba4bbbb8c33f1bda',
      scanMn: 'https://etherscan.io/tx/',
      scanTN: 'https://rinkeby.etherscan.io/tx',
    ),

    //Bscscan
    NetworkParams(
      httpUrlMN: 'https://bsc-dataseed.binance.org/',
      wsUrlMN: 'wss://bsc-ws-node.nariox.org:443',
      httpUrlTN: 'https://data-seed-prebsc-2-s1.binance.org:8545/',
      wsUrlTN: 'wss://bsc-ws-node.nariox.org:443',
      scanMn: 'https://bscscan.com/tx/',
      scanTN: 'https://testnet.bscscan.com/tx/',
    ),

    // Hardhat
    NetworkParams(
      httpUrlMN: 'https://bsc-dataseed.binance.org/',
      wsUrlMN: 'wss://bsc-ws-node.nariox.org:443',
      httpUrlTN: 'https://hardhat.bitriel.com',
      wsUrlTN: 'wss://bsc-ws-node.nariox.org:443',
      scanMn: 'https://bscscan.com/tx/',
      scanTN: 'https://testnet.bscscan.com/tx/',
    ),
  ];

  static const oSEL = '0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030';

  static String abiPath = "assets/abi/";
  static String iconsPath = '';
  static String illustrationsPath = "assets/illustration/";
  static String assetsPath = "assets/";
  static String animationPath = "assets/animation/";

  static initIconPath(BuildContext context){
    iconsPath = "${Provider.of<AppProvider>(context, listen: false).dirPath}/icons/";
  }

<<<<<<< HEAD
=======
}

>>>>>>> daveat
class PresaleConfig {

  String mainNet = '0xEbc71fA80a0B6D41c944Ed96289e530D0A92a31F';
  String testNet = '0xeBf7E248689534C2757a20DCfe7ffe0bb04b9e93';
  
  // Presale Support Token
  // MainNet
  Map<String, dynamic> baseMain = {
    "tokenAddress": "0x30bab6b88db781129c6a4e9b7926738e3314cf1c", // SEL
    "priceFeed": "0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE", // BNB/USD
    "minInvestment": 1000,
    "logo": "assets/token_logo/bnb.png",
    "symbol": "BNB"
  };
  List<Map<String, dynamic>> main56Support = [
    {
      "tokenAddress": "0xe9e7cea3dedca5984780bafc599bd69add087d56", // BUSD
      "priceFeed": "0xcBb98864Ef56E9042e7d2efef76141f15731B82f", // BUSD/USD
      "logo": "assets/token_logo/busd.png",
      "symbol": "BUSD"
    },
    {
      "tokenAddress": "0x1af3f329e8be154074d8769d1ffa4ee058b1dbc3", // DAI
      "priceFeed": "0x132d3C0B1D2cEa0BC552588063bdBb210FDeecfA", // DAI/USD
      "logo": "assets/token_logo/dai.png",
      "symbol": "DAI"
    },
    {
      "tokenAddress": "0x55d398326f99059fF775485246999027B3197955", // USDT
      "priceFeed": "0xB97Ad0E74fa7d920791E90258A6E2085088b4320", // USDT/USD
      "logo": "assets/token_logo/usdt.png",
      "symbol": "USDT"
    },
    {
      "tokenAddress": "0x2170ed0880ac9a755fd29b2688956bd959f933f8", // ETH
      "priceFeed": "0x9ef1B8c0E4F7dc8bF5719Ea496883DC6401d5b2e", // ETH/USD
      "logo": "assets/token_logo/eth.png",
      "symbol": "ETH"
    }
  ];
  // Testnet
  Map<String, dynamic> baseTest = {
    "tokenAddress": "0xDED2DEDf0cF48033cb50a4EF3e7587bAbc227151", // KUM
    "priceFeed": "0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526", // BNB/USD
    "minInvestment": 1,
    "logo": "assets/token_logo/bnb.png",
    "symbol": "BNB"
  };
  List<Map<String, dynamic>> test97Support = [
    {
      "tokenAddress": "0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee", // BUSD
      "priceFeed": "0x9331b55D9830EF609A2aBCfAc0FBCE050A52fdEa", // BUSD/USD
      "logo": "assets/token_logo/busd.png",
      "symbol": "BUSD"
    },
    {
      "tokenAddress": "0xEC5dCb5Dbf4B114C9d0F65BcCAb49EC54F6A0867", // DAI
      "priceFeed": "0xE4eE17114774713d2De0eC0f035d4F7665fc025D", // DAI/USD
      "logo": "assets/token_logo/dai.png",
      "symbol": "DAI"
    },
    {
      "tokenAddress": "0x337610d27c682E347C9cD60BD4b3b107C9d34dDd", // USDT
      "priceFeed": "0xEca2605f0BCF2BA5966372C99837b1F182d3D620", // USDT/USD
      "logo": "assets/token_logo/usdt.png",
      "symbol": "USDT"
    },
    {
      "tokenAddress": "0xd66c6b4f0be8ce5b39d52e0fd1344c389929b378", // ETH
      "priceFeed": "0x143db3CEEfbdfe5631aDD3E50f7614B6ba708BA7", // ETH/USD
      "logo": "assets/token_logo/eth.png",
      "symbol": "ETH"
    }
  ];
}
