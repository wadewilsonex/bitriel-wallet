// import 'package:bitriel_wallet/data/api/get_api.dart';
import 'package:bitriel_wallet/index.dart';
// import 'package:http/http.dart' as http;

// {
// 	"status": {
// 		"error_code": 429,
// 		"error_message": "You've exceeded the Rate Limit. Please visit https://www.coingecko.com/en/api/pricing to subscribe to our API plans for higher rate limits."
// 	}
// }

abstract class MarketRepo {
  
  Future<List<ListMetketCoinModel>> listMarketCoin();

}