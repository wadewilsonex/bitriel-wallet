import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_apps/src/constants/db_key_con.dart';
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

class MarketProvider with ChangeNotifier {

  static BuildContext? context;
  
  http.Response? _res;
  
  List<CoinsModel> cnts = List<CoinsModel>.empty(growable: true);

  List<ListMetketCoinModel> lsMarketLimit = List<ListMetketCoinModel>.empty(growable: true);

  List<ListMetketCoinModel> ls7Market = List<ListMetketCoinModel>.empty(growable: true);

  List<Map<String, dynamic>>? lsCoin = [];

  Map<String, dynamic>? coinMarketDescription;

  Map<String, dynamic>? queried;

  static ApiProvider? _apiPro;
  static ContractProvider? _contractPro;
  static http.Response? response;

  static get getBuildContext => context!;

  set setBuildContext(ct) {
    context = ct;
  }

  static List<String> id = [
    'selendra', //1
    'selendra_v1', //2
    'selendra_v2', //3
    'ethereum', //4
    'binancecoin', //5
    'polkadot', //6
    'bitcoin', //7
    'reakreay', //8
    'tether' // 10
  ];

  static List<Coin> sortDataMarket = [];
  static List<Map<String, dynamic>>? tojson = [];
  
  static List<Map<String, dynamic>> sortDataToJson(){

    tojson = [];
    for(var e in sortDataMarket){
      tojson!.add(e.toJson());
    }

    return tojson!;
  }

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

  static Future<void> fetchTokenMarketPrice({bool? isQueryApi = false}) async {

    _contractPro = Provider.of<ContractProvider>(context!, listen: false);

    _apiPro = Provider.of<ApiProvider>(context!, listen: false);
    
    sortDataMarket.clear();

    if (isQueryApi == false){

      await StorageServices.fetchData(DbKey.marketData).then((value) async {
        
        // Have Cache Data => Fill Out
        if (value != null && isQueryApi == false){
          
          response =  http.Response(json.encode(value), 200);
        }
        // No Cache Data => Fetch New 
        else {

          response = await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}${id.join(',')}'));
        }
      });

    }
    // Refetch Data 
    else {

      response = await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}${id.join(',')}'));
    }

    // ignore: use_build_context_synchronously
    await decodingMarketData(context!);
  }
  
  static Future<void> decodingMarketData(BuildContext context) async {
    _contractPro = Provider.of<ContractProvider>(context, listen: false);
    _apiPro = Provider.of<ApiProvider>(context, listen: false);

    try {

      if (response!.statusCode == 200) {

        List<dynamic> jsonResponse = await json.decode(response!.body);

        for (var element in jsonResponse) {

          sortDataMarket.add(Coin.fromJson(element));

          List<List<double>> lineChartData = [];//await fetchLineChartData(element['id']);

          final res = Market();// parseMarketData(jsonResponse);

          _contractPro!.listContract.every((ls) {
            if (ls.id == element['id']){

              _contractPro!.setMarketToAsset(
                _contractPro!.listContract.indexOf(ls),
                res,
                lineChartData,
                element['current_price'].toString(),
                element['price_change_percentage_24h'] == null ? "0" : element['price_change_percentage_24h'].toString(),
              );
            }
            return true;
          });
        }

        await StorageServices.storeData(sortDataToJson(), DbKey.marketData);
      }

    } catch (e) {
      
      if (kDebugMode) {
        
      }
      
      return;
    }
  }

  Future<List<Map<String, dynamic>>> searchCoinFromMarket(String id) async {
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
        
      }
      
    }
    return lsCoin!;
  }

  Future<Map<String, dynamic>?> queryCoinFromMarket(String id) async {

    queried = {};

    try {

      // http.Response value = await http.Response(json.encode(mkData), 200);
      await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}$id&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en')).then((value) async {

        if (value.statusCode == 200 && json.decode(value.body).isNotEmpty){

          queried = await json.decode(value.body)[0];
        } else {
          queried = {};
        }

      });

      
      
    } catch (e){
      
      if (kDebugMode) {
        
      }
      return queried;
    }

    return queried;
  }
  
  Future<void> fetchTrendingCoin() async {

    if(kDebugMode) 
    
    try {
      
      // final res = await http.get(Uri.parse('https://api.coingecko.com/api/v3/search/trending'));
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

    if(kDebugMode) {
      try {

      final res = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

      lsMarketLimit = List<ListMetketCoinModel>.empty(growable: true);

      if (res.statusCode == 200) {
        final data = await jsonDecode(res.body);

        for(int i = 0; i < data.length; i++){
          
          lsMarketLimit.add(ListMetketCoinModel().fromJson(data[i]));

          if (i < 7) ls7Market.add(ListMetketCoinModel().fromJson(data[i]));

        }
        notifyListeners();

        return lsMarketLimit;
      }
      
    } catch (e){
      
      if (kDebugMode) {
        
      }
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
