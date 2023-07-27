abstract class MarketUseCases {
  Future<void> getMarkets();

  Future<void> getMarketsCoinGecko(String? id);
}