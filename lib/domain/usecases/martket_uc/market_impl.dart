import 'package:bitriel_wallet/index.dart';

class MarketUsecasesImpl implements MarketUsecases {

  List<ListMetketCoinModel> listMarket = [];

  MarketRepoImpl marketRepoImpl = MarketRepoImpl();

  @override
  Future<void> getMarketData() async {
    listMarket = await marketRepoImpl.listMarketCoin();
  }

}