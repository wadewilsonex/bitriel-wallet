import 'package:bitriel_wallet/data/api/post_api.dart';
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
      }
    });

    return lstLECoin;

  }

  // Post Request
  @override
  Future<Response> swap(Map<String, dynamic> mapData) async {

    return await PostRequest().swap(mapData);
  }

  @override
  Future<Response> getLetsExStatusByTxId(String txId) async {
    return await GetRequest.getLetsExStatusByTxId(txId);
  }

}