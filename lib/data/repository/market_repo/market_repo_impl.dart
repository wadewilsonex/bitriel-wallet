import 'package:bitriel_wallet/data/api/get_api.dart';
import 'package:bitriel_wallet/index.dart';

class MarketRequestImpl extends MarketRequestRepo {

  @override
  Future<List<ListMetketCoinModel>> listMarketCoin() async {
    return await GetRequest.listMarketCoin();
  }
}