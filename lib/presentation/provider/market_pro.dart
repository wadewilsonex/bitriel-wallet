import 'package:bitriel_wallet/index.dart';

class MarketProvider with ChangeNotifier{

  final MarketUsecasesImpl marketUsecasesImpl = MarketUsecasesImpl();

  Future<void> getMarket() async {
    await marketUsecasesImpl.getMarketData();

    print("marketUsecasesImpl.listMarket ${marketUsecasesImpl.listMarket}");
  }
}