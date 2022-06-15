/* This file hold app configurations. */
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/network_params.dart';

/// Size = 20
const double paddingSize = 20;

class AppConfig {
  // QR Embedded
  static String logoQrEmbedded = "assets/SelendraQr-1.png";
  /* Transaction Acivtiy */
  static String logoTrxActivity = 'assets/images/sld_logo.png';

  /*Google spreedsheet id for claim airdrop */
  static const spreedSheetId = '1hFKqaUe1q_6A-b-_ZnEAC574d51fCi1bTWQKCluHF2E';

  /*Coingecko api url fetch asset price */
  static const coingeckoBaseUrl = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=';

  static const erc20Abi = 'assets/abi/erc20.json';

  static const bep20Abi = 'assets/abi/bep20.json';

  static const swapAbi = 'assets/abi/swap.json';

  static const atdAbi = 'assets/abi/atd.json';

  /*google spreedsheet credential for claim airdrop */
  static const credentials = r'''
    {
      "type": "service_account",
      "project_id": "selendra-airdrop",
      "private_key_id": "2c37dc39ad9651e9a71fdeeec0c9bd8af1b7f041",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCvkl8k5zDEw722\nf15EiKFnX4MwuytiFkhUfM2+BUpzMecHd5YaiuLRPdhy07HaZlJdjPp0cpC+TFGA\nWxtgkp9m1ehOUM6WD1quPSE4w3ERQgR/Ja9UmDoq/KVBklSct7iMcQ2DGQTSmMzl\nVsg356ZV49+AK8BEJxfx2wvwH+af+0wiuGwQ4fpXvCP43NvNGAGBOWvwUI6aiC45\nrPS1te2Mi/dVlHcCiL+E5TqHOZTiRbOk1v1LvM0eEJUEe0gQM1pViAEhnO7MKtDR\nVBrSE74Q1hKoWj6u+JuOnbfidLXlOIU3PAq4+/2HSqR07g03M8WoEKQvGG7p1arG\n2VeG7rWHAgMBAAECggEAQtQKnh/X2tWM1TXW+mwtT402AOsFgODtaCdXIuCdrYpN\nn3R/8Jtz6WRKiq6UkIaJDG3YeVGQUbb4AMzs903oGbsLISA1+j1e7Vp8VkBiPcjs\nsD72ZVNKNMmU14gs57gwqVhw5bk0sjqSJytoq4rjr+a8UGuW0/ozbY5MlXp3DOZ3\nCGbcp9W0dVWwWFIPvMsEprvbfnSaqjyDQ1niqfoSukls7lBFRg6+ORkoskTlwEZe\nCe/DdKHs1Z6t7zByePrd+poTIycLzEv5cOx0mfLR2e0J54LdRbGEzr4e36kE9W+R\n/c3s/hz+ZKgAf6zAyK51Rm/4oV5y4z2qf+BdHRPvWQKBgQDkKUWSf9ZGvzu1TU6L\n6XDQlK+OQfbDFAUrfFlYrHNLVOQxC8oVf7wABlFYatBw3pVcusmXpBQUkvXjh51U\n8g+fIeeVP89VRAV6UPkK+SsOuwHFnij9umsH05ocR8poase06kkrq8uTGeXU4XY8\n1CsQkYXrWuq75SCBzG5X9svpvwKBgQDE/nE+Q5t2z6+jKs4eJifgbwEFHwvGK4yl\npqZ+UAhE+uU6gdTPzBqPQK5vIdFpSz3zryyLZAawSW4ZpaVPW09h9yzzroKJPz6K\nMvp+I1PLmweUIHLfoakuzsPHocnWc1v9+CwPeWAMaDUNpWyx9ae5KHz9gEm2gsKD\nmtH7Nl7WOQKBgQC3e/lXNzc67c82nlTsb28qTmhgHuwzNYZy0i2IAic2Da71QmXh\npDesTWhdkojOPDIhwJUePfVoFkdoE0eTaJbngnyaqhYym+FL3JJrILZfwkRKiEau\nxZwNTz5AP/umvTidZUwyspWkVs9dw3Myt+1qBZ2NCDB9qmXZ/G1AkFisQQKBgQCJ\nfkYv/SQPIxoluoSuilce0JtXpbmkEVVTcSOX2ehLrQo9cczFVGHdRnn5WxM8eKW+\n5a8jgycf98B+6hydbM/VQp3/XvgBL0FJWBd53tJns8bwXk2PRNg+sVX4ijXEFjRI\n6ORn0IF3Z2xQH/vjod/03guPK/FHD7EQBgk1W1eKEQKBgQDEoXf7LPDwDi7qJTBJ\nVoHRujcbNentvE8bdz/vi5kmeTTd/LxzD+MVCOCJ6tmyYVc4eWP0u6AfGppEKCq9\nCXYQ86zNAQPGJWgTtcRX9mFLaPhNRPZVDRkhB/vdqKEn7rEkBhjsoF/OAkqVmMXz\nEH+X9bLAj6lhHx3ngQ2wZwzcfA==\n-----END PRIVATE KEY-----\n",
      "client_email": "selendra-airdrop@selendra-airdrop.iam.gserviceaccount.com",
      "client_id": "101126990315549211828",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/selendra-airdrop%40selendra-airdrop.iam.gserviceaccount.com"
    }
  ''';
  static const speedsheetId = '1PAmEFBWmjFV1EueEFXn7V60svNTLc6vN0QfROeDqQHA';


  static const kmpiAddr = '5GZ9uD6RgN84bpBuic1HWq9AP7k2SSFtK9jCVkrncZsuARQU';

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
    //[0]= selendra, [1]= polkadot, [2] = ethereum, [3] = binance smart chain
    
    NetworkParams(
      httpUrlTN: 'https://rpc.testnet.selendra.org/',
      httpUrlMN: 'https://app.selendra.org/',
      wsUrlTN: 'wss://rpc1-testnet.selendra.org/',
      wsUrlMN: 'wss://api-mainnet.selendra.org',
      ss58: 204,
      ss58MN: 972
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
  ];

  static const oSEL = '0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030';

  //static const testSEL = '0x46bF747DeAC87b5db70096d9e88debd72D4C7f3C';

  ///static const nodeName = 'Indranet hosted By Selendra';

  //static const nodeEndpoint = 'wss://rpc1-testnet.selendra.org';

  //static const dotTestnet = 'wss://westend-rpc.polkadot.io';

  //static const dotMainnet = 'wss://rpc.polkadot.io';

  // static int ss58 = 42;

  // static const nodeListPolkadot = [
  //   {
  //     'name': 'Polkadot (Live, hosted by PatractLabs)',
  //     'ss58': 0,
  //     'endpoint': 'wss://polkadot.elara.patract.io',
  //   },
  //   {
  //     'name': 'Polkadot (Live, hosted by Polkawallet CN)',
  //     'ss58': 0,
  //     'endpoint': 'wss://polkadot-1.polkawallet.io:9944',
  //   },
  //   {
  //     'name': 'Polkadot (Live, hosted by Polkawallet EU)',
  //     'ss58': 0,
  //     'endpoint': 'wss://polkadot-2.polkawallet.io',
  //   },
  //   {
  //     'name': 'Polkadot (Live, hosted by Parity)',
  //     'ss58': 0,
  //     'endpoint': 'wss://rpc.polkadot.io',
  //   },
  //   {
  //     'name': 'Polkadot (Live, hosted by onfinality)',
  //     'ss58': 0,
  //     'endpoint': 'wss://polkadot.api.onfinality.io/public-ws',
  //   },
  // ];

  // static const testInviteLink =
  //     'https://selendra-airdrop.netlify.app/invitation?ref=';

  // static const testInviteLink1 =
  //     'https://selendra-airdrop.netlify.app/claim-\$sel?ref=';

  // static const baseInviteLink = 'https://airdrop.selendra.org/claim-\$sel?ref=';

  //
  // sld_market net API
  // https://sld_marketnet-api.selendra.com/pub/v1
  //
  // sld_market net API
  // https://sld_marketnet-api.selendra.com/pub/v1

  static String abiPath = "assets/abi/";
  static String iconsPath = "assets/icons/";
  static String illustrationsPath = "assets/illustration/";
  static String assetsPath = "assets/";
  static String animationPath = "assets/animation/";

}

class DBkey {
  static String supportedToken = "supportedToken";
  static String listSel = "listSel";
}

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
