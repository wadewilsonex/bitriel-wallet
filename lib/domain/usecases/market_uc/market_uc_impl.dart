import 'package:bitriel_wallet/index.dart';

class MarketUCImpl implements MarketUseCases {

  MarketRepoImpl marketRepoImpl = MarketRepoImpl();

  @override
  Future<List<Market>> getMarkets() async {
    return await marketRepoImpl.getMarkets();
  }
}