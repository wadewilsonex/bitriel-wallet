import 'package:bitriel_wallet/index.dart';

abstract class LetsExchangeRepository {
  Future<List<LetsExchangeCoin>> getLetsExchangeCoin();
  Future<Response> swap(Map<String, dynamic> mapData);
}