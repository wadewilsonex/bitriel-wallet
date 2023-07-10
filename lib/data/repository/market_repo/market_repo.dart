import 'dart:convert';

import 'package:bitriel_wallet/data/api/api_client.dart';
import 'package:bitriel_wallet/domain/model/market_top100_m.dart';
import 'package:bitriel_wallet/index.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// {
// 	"status": {
// 		"error_code": 429,
// 		"error_message": "You've exceeded the Rate Limit. Please visit https://www.coingecko.com/en/api/pricing to subscribe to our API plans for higher rate limits."
// 	}
// }

class MarketProvider with ChangeNotifier {

  static BuildContext? context;

  List<ListMetketCoinModel> lsMarketLimit = List<ListMetketCoinModel>.empty(growable: true);

  Future<List<ListMetketCoinModel>> listMarketCoin() async{

    if(kDebugMode) debugPrint("listMarketCoin");

    try {

      final res = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'),
        headers: ApiClient.conceteHeader(
          // key: "User-Agent",
          // value: FkUserAgent.userAgent,
        )
      );

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


}