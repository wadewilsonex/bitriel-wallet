import 'package:bitriel_wallet/index.dart';

class MarketUCImpl implements MarketUseCases {

  MarketRepoImpl marketRepoImpl = MarketRepoImpl();

  ValueNotifier<List<Market>> lstMarket = ValueNotifier([]);
  
  ValueNotifier<bool> backToTop = ValueNotifier(false);
  
  ScrollController scrollController = ScrollController();

  @override
  Future<void> getMarkets() async {

    lstMarket.value = [];
    lstMarket.value = await marketRepoImpl.getMarkets();
  }
}