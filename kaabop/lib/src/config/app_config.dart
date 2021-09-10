/* This file hold app configurations. */
import 'package:wallet_apps/src/models/network_params.dart';

class AppConfig {
  // QR Embedded
  static String logoQrEmbedded = "assets/SelendraQr-1.png";
  /* Transaction Acivtiy */
  static String logoTrxActivity = 'assets/images/sld_logo.png';

  /*Google spreedsheet id for claim airdrop */
  static const spreedSheetId = '1hFKqaUe1q_6A-b-_ZnEAC574d51fCi1bTWQKCluHF2E';

  /*Coingecko api url fetch asset price */
  static const coingeckoBaseUrl =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=';

  static const selV1MainnetAddr = '0x288d3A87a87C284Ed685E0490E5C4cC0883a060a';

  static const selv2MainnetAddr = '0x30bAb6B88dB781129c6a4e9B7926738e3314Cf1C';

  static const swapMainnetAddr = '0xa857d61c5802C4e299a5B972DE1ACCaD085cE765';

  static const kmpiAddr = '5GZ9uD6RgN84bpBuic1HWq9AP7k2SSFtK9jCVkrncZsuARQU';

  /*All network list that bitriel wallet support*/
  static List<NetworkParams> networkList = [
    //[0]= selendra, [1]= polkadot, [2] = ethereum, [3] = binance smart chain
    NetworkParams(
      httpUrlTN: 'https://rpc.testnet.selendra.org/',
      wsUrlTN: 'wss://rpc1-testnet.selendra.org/',
      ss58: 42,
    ),
    NetworkParams(
      wsUrlMN: 'wss://rpc.polkadot.io',
      ss58: 42,
    ),
    NetworkParams(
      httpUrlMN:
          'https://mainnet.infura.io/v3/93a7248515ca45d0ba4bbbb8c33f1bda',
      wsUrlMN: 'wss://mainnet.infura.io/ws/v3/93a7248515ca45d0ba4bbbb8c33f1bda',
      httpUrlTN:
          'https://rinkeby.infura.io/v3/93a7248515ca45d0ba4bbbb8c33f1bda',
      wsUrlTN: 'wss://rinkeby.infura.io/ws/v3/93a7248515ca45d0ba4bbbb8c33f1bda',
    ),
    NetworkParams(
        httpUrlMN: 'https://bsc-dataseed.binance.org/',
        wsUrlMN: 'wss://bsc-ws-node.nariox.org:443',
        httpUrlTN: 'https://data-seed-prebsc-1-s1.binance.org:8545',
        wsUrlTN: "wss://testnet-dex.binance.org/api/ws")
  ];

  static const String credentials = '';

  //static const selV1MainnetAddr = '0x288d3A87a87C284Ed685E0490E5C4cC0883a060a';

  //static const selv2MainnetAddr = '0x30bAb6B88dB781129c6a4e9B7926738e3314Cf1C';

  //static const kgoAddr = '0x5d3AfBA1924aD748776E4Ca62213BF7acf39d773';

  //test 0x78F51cc2e297dfaC4c0D5fb3552d413DC3F71314

  static const oSEL = '0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030';

  //static const swapTestContract = '0xE5DD12570452057fc85B8cE9820aD676390f865B';

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
}
