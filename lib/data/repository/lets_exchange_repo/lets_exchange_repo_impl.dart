import 'package:bitriel_wallet/domain/model/lets_exchange_coin_m.dart';
import 'package:bitriel_wallet/index.dart';

class LetsExchangeRepoImpl implements LetsExchangeRepository {

  @override
  Future<List<LetsExchangeCoin>> getLetsExchangeCoin() async{
    
    List<LetsExchangeCoin> lstLECoin = [];
    await GetRequest.getLetsExchangeCoin().then((value) {
      if (value.statusCode == 200) {
        var json = jsonDecode(value.body);
        for (var jsonLECoin in json){
          var leCoin = LetsExchangeCoin.fromJson(jsonLECoin);
          lstLECoin.add(leCoin);
        }

        print("json lets exchange $json");
      }
    });

    return lstLECoin;

  }

}