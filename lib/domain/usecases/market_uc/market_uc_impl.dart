import 'package:bitriel_wallet/data/repository/market_repo/market_repo_impl.dart';
import 'package:bitriel_wallet/domain/usecases/market_uc/market_uc.dart';
import 'package:bitriel_wallet/index.dart';

class MarketUCImpl implements MarketUseCases {

  MarketRepoImpl marketRepoImpl = MarketRepoImpl();

  @override
  Future<List<Market>> getMarkets() async {
    return await marketRepoImpl.getMarkets();
  }
}