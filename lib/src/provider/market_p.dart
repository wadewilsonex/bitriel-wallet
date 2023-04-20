import 'package:http/http.dart' as http;
import 'package:wallet_apps/src/models/list_market_coin_m.dart';
import 'package:wallet_apps/src/models/trendingcoin_m.dart';

import '../../index.dart';

List<dynamic> mkData = [
	{
		"id": "ethereum",
		"symbol": "eth",
		"name": "Ethereum",
		"image": "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880",
		"current_price": 2099.24,
		"market_cap": 251309292714,
		"market_cap_rank": 2,
		"fully_diluted_valuation": 251309292714,
		"total_volume": 8683050978,
		"high_24h": 2110.22,
		"low_24h": 2082.56,
		"price_change_24h": 7.11,
		"price_change_percentage_24h": 0.33973,
		"market_cap_change_24h": 15677489,
		"market_cap_change_percentage_24h": 0.00624,
		"circulating_supply": 119716878.435074,
		"total_supply": 119716878.435074,
		"max_supply": null,
		"ath": 4878.26,
		"ath_change_percentage": -56.97937,
		"ath_date": "2021-11-10T14:24:19.604Z",
		"atl": 0.432979,
		"atl_change_percentage": 484602.23113,
		"atl_date": "2015-10-20T00:00:00.000Z",
		"roi": {
			"times": 91.4385425118268,
			"currency": "btc",
			"percentage": 9143.85425118268
		},
		"last_updated": "2023-04-16T05:32:56.472Z"
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

    final response = await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}${id.join(',')}'));

    final jsonResponse = List<Map<String, dynamic>>.from(await json.decode(response.body));

    // for (int i = 0; i < id.length; i++) {
    try {

      if (response.statusCode == 200 && jsonResponse.isNotEmpty) {

        for (int i = 0; i < jsonResponse.length; i++) {

          sortDataMarket.addAll({jsonResponse[i]});
        

          List<List<double>> lineChartData = [];//await fetchLineChartData(jsonResponse[i]['id']);

          final res = Market();// parseMarketData(jsonResponse);
      
        
          if (jsonResponse[i]['id'] == "kiwigo") {
            contract.setkiwigoMarket(
              res,
              lineChartData,
              jsonResponse[i]['current_price'].toString(),
              jsonResponse[i]['price_change_percentage_24h'] == null ? "0" : jsonResponse[i]['price_change_percentage_24h'].toString(),
            );
          } else if (jsonResponse[i]['id'] == "ethereum") {
            contract.setEtherMarket(
              res,
              lineChartData,
              jsonResponse[i]['current_price'].toString(),
              jsonResponse[i]['price_change_percentage_24h'] == null ? "0" : jsonResponse[i]['price_change_percentage_24h'].toString(),
            );
          } else if (jsonResponse[i]['id'] == "binancecoin") {
            contract.setBnbMarket(
              res,
              lineChartData,
              jsonResponse[i]['current_price'].toString(),
              jsonResponse[i]['price_change_percentage_24h'] == null ? "0" : jsonResponse[i]['price_change_percentage_24h'].toString(),
            );
          } else if (jsonResponse[i]['id'] == "polkadot") {
            await api.setDotMarket(
              res,
              lineChartData,
              jsonResponse[i]['current_price'].toString(),
              jsonResponse[i]['price_change_percentage_24h'] == null ? "0" : jsonResponse[i]['price_change_percentage_24h'].toString(),
              context: context
            );
          } else if (jsonResponse[i]['id'] == "bitcoin") {
            await api.setBtcMarket(
              res,
              lineChartData,
              jsonResponse[i]['current_price'].toString(),
              jsonResponse[i]['price_change_percentage_24h'] == null ? "0" : jsonResponse[i]['price_change_percentage_24h'].toString(),
              context: context
            );
          }

        }
      }

      notifyListeners();
    } catch (e) {
      
        if (kDebugMode) {
          print("Error fetchTokenMarketPrice $e");
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
    print("searchCoinFromMarket $id");
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
        print(lsCoin);
      }
      return lsCoin!;
    } catch (e) {
      
      if (kDebugMode) {
        print("Error searchCoinFromMarket $e");
      }
      
    }
    return lsCoin!;
  }

  Future<Map<String, dynamic>?> queryCoinFromMarket(String id) async {

    queried = {};

    try {

      // http.Response value = await http.Response(json.encode(mkData), 200);
      await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}$id&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en')).then((value) async {

        print(value.body);

        if (value.statusCode == 200 && json.decode(value.body).isNotEmpty){

          queried = await json.decode(value.body)[0];
        } else {
          queried = {};
        }

      });

      print("queried queryCoinFromMarket $queried");
      
    } catch (e){
      
      if (kDebugMode) {
        print("error queryCoinFromMarket $e");
      }
      return queried;
    }

    return queried;
  }
  
  Future<void> fetchTrendingCoin() async {

    if(kDebugMode) print("fetchTrendingCoin");
    
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

    if(kDebugMode) print("listMarketCoin");

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
        print("error fetch listMarketCoin $e");
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
