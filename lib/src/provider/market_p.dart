import 'package:http/http.dart' as http;
import 'package:wallet_apps/src/models/list_market_coin_m.dart';
import 'package:wallet_apps/src/models/market/coin.dart';
import 'package:wallet_apps/src/models/trendingcoin_m.dart';

import '../../index.dart';

// {
// 	"status": {
// 		"error_code": 429,
// 		"error_message": "You've exceeded the Rate Limit. Please visit https://www.coingecko.com/en/api/pricing to subscribe to our API plans for higher rate limits."
// 	}
// }

List<dynamic> mkData = [
	{
		"id": "bitcoin",
		"symbol": "btc",
		"name": "Bitcoin",
		"image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
		"current_price": 27328,
		"market_cap": 528775574755,
		"market_cap_rank": 1,
		"fully_diluted_valuation": 573776748529,
		"total_volume": 19816792529,
		"high_24h": 28308,
		"low_24h": 27201,
		"price_change_24h": -979.7584991379481,
		"price_change_percentage_24h": -3.46108,
		"market_cap_change_24h": -19502248323.310974,
		"market_cap_change_percentage_24h": -3.557,
		"circulating_supply": 19352975.0,
		"total_supply": 21000000.0,
		"max_supply": 21000000.0,
		"ath": 69045,
		"ath_change_percentage": -60.42732,
		"ath_date": "2021-11-10T14:24:11.849Z",
		"atl": 67.81,
		"atl_change_percentage": 40193.86424,
		"atl_date": "2013-07-06T00:00:00.000Z",
		"roi": null,
		"last_updated": "2023-04-22T04:30:36.051Z",
		"price_change_percentage_1h_in_currency": 0.10760632821780304
	},
	{
		"id": "ethereum",
		"symbol": "eth",
		"name": "Ethereum",
		"image": "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880",
		"current_price": 1860.35,
		"market_cap": 223804282331,
		"market_cap_rank": 2,
		"fully_diluted_valuation": 223804282331,
		"total_volume": 13206206455,
		"high_24h": 1946.67,
		"low_24h": 1840.85,
		"price_change_24h": -86.32284753719068,
		"price_change_percentage_24h": -4.43438,
		"market_cap_change_24h": -10636269825.622406,
		"market_cap_change_percentage_24h": -4.53687,
		"circulating_supply": 120414184.245026,
		"total_supply": 120414184.245026,
		"max_supply": null,
		"ath": 4878.26,
		"ath_change_percentage": -61.90807,
		"ath_date": "2021-11-10T14:24:19.604Z",
		"atl": 0.432979,
		"atl_change_percentage": 429071.87356,
		"atl_date": "2015-10-20T00:00:00.000Z",
		"roi": {
			"times": 90.02683411409068,
			"currency": "btc",
			"percentage": 9002.683411409067
		},
		"last_updated": "2023-04-22T04:30:41.993Z",
		"price_change_percentage_1h_in_currency": 0.09200913110922915
	},
	{
		"id": "binancecoin",
		"symbol": "bnb",
		"name": "BNB",
		"image": "https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png?1644979850",
		"current_price": 322.97,
		"market_cap": 50950834822,
		"market_cap_rank": 4,
		"fully_diluted_valuation": 64541180934,
		"total_volume": 1398405430,
		"high_24h": 330.96,
		"low_24h": 316.35,
		"price_change_24h": 3.15,
		"price_change_percentage_24h": 0.98359,
		"market_cap_change_24h": 466491490,
		"market_cap_change_percentage_24h": 0.92403,
		"circulating_supply": 157886280.0,
		"total_supply": 157900174.0,
		"max_supply": 200000000.0,
		"ath": 686.31,
		"ath_change_percentage": -52.97934,
		"ath_date": "2021-05-10T07:24:17.097Z",
		"atl": 0.0398177,
		"atl_change_percentage": 810358.48318,
		"atl_date": "2017-10-19T00:00:00.000Z",
		"roi": null,
		"last_updated": "2023-04-22T04:30:35.081Z",
		"price_change_percentage_1h_in_currency": 0.24681347960498903
	},
	{
		"id": "polkadot",
		"symbol": "dot",
		"name": "Polkadot",
		"image": "https://assets.coingecko.com/coins/images/12171/large/polkadot.png?1639712644",
		"current_price": 5.88,
		"market_cap": 7183122397,
		"market_cap_rank": 12,
		"fully_diluted_valuation": 7658220040,
		"total_volume": 212960839,
		"high_24h": 6.15,
		"low_24h": 5.8,
		"price_change_24h": -0.2765281442050034,
		"price_change_percentage_24h": -4.49374,
		"market_cap_change_24h": -342460669.5516424,
		"market_cap_change_percentage_24h": -4.55062,
		"circulating_supply": 1223890578.45222,
		"total_supply": 1304839711.41056,
		"max_supply": null,
		"ath": 54.98,
		"ath_change_percentage": -89.32514,
		"ath_date": "2021-11-04T14:10:09.301Z",
		"atl": 2.7,
		"atl_change_percentage": 117.58045,
		"atl_date": "2020-08-20T05:48:11.359Z",
		"roi": null,
		"last_updated": "2023-04-22T04:30:37.233Z",
		"price_change_percentage_1h_in_currency": -0.005460707297605346
	},
	{
		"id": "kiwigo",
		"symbol": "kgo",
		"name": "Kiwigo",
		"image": "https://assets.coingecko.com/coins/images/14443/large/8VKJDPsp_400x400.jpg?1616107715",
		"current_price": 0.01135366,
		"market_cap": 485144,
		"market_cap_rank": 2419,
		"fully_diluted_valuation": null,
		"total_volume": 0.085152,
		"high_24h": null,
		"low_24h": null,
		"price_change_24h": null,
		"price_change_percentage_24h": null,
		"market_cap_change_24h": null,
		"market_cap_change_percentage_24h": null,
		"circulating_supply": 42730195.94992,
		"total_supply": 1000000000.0,
		"max_supply": null,
		"ath": 0.469817,
		"ath_change_percentage": -97.58338,
		"ath_date": "2021-03-18T23:24:53.737Z",
		"atl": 0.00059896,
		"atl_change_percentage": 1795.56755,
		"atl_date": "2023-04-19T14:38:26.719Z",
		"roi": null,
		"last_updated": "2023-04-20T21:02:50.190Z",
		"price_change_percentage_1h_in_currency": null
	}
];

class MarketProvider with ChangeNotifier {
  
  http.Response? _res;
  
  List<CoinsModel> cnts = List<CoinsModel>.empty(growable: true);

  List<ListMetketCoinModel> lsMarketLimit = List<ListMetketCoinModel>.empty(growable: true);

  List<Map<String, dynamic>>? lsCoin = [];

  Map<String, dynamic>? coinMarketDescription;

  Map<String, dynamic>? queried;

  List<String> id = [
    'selendra', //1
    'selendra_v1', //2
    'selendra_v2', //3
    'kiwigo', //3
    'ethereum', //4
    'binancecoin', //5
    'polkadot', //6
    'bitcoin', //7
    'reakreay', //8
    'att', //9
  ];

  List<Coin> sortDataMarket = [];

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
    final res = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=usd&days=1'));

    if (res.statusCode == 200) {
      final data = await jsonDecode(res.body);

      CryptoData mData = CryptoData.fromJson(data);

      prices = mData.prices;

    }

    return prices;
  }

  Future<void> fetchTokenMarketPrice(BuildContext context) async {
    
    debugPrint("fetchTokenMarketPrice");

    final contract = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);
    
    sortDataMarket.clear();

    // final response = await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}${id.join(',')}'));
    final response = http.Response(json.encode(mkData), 200);

    List<dynamic> jsonResponse = await json.decode(response.body);

    print("jsonResponse ${jsonResponse}");

    // for (int i = 0; i < id.length; i++) {
    try {

      if (response.statusCode == 200 && jsonResponse.isNotEmpty) {

        for (var element in jsonResponse) {

          sortDataMarket.add(Coin.fromJson(element));

          List<List<double>> lineChartData = [];//await fetchLineChartData(element['id']);

          final res = Market();// parseMarketData(jsonResponse);
          print("Start setMarketToAsset");
          contract.listContract.every((ls) {
            print("element.id ${element['id']}");
            print("ls.id ${ls.id}");

            if (ls.id == element['id']){
              // ls.marketData = 

              print("start setMarket");
              contract.setMarketToAsset(
                contract.listContract.indexOf(ls),
                res,
                lineChartData,
                element['current_price'].toString(),
                element['price_change_percentage_24h'] == null ? "0" : element['price_change_percentage_24h'].toString(),
              );
            }
            return true;
          });

          print("End End");
        
          // if (element['id'] == "kiwigo") {
          //   contract.setkiwigoMarket(
          //     res,
          //     lineChartData,
          //     element['current_price'].toString(),
          //     element['price_change_percentage_24h'] == null ? "0" : element['price_change_percentage_24h'].toString(),
          //   );
          // } 
          //else if (element['id'] == "ethereum") {
          //   contract.setEtherMarket(
          //     res,
          //     lineChartData,
          //     element['current_price'].toString(),
          //     element['price_change_percentage_24h'] == null ? "0" : element['price_change_percentage_24h'].toString(),
          //   );
          // } else if (element['id'] == "binancecoin") {
          //   contract.setBnbMarket(
          //     res,
          //     lineChartData,
          //     element['current_price'].toString(),
          //     element['price_change_percentage_24h'] == null ? "0" : element['price_change_percentage_24h'].toString(),
          //   );
          // } else if (element['id'] == "polkadot") {
          //   await api.setDotMarket(
          //     res,
          //     lineChartData,
          //     element['current_price'].toString(),
          //     element['price_change_percentage_24h'] == null ? "0" : element['price_change_percentage_24h'].toString(),
          //     context: context
          //   );
          // } else if (element['id'] == "bitcoin") {
          //   await api.setBtcMarket(
          //     res,
          //     lineChartData,
          //     element['current_price'].toString(),
          //     element['price_change_percentage_24h'] == null ? "0" : element['price_change_percentage_24h'].toString(),
          //     context: context
          //   );
          // }
        }

        contract.notifyListeners();
      }

      notifyListeners();
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Error fetchTokenMarketPrice $e");
        }
      
      return;
    }
    
    // }

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
    debugPrint("searchCoinFromMarket $id");
    lsCoin!.clear();
    try {

      _res = await http.get(Uri.parse('https://api.coingecko.com/api/v3/search?query=${id.toLowerCase()}'));
      
      if (json.decode(_res!.body).isNotEmpty){
        lsCoin = List<Map<String, dynamic>>.from( (await json.decode(_res!.body))['coins'] );
        lsCoin = lsCoin!.where((element){
          if (element['symbol'].toLowerCase() == id.toLowerCase() && element['market_cap_rank'] != null){
            return true;
          }
          return false;
        }).toList();
      }
      return lsCoin!;
    } catch (e) {
      
      if (kDebugMode) {
        debugPrint("Error searchCoinFromMarket $e");
      }
      
    }
    return lsCoin!;
  }

  Future<Map<String, dynamic>?> queryCoinFromMarket(String id) async {

    queried = {};

    try {

      // http.Response value = await http.Response(json.encode(mkData), 200);
      await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}$id&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en')).then((value) async {

        debugPrint(value.body);

        if (value.statusCode == 200 && json.decode(value.body).isNotEmpty){

          queried = await json.decode(value.body)[0];
        } else {
          queried = {};
        }

      });

      debugPrint("queried queryCoinFromMarket $queried");
      
    } catch (e){
      
      if (kDebugMode) {
        debugPrint("error queryCoinFromMarket $e");
      }
      return queried;
    }

    return queried;
  }
  
  Future<void> fetchTrendingCoin() async {

    if(kDebugMode) debugPrint("fetchTrendingCoin");
    
    try {
      
      final res = await http.get(Uri.parse('https://api.coingecko.com/api/v3/search/trending'));
      
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
        debugPrint("error fetch trending coin $e");
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

    if(kDebugMode) debugPrint("listMarketCoin");

    try {

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
        debugPrint("error fetch listMarketCoin $e");
      }
    }

    return [];

  }

  String conceteApi(){
    
    for(String id in id){
      AppConfig.coingeckoBaseUrl = "${AppConfig.coingeckoBaseUrl}$id%2C%20";
    }

    return "${AppConfig.coingeckoBaseUrl}&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=1h";
    
  }

}
