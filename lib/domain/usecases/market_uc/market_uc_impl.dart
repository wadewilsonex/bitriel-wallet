import 'package:bitriel_wallet/index.dart';

class MarketUCImpl implements MarketUseCases {

  MarketRepoImpl marketRepoImpl = MarketRepoImpl();

  ValueNotifier<List<Market>> lstMarket = ValueNotifier([]);

  ValueNotifier<List<SmartContractModel>> smMarket = ValueNotifier([]);
  
  ValueNotifier<bool> backToTop = ValueNotifier(false);
  
  ScrollController scrollController = ScrollController();

  @override
  Future<void> getMarkets() async {

    lstMarket.value = await marketRepoImpl.getMarkets();

  }

}