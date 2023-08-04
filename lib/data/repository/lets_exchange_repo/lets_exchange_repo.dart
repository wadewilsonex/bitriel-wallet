import 'package:bitriel_wallet/index.dart';

abstract class LetsExchangeRepository {
  Future<List<LetsExchangeCoin>> getLetsExchangeCoin();
}