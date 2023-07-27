import 'package:bitriel_wallet/index.dart';

abstract class MarketRepository {
  Future<List<Market>> getMarkets();

  Future<List<ListMetketCoinGecko>> getMarketsCoinGecko(String? id);
}