import 'package:bitriel_wallet/data/api/get_api.dart';
import 'package:bitriel_wallet/index.dart';

class MarketRepoImpl implements MarketRepo {

  @override
  Future<List<ListMetketCoinModel>> listMarketCoin() async {

    return await GetRequest.listMarketCoin().then((value) {
      return List<dynamic>.from(jsonDecode(value.body)).map((e) {
        return ListMetketCoinModel().fromJson(e);
      }).toList();
    });
    
  }
}


    // lsMarketLimit = List<ListMetketCoinModel>.empty(growable: true);

    // if (res.statusCode == 200) {
      
    //   // List<dynamic> data = await ;

    //   print("List<dynamic>.from(jsonDecode(res.body)) ${List<dynamic>.from(jsonDecode(res.body))}");
    //   return List<dynamic>.from(jsonDecode(res.body)).map((e) {
    //     return ListMetketCoinModel().fromJson(e);
    //   }).toList();

    //   // for(int i = 0; i < data.length; i++){
        
    //   //   lsMarketLimit.add(ListMetketCoinModel().fromJson(data[i]));

    //   // }