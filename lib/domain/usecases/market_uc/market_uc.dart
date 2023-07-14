import 'package:bitriel_wallet/index.dart';

abstract class MarketUseCases {
  Future<List<Market>> getMarkets();
}