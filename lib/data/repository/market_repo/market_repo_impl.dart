import 'package:bitriel_wallet/data/api/get_api.dart';
import 'package:bitriel_wallet/index.dart';

class MarketRepoImpl implements MarketRepository {

  @override
  Future<List<Market>> getMarkets() async{
    
    List<Market> markets = [];
    await GetRequest.getMarkets().then((value) {
      if (value.statusCode == 200) {
        var json = jsonDecode(value.body);
        for (var jsonMarket in json['data']['cryptoCurrencyList']){
          var market = Market.fromJson(jsonMarket);
          markets.add(market);
        }
      }
    });

    return markets;

  }
}