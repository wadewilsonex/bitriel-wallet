import 'package:bitriel_wallet/index.dart';

class MarketUCImpl implements MarketUseCases {

  MarketRepoImpl marketRepoImpl = MarketRepoImpl();

  ValueNotifier<List<Market>> lstMarket = ValueNotifier([]);

  ValueNotifier<List<ListMetketCoinGecko>> lstMarketCoinGecko = ValueNotifier([]);
  
  ValueNotifier<bool> backToTop = ValueNotifier(false);
  
  ScrollController scrollController = ScrollController();

  @override
  Future<void> getMarkets() async {

    lstMarket.value = [];
    lstMarket.value = await marketRepoImpl.getMarkets();
  }

  @override
  Future<void> getMarketsCoinGecko(String? id) async {

    lstMarketCoinGecko.value = [];
    lstMarketCoinGecko.value = await marketRepoImpl.getMarketsCoinGecko(id);
  }
}