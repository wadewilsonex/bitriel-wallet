import 'package:http/http.dart' as http;
import 'package:wallet_apps/src/models/list_market_coin_m.dart';
import 'package:wallet_apps/src/models/trendingcoin_m.dart';

import '../../index.dart';

List list = [
   {
    "id": "bitcoin",
    "symbol": "btc",
    "name": "Bitcoin",
    "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
    "current_price": 20815,
    "market_cap": 401798548514,
    "market_cap_rank": 1,
    "fully_diluted_valuation": 437950166927,
    "total_volume": 40535594883,
    "high_24h": 21576,
    "low_24h": 20533,
    "price_change_24h": -477.82082104306755,
    "price_change_percentage_24h": -2.24408,
    "market_cap_change_24h": -8404545306.055603,
    "market_cap_change_percentage_24h": -2.04887,
    "circulating_supply": 19266506,
    "total_supply": 21000000,
    "max_supply": 21000000,
    "ath": 69045,
    "ath_change_percentage": -69.81765,
    "ath_date": "2021-11-10T14:24:11.849Z",
    "atl": 67.81,
    "atl_change_percentage": 30632.39652,
    "atl_date": "2013-07-06T00:00:00.000Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:28.374Z"
  },
  {
    "id": "ethereum",
    "symbol": "eth",
    "name": "Ethereum",
    "image": "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880",
    "current_price": 1528.7,
    "market_cap": 184599309823,
    "market_cap_rank": 2,
    "fully_diluted_valuation": 184599309823,
    "total_volume": 11606829905,
    "high_24h": 1606.89,
    "low_24h": 1511.31,
    "price_change_24h": -54.19984350845493,
    "price_change_percentage_24h": -3.42408,
    "market_cap_change_24h": -6233604874.578461,
    "market_cap_change_percentage_24h": -3.26653,
    "circulating_supply": 120518597.222597,
    "total_supply": 120518597.222597,
    "max_supply": null,
    "ath": 4878.26,
    "ath_change_percentage": -68.61551,
    "ath_date": "2021-11-10T14:24:19.604Z",
    "atl": 0.432979,
    "atl_change_percentage": 353500.86937,
    "atl_date": "2015-10-20T00:00:00.000Z",
    "roi": {
      "times": 97.19358547487893,
      "currency": "btc",
      "percentage": 9719.358547487893
    },
    "last_updated": "2023-01-19T07:39:13.532Z"
  },
  {
    "id": "tether",
    "symbol": "usdt",
    "name": "Tether",
    "image": "https://assets.coingecko.com/coins/images/325/large/Tether.png?1668148663",
    "current_price": 0.999593,
    "market_cap": 66554049669,
    "market_cap_rank": 3,
    "fully_diluted_valuation": 66554049669,
    "total_volume": 50681682429,
    "high_24h": 1.006,
    "low_24h": 0.994248,
    "price_change_24h": -0.000773743845074781,
    "price_change_percentage_24h": -0.07735,
    "market_cap_change_24h": 43571878,
    "market_cap_change_percentage_24h": 0.06551,
    "circulating_supply": 66484835812.223,
    "total_supply": 66484835812.223,
    "max_supply": null,
    "ath": 1.32,
    "ath_change_percentage": -24.39248,
    "ath_date": "2018-07-24T00:00:00.000Z",
    "atl": 0.572521,
    "atl_change_percentage": 74.72887,
    "atl_date": "2015-03-02T00:00:00.000Z",
    "roi": null,
    "last_updated": "2023-01-19T07:35:25.034Z"
  },
  {
    "id": "usd-coin",
    "symbol": "usdc",
    "name": "USD Coin",
    "image": "https://assets.coingecko.com/coins/images/6319/large/USD_Coin_icon.png?1547042389",
    "current_price": 0.999783,
    "market_cap": 43163038521,
    "market_cap_rank": 4,
    "fully_diluted_valuation": 43177371830,
    "total_volume": 4277885820,
    "high_24h": 1.01,
    "low_24h": 0.989452,
    "price_change_24h": -0.000823197189121605,
    "price_change_percentage_24h": -0.08227,
    "market_cap_change_24h": -328520284.1933899,
    "market_cap_change_percentage_24h": -0.75537,
    "circulating_supply": 43103372933.6928,
    "total_supply": 43117686429.5128,
    "max_supply": null,
    "ath": 1.17,
    "ath_change_percentage": -14.64475,
    "ath_date": "2019-05-08T00:40:28.300Z",
    "atl": 0.891848,
    "atl_change_percentage": 12.23508,
    "atl_date": "2021-05-19T13:14:05.611Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:09.051Z"
  },
  {
    "id": "binancecoin",
    "symbol": "bnb",
    "name": "BNB",
    "image": "https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png?1644979850",
    "current_price": 290.38,
    "market_cap": 39246130251,
    "market_cap_rank": 5,
    "fully_diluted_valuation": 58180997135,
    "total_volume": 1037478752,
    "high_24h": 304.34,
    "low_24h": 282.46,
    "price_change_24h": -11.2270345468674,
    "price_change_percentage_24h": -3.72237,
    "market_cap_change_24h": -9989641959.174011,
    "market_cap_change_percentage_24h": -20.2894,
    "circulating_supply": 134910476.56,
    "total_supply": 157219628.63,
    "max_supply": 200000000,
    "ath": 686.31,
    "ath_change_percentage": -57.62246,
    "ath_date": "2021-05-10T07:24:17.097Z",
    "atl": 0.0398177,
    "atl_change_percentage": 730328.54237,
    "atl_date": "2017-10-19T00:00:00.000Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:18.181Z"
  },
  {
    "id": "ripple",
    "symbol": "xrp",
    "name": "XRP",
    "image": "https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png?1605778731",
    "current_price": 0.383932,
    "market_cap": 19525923892,
    "market_cap_rank": 6,
    "fully_diluted_valuation": 38502552241,
    "total_volume": 1611167769,
    "high_24h": 0.395988,
    "low_24h": 0.371425,
    "price_change_24h": -0.004185008555808723,
    "price_change_percentage_24h": -1.07829,
    "market_cap_change_24h": -160175955.7049446,
    "market_cap_change_percentage_24h": -0.81365,
    "circulating_supply": 50713323547,
    "total_supply": 99989156648,
    "max_supply": 100000000000,
    "ath": 3.4,
    "ath_change_percentage": -88.67278,
    "ath_date": "2018-01-07T00:00:00.000Z",
    "atl": 0.00268621,
    "atl_change_percentage": 14230.61952,
    "atl_date": "2014-05-22T00:00:00.000Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:52.609Z"
  },
  {
    "id": "binance-usd",
    "symbol": "busd",
    "name": "Binance USD",
    "image": "https://assets.coingecko.com/coins/images/9576/large/BUSD.png?1568947766",
    "current_price": 1,
    "market_cap": 16323316668,
    "market_cap_rank": 7,
    "fully_diluted_valuation": 16323316668,
    "total_volume": 10772275421,
    "high_24h": 1.01,
    "low_24h": 0.98885,
    "price_change_24h": -0.000581670517375565,
    "price_change_percentage_24h": -0.05813,
    "market_cap_change_24h": 301193030,
    "market_cap_change_percentage_24h": 1.87986,
    "circulating_supply": 16310901692.24,
    "total_supply": 16310901692.24,
    "max_supply": null,
    "ath": 1.15,
    "ath_change_percentage": -13.32419,
    "ath_date": "2020-03-13T02:35:42.953Z",
    "atl": 0.901127,
    "atl_change_percentage": 11.01825,
    "atl_date": "2021-05-19T13:04:37.445Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:38.658Z"
  },
  {
    "id": "cardano",
    "symbol": "ada",
    "name": "Cardano",
    "image": "https://assets.coingecko.com/coins/images/975/large/cardano.png?1547034860",
    "current_price": 0.331449,
    "market_cap": 11647985020,
    "market_cap_rank": 8,
    "fully_diluted_valuation": 14956741742,
    "total_volume": 441938912,
    "high_24h": 0.354438,
    "low_24h": 0.327506,
    "price_change_24h": -0.019535014624227794,
    "price_change_percentage_24h": -5.56578,
    "market_cap_change_24h": -670653452.226738,
    "market_cap_change_percentage_24h": -5.44422,
    "circulating_supply": 35045020830.3234,
    "total_supply": 45000000000,
    "max_supply": 45000000000,
    "ath": 3.09,
    "ath_change_percentage": -89.23409,
    "ath_date": "2021-09-02T06:00:10.474Z",
    "atl": 0.01925275,
    "atl_change_percentage": 1626.16424,
    "atl_date": "2020-03-13T02:22:55.044Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:40.667Z"
  },
  {
    "id": "dogecoin",
    "symbol": "doge",
    "name": "Dogecoin",
    "image": "https://assets.coingecko.com/coins/images/5/large/dogecoin.png?1547792256",
    "current_price": 0.080956,
    "market_cap": 11189554834,
    "market_cap_rank": 9,
    "fully_diluted_valuation": null,
    "total_volume": 1051813100,
    "high_24h": 0.088934,
    "low_24h": 0.080323,
    "price_change_24h": -0.006150460653872759,
    "price_change_percentage_24h": -7.06083,
    "market_cap_change_24h": -816931597.3479099,
    "market_cap_change_percentage_24h": -6.80409,
    "circulating_supply": 137783306383.705,
    "total_supply": null,
    "max_supply": null,
    "ath": 0.731578,
    "ath_change_percentage": -88.89661,
    "ath_date": "2021-05-08T05:08:23.458Z",
    "atl": 0.0000869,
    "atl_change_percentage": 93371.15262,
    "atl_date": "2015-05-06T00:00:00.000Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:28.509Z"
  },
  {
    "id": "matic-network",
    "symbol": "matic",
    "name": "Polygon",
    "image": "https://assets.coingecko.com/coins/images/4713/large/matic-token-icon.png?1624446912",
    "current_price": 0.945101,
    "market_cap": 8500508352,
    "market_cap_rank": 10,
    "fully_diluted_valuation": 9481387183,
    "total_volume": 585770678,
    "high_24h": 1.019,
    "low_24h": 0.938723,
    "price_change_24h": -0.061556662397585615,
    "price_change_percentage_24h": -6.11495,
    "market_cap_change_24h": -528934139.560833,
    "market_cap_change_percentage_24h": -5.85788,
    "circulating_supply": 8965469069.28493,
    "total_supply": 10000000000,
    "max_supply": 10000000000,
    "ath": 2.92,
    "ath_change_percentage": -67.49067,
    "ath_date": "2021-12-27T02:08:34.307Z",
    "atl": 0.00314376,
    "atl_change_percentage": 30056.8068,
    "atl_date": "2019-05-10T00:00:00.000Z",
    "roi": {
      "times": 358.3540980441633,
      "currency": "usd",
      "percentage": 35835.40980441633
    },
    "last_updated": "2023-01-19T07:39:58.299Z"
  },
  {
    "id": "solana",
    "symbol": "sol",
    "name": "Solana",
    "image": "https://assets.coingecko.com/coins/images/4128/large/solana.png?1640133422",
    "current_price": 21.36,
    "market_cap": 7954797170,
    "market_cap_rank": 11,
    "fully_diluted_valuation": 11555958831,
    "total_volume": 1545270054,
    "high_24h": 23.44,
    "low_24h": 20.67,
    "price_change_24h": -1.6242623304166308,
    "price_change_percentage_24h": -7.06713,
    "market_cap_change_24h": -562901219.1247663,
    "market_cap_change_percentage_24h": -6.60861,
    "circulating_supply": 370992547.071528,
    "total_supply": 538942038.209702,
    "max_supply": null,
    "ath": 259.96,
    "ath_change_percentage": -91.74754,
    "ath_date": "2021-11-06T21:54:35.825Z",
    "atl": 0.500801,
    "atl_change_percentage": 4183.74276,
    "atl_date": "2020-05-11T19:35:23.449Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:19.252Z"
  },
  {
    "id": "okb",
    "symbol": "okb",
    "name": "OKB",
    "image": "https://assets.coingecko.com/coins/images/4463/large/WeChat_Image_20220118095654.png?1642471050",
    "current_price": 30.76,
    "market_cap": 7596290035,
    "market_cap_rank": 12,
    "fully_diluted_valuation": 9239768450,
    "total_volume": 23703070,
    "high_24h": 32.81,
    "low_24h": 30.49,
    "price_change_24h": -2.0047649985751406,
    "price_change_percentage_24h": -6.11785,
    "market_cap_change_24h": -516048007.3998432,
    "market_cap_change_percentage_24h": -6.36127,
    "circulating_supply": 246638974,
    "total_supply": 300000000,
    "max_supply": null,
    "ath": 44.01,
    "ath_change_percentage": -30.07017,
    "ath_date": "2021-05-03T01:03:16.108Z",
    "atl": 0.580608,
    "atl_change_percentage": 5200.10483,
    "atl_date": "2019-01-14T00:00:00.000Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:43.375Z"
  },
  {
    "id": "staked-ether",
    "symbol": "steth",
    "name": "Lido Staked Ether",
    "image": "https://assets.coingecko.com/coins/images/13442/large/steth_logo.png?1608607546",
    "current_price": 1524.72,
    "market_cap": 7497489581,
    "market_cap_rank": 13,
    "fully_diluted_valuation": 7497489581,
    "total_volume": 143098010,
    "high_24h": 1593.67,
    "low_24h": 1505.08,
    "price_change_24h": -49.63085676316496,
    "price_change_percentage_24h": -3.15246,
    "market_cap_change_24h": -192806458.23240852,
    "market_cap_change_percentage_24h": -2.50714,
    "circulating_supply": 4907085.72023576,
    "total_supply": 4907085.72023576,
    "max_supply": 4907085.72023576,
    "ath": 4829.57,
    "ath_change_percentage": -68.36926,
    "ath_date": "2021-11-10T14:40:47.256Z",
    "atl": 482.9,
    "atl_change_percentage": 216.34722,
    "atl_date": "2020-12-22T04:08:21.854Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:43.376Z"
  },
  {
    "id": "polkadot",
    "symbol": "dot",
    "name": "Polkadot",
    "image": "https://assets.coingecko.com/coins/images/12171/large/polkadot.png?1639712644",
    "current_price": 5.75,
    "market_cap": 6869258890,
    "market_cap_rank": 14,
    "fully_diluted_valuation": 7335851757,
    "total_volume": 416330730,
    "high_24h": 6.19,
    "low_24h": 5.64,
    "price_change_24h": -0.26835143975821296,
    "price_change_percentage_24h": -4.46184,
    "market_cap_change_24h": -293392516.285491,
    "market_cap_change_percentage_24h": -4.09614,
    "circulating_supply": 1191746789.11186,
    "total_supply": 1272695922.0603,
    "max_supply": null,
    "ath": 54.98,
    "ath_change_percentage": -89.52492,
    "ath_date": "2021-11-04T14:10:09.301Z",
    "atl": 2.7,
    "atl_change_percentage": 113.50836,
    "atl_date": "2020-08-20T05:48:11.359Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:42.285Z"
  },
  {
    "id": "shiba-inu",
    "symbol": "shib",
    "name": "Shiba Inu",
    "image": "https://assets.coingecko.com/coins/images/11939/large/shiba.png?1622619446",
    "current_price": 0.00001109,
    "market_cap": 6560577424,
    "market_cap_rank": 15,
    "fully_diluted_valuation": null,
    "total_volume": 967300781,
    "high_24h": 0.00001251,
    "low_24h": 0.00001099,
    "price_change_24h": -0.000001362314125893,
    "price_change_percentage_24h": -10.93654,
    "market_cap_change_24h": -818187131.4629049,
    "market_cap_change_percentage_24h": -11.0884,
    "circulating_supply": 589368103506945.1,
    "total_supply": 999990968807043,
    "max_supply": null,
    "ath": 0.00008616,
    "ath_change_percentage": -87.06439,
    "ath_date": "2021-10-28T03:54:55.568Z",
    "atl": 5.6366e-11,
    "atl_change_percentage": 19772608.17684,
    "atl_date": "2020-11-28T11:26:25.838Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:36.986Z"
  },
  {
    "id": "litecoin",
    "symbol": "ltc",
    "name": "Litecoin",
    "image": "https://assets.coingecko.com/coins/images/2/large/litecoin.png?1547033580",
    "current_price": 83.33,
    "market_cap": 6025795075,
    "market_cap_rank": 16,
    "fully_diluted_valuation": 7021537172,
    "total_volume": 777686734,
    "high_24h": 87.56,
    "low_24h": 82.21,
    "price_change_24h": -4.071530165387884,
    "price_change_percentage_24h": -4.65823,
    "market_cap_change_24h": -280838551.4090929,
    "market_cap_change_percentage_24h": -4.45307,
    "circulating_supply": 72087745.7334713,
    "total_supply": 84000000,
    "max_supply": 84000000,
    "ath": 410.26,
    "ath_change_percentage": -79.6306,
    "ath_date": "2021-05-10T03:13:07.904Z",
    "atl": 1.15,
    "atl_change_percentage": 7174.0589,
    "atl_date": "2015-01-14T00:00:00.000Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:18.884Z"
  },
  {
    "id": "tron",
    "symbol": "trx",
    "name": "TRON",
    "image": "https://assets.coingecko.com/coins/images/1094/large/tron-logo.png?1547035066",
    "current_price": 0.059716,
    "market_cap": 5491529439,
    "market_cap_rank": 17,
    "fully_diluted_valuation": 5491552877,
    "total_volume": 317415128,
    "high_24h": 0.062492,
    "low_24h": 0.059086,
    "price_change_24h": -0.002393358377061499,
    "price_change_percentage_24h": -3.85345,
    "market_cap_change_24h": -215918319.8935833,
    "market_cap_change_percentage_24h": -3.7831,
    "circulating_supply": 91861445253.3636,
    "total_supply": 91861837323.1418,
    "max_supply": null,
    "ath": 0.231673,
    "ath_change_percentage": -74.22185,
    "ath_date": "2018-01-05T00:00:00.000Z",
    "atl": 0.00180434,
    "atl_change_percentage": 3209.84741,
    "atl_date": "2017-11-12T00:00:00.000Z",
    "roi": {
      "times": 30.429561557548567,
      "currency": "usd",
      "percentage": 3042.956155754857
    },
    "last_updated": "2023-01-19T07:39:50.072Z"
  },
  {
    "id": "dai",
    "symbol": "dai",
    "name": "Dai",
    "image": "https://assets.coingecko.com/coins/images/9956/large/4943.png?1636636734",
    "current_price": 0.999436,
    "market_cap": 5119586752,
    "market_cap_rank": 18,
    "fully_diluted_valuation": 5119586752,
    "total_volume": 287672483,
    "high_24h": 1.033,
    "low_24h": 0.993826,
    "price_change_24h": -0.000822536923305361,
    "price_change_percentage_24h": -0.08223,
    "market_cap_change_24h": 25252219,
    "market_cap_change_percentage_24h": 0.49569,
    "circulating_supply": 5113441954.49615,
    "total_supply": 5113441954.49615,
    "max_supply": 5113441954.49615,
    "ath": 1.22,
    "ath_change_percentage": -17.8993,
    "ath_date": "2020-03-13T03:02:50.373Z",
    "atl": 0.903243,
    "atl_change_percentage": 10.79525,
    "atl_date": "2019-11-25T00:04:18.137Z",
    "roi": null,
    "last_updated": "2023-01-19T07:35:44.267Z"
  },
  {
    "id": "avalanche-2",
    "symbol": "avax",
    "name": "Avalanche",
    "image": "https://assets.coingecko.com/coins/images/12559/large/Avalanche_Circle_RedWhite_Trans.png?1670992574",
    "current_price": 15.95,
    "market_cap": 4986112316,
    "market_cap_rank": 19,
    "fully_diluted_valuation": 11521844082,
    "total_volume": 441649680,
    "high_24h": 17.29,
    "low_24h": 15.74,
    "price_change_24h": -1.214211481408615,
    "price_change_percentage_24h": -7.07465,
    "market_cap_change_24h": -366650757.31761456,
    "market_cap_change_percentage_24h": -6.84975,
    "circulating_supply": 311582142.741224,
    "total_supply": 416988132.741224,
    "max_supply": 720000000,
    "ath": 144.96,
    "ath_change_percentage": -88.95269,
    "ath_date": "2021-11-21T14:18:56.538Z",
    "atl": 2.8,
    "atl_change_percentage": 471.72238,
    "atl_date": "2020-12-31T13:15:21.540Z",
    "roi": null,
    "last_updated": "2023-01-19T07:39:37.550Z"
  },
];

Map<String, dynamic> dt = {
  "coins": [
    {
      "item": {
        "id": "illuvium",
        "coin_id": 14468,
        "name": "Illuvium",
        "symbol": "ILV",
        "market_cap_rank": 242,
        "thumb": "https://assets.coingecko.com/coins/images/14468/thumb/ILV.JPG?1617182121",
        "small": "https://assets.coingecko.com/coins/images/14468/small/ILV.JPG?1617182121",
        "large": "https://assets.coingecko.com/coins/images/14468/large/ILV.JPG?1617182121",
        "slug": "illuvium",
        "price_btc": 0.0027148893361954606,
        "score": 0
      }
    },
    {
      "item": {
        "id": "flare-networks",
        "coin_id": 28624,
        "name": "Flare Network",
        "symbol": "FLR",
        "market_cap_rank": 74,
        "thumb": "https://assets.coingecko.com/coins/images/28624/thumb/FLR-icon200x200.png?1673325704",
        "small": "https://assets.coingecko.com/coins/images/28624/small/FLR-icon200x200.png?1673325704",
        "large": "https://assets.coingecko.com/coins/images/28624/large/FLR-icon200x200.png?1673325704",
        "slug": "flare-network",
        "price_btc": 0.00000229749832005786,
        "score": 1
      }
    },
    {
      "item": {
        "id": "gala",
        "coin_id": 12493,
        "name": "GALA",
        "symbol": "GALA",
        "market_cap_rank": 103,
        "thumb": "https://assets.coingecko.com/coins/images/12493/thumb/GALA-COINGECKO.png?1600233435",
        "small": "https://assets.coingecko.com/coins/images/12493/small/GALA-COINGECKO.png?1600233435",
        "large": "https://assets.coingecko.com/coins/images/12493/large/GALA-COINGECKO.png?1600233435",
        "slug": "gala",
        "price_btc": 0.0000022551613983423012,
        "score": 2
      }
    },
    {
      "item": {
        "id": "bonk",
        "coin_id": 28600,
        "name": "Bonk",
        "symbol": "BONK",
        "market_cap_rank": 313,
        "thumb": "https://assets.coingecko.com/coins/images/28600/thumb/bonk.jpg?1672304290",
        "small": "https://assets.coingecko.com/coins/images/28600/small/bonk.jpg?1672304290",
        "large": "https://assets.coingecko.com/coins/images/28600/large/bonk.jpg?1672304290",
        "slug": "bonk",
        "price_btc": 9.042025066917677e-11,
        "score": 3
      }
    },
    {
      "item": {
        "id": "maple",
        "coin_id": 14097,
        "name": "Maple",
        "symbol": "MPL",
        "market_cap_rank": 423,
        "thumb": "https://assets.coingecko.com/coins/images/14097/thumb/Maple_Logo_Mark_Maple_Orange.png?1653381382",
        "small": "https://assets.coingecko.com/coins/images/14097/small/Maple_Logo_Mark_Maple_Orange.png?1653381382",
        "large": "https://assets.coingecko.com/coins/images/14097/large/Maple_Logo_Mark_Maple_Orange.png?1653381382",
        "slug": "maple",
        "price_btc": 0.0002972212078441408,
        "score": 4
      }
    },
    {
      "item": {
        "id": "fetch-ai",
        "coin_id": 5681,
        "name": "Fetch.ai",
        "symbol": "FET",
        "market_cap_rank": 142,
        "thumb": "https://assets.coingecko.com/coins/images/5681/thumb/Fetch.jpg?1572098136",
        "small": "https://assets.coingecko.com/coins/images/5681/small/Fetch.jpg?1572098136",
        "large": "https://assets.coingecko.com/coins/images/5681/large/Fetch.jpg?1572098136",
        "slug": "fetch-ai",
        "price_btc": 0.000011483946435339818,
        "score": 5
      }
    },
    {
      "item": {
        "id": "aptos",
        "coin_id": 26455,
        "name": "Aptos",
        "symbol": "APT",
        "market_cap_rank": 56,
        "thumb": "https://assets.coingecko.com/coins/images/26455/thumb/aptos_round.png?1666839629",
        "small": "https://assets.coingecko.com/coins/images/26455/small/aptos_round.png?1666839629",
        "large": "https://assets.coingecko.com/coins/images/26455/large/aptos_round.png?1666839629",
        "slug": "aptos",
        "price_btc": 0.00030442629589307735,
        "score": 6
      }
    }
  ],
  "exchanges": []
};

class MarketProvider with ChangeNotifier {
  
  http.Response? _res;
  
  List<CoinsModel> cnts = List<CoinsModel>.empty(growable: true);

  List<ListMetketCoinModel> lsMarketCoin = List<ListMetketCoinModel>.empty(growable: true);

  List<ListMetketCoinModel> lsMarketLimit = List<ListMetketCoinModel>.empty(growable: true);

  List<Map<String, dynamic>>? lsCoin = [];

  Map<String, dynamic>? coinMarketDescription;

  Map<String, dynamic>? queried;

  List<String> id = [
    'kiwigo',
    'ethereum',
    'binancecoin',
    'polkadot',
    'bitcoin',
    'selendra'
  ];

  List<Map<String, dynamic>> sortDataMarket = [];

  Market? parseMarketData(List<Map<String, dynamic>> responseBody) {
    Market? data;

    for (var i in responseBody) {
      data = Market.fromJson(i);
    }
    return data;
  }

  set setLsCoin(List<dynamic> ls){
    lsCoin = [];
    lsCoin = List<Map<String, dynamic>>.from(ls);
  }

  Future<List<List<double>>?> fetchLineChartData(String id) async {
    List<List<double>>? prices;
    final res = await http.get(Uri.parse( 'https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=usd&days=1'));

    if (res.statusCode == 200) {
      final data = await jsonDecode(res.body);

      CryptoData mData = CryptoData.fromJson(data);

      prices = mData.prices;

    }

    return prices;
  }

  Future<void> fetchTokenMarketPrice(BuildContext context) async {

    final contract = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);
    sortDataMarket.clear();

    for (int i = 0; i < id.length; i++) {
      try {

        final response = await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}${id[i]}'));

        final jsonResponse = List<Map<String, dynamic>>.from(await json.decode(response.body));

        if (response.statusCode == 200 && jsonResponse.isNotEmpty) {

          sortDataMarket.addAll({jsonResponse[0]});

          final lineChartData = await fetchLineChartData(id[i]);

          final res = parseMarketData(jsonResponse);

          if (i == 0) {
            contract.setkiwigoMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 1) {
            contract.setEtherMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 2) {
            contract.setBnbMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h'].toStringAsFixed(2).toString(),
            );
          } else if (i == 3) {
            await api.setDotMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
              context: context
            );
          } else if (i == 4) {
            await api.setBtcMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h'].toStringAsFixed(2).toString(),
              context: context
            );
          }
        }

        notifyListeners();
      } catch (e) {
        if (ApiProvider().isDebug == true) {
          if (kDebugMode) {
            print("Error fetchTokenMarketPrice $e");
          }
        }
        return;
      }
    }

    // Sort Market Price
    // Map<String, dynamic> tmp = {};
    // for (int i = 0; i < sortDataMarket.length; i++) {
    //   for (int j = i + 1; j < sortDataMarket.length; j++) {
    //     tmp = sortDataMarket[i];
    //     if (sortDataMarket[j]['market_cap_rank'] < tmp['market_cap_rank']) {
    //       sortDataMarket[i] = sortDataMarket[j];
    //       sortDataMarket[j] = tmp;
    //     }
    //   }
    // }

    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> searchCoinFromMarket(String id) async {
    try {

      _res = await http.get(Uri.parse('https://api.coingecko.com/api/v3/search?query=${id.toLowerCase()}'));
      lsCoin = List<Map<String, dynamic>>.from( (await json.decode(_res!.body))['coins'] );
      lsCoin = lsCoin!.where((element){
        if (element['symbol'].toLowerCase() == id.toLowerCase() && element['market_cap_rank'] != null){
          return true;
        }
        return false;
      }).toList();
      return lsCoin!;
    } catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error searchCoinFromMarket $e");
        }
      }
    }
    return lsCoin!;
  }

  Future<void> queryCoinFromMarket(String id) async {
    try {

      queried = await json.decode((await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}$id'))).body)[0];
      
    } catch (e){
      
      if (kDebugMode) {
        print("error queryCoinFromMarket $e");
      }
      return;
    }
  }
  
  Future<void> fetchTrendingCoin() async {
    try {
      
      // final res = await http.get(Uri.parse('https://api.coingecko.com/api/v3/search/trending'));

      final res = http.Response(json.encode(dt), 200);
      
      cnts = List<CoinsModel>.empty(growable: true);

      if (res.statusCode == 200) {
        final data = await jsonDecode(res.body);

        for(int i = 0; i < data['coins'].length; i++){
          
          cnts.add(CoinsModel.fromJson(data['coins'][i]));

          final getPriceData = await fetchPriceData(cnts[i].item.id!);

          cnts[i].item.priceBtc = getPriceData;

        }
      
        notifyListeners();
      }
      
    } catch (e){
      
      if (kDebugMode) {
        print("error fetch trending coin $e");
      }
    }
  }


  Future<double> fetchPriceData(String id) async {

    final res = await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}$id'));

    final List<Map<String, dynamic>> jsonResponse;

    const double currentPrice = 0;

    if (res.statusCode == 200) {

      jsonResponse = List<Map<String, dynamic>>.from(await json.decode(res.body));
      
      final currentPrice = jsonResponse[0]['current_price'];

      return currentPrice;
    }
    return currentPrice;
  }

  Future<List<ListMetketCoinModel>> listMarketCoin() async{

    try {
      
      // final res = Response(json.encode(list), 200);

      final res = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

      lsMarketLimit = List<ListMetketCoinModel>.empty(growable: true);

      if (res.statusCode == 200) {
        final data = await jsonDecode(res.body);

        for(int i = 0; i < data.length; i++){
          
          lsMarketLimit.add(ListMetketCoinModel().fromJson(data[i]));

        }
      
        notifyListeners();

        return lsMarketLimit;
      }
      
    } catch (e){
      
      if (kDebugMode) {
        print("error fetch listMarketCoin $e");
      }
    }

    return [];

  }

}
