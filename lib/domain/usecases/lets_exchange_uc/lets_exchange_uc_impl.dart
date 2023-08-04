import 'package:bitriel_wallet/index.dart';

class LetsExchangeUCImpl implements LetsExchangeUseCases {

  LetsExchangeRepoImpl letsExchangeRepoImpl = LetsExchangeRepoImpl();

  ValueNotifier<List<LetsExchangeCoin>> lstLECoin = ValueNotifier([]);

  @override
  Future<void> getLetsExchangeCoin() async {

    lstLECoin.value = [];
    lstLECoin.value = await letsExchangeRepoImpl.getLetsExchangeCoin();
  }

}