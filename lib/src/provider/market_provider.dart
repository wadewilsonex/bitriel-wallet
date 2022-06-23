import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';

import '../../index.dart';

class MarketProvider with ChangeNotifier {
  
  http.Response? _res;

  List<Map<String, dynamic>>? lsCoin;

  List<String> id = [
    'kiwigo',
    'ethereum',
    'binancecoin',
    'polkadot',
    'bitcoin',
    'selendra'
  ];

  List<Map<String, dynamic>> sortDataMarket = [];

  Market? parseMarketData(List<Map<String, dynamic>> responseBody) {
    Market? data;

    for (var i in responseBody) {
      data = Market.fromJson(i);
    }
    return data;
  }

  set setLsCoin(List<dynamic> ls){
    lsCoin = [];
    lsCoin = List<Map<String, dynamic>>.from(ls);
  }

  Future<List<List<double>>?> fetchLineChartData(String id) async {
    List<List<double>>? prices;
    final res = await http.get(Uri.parse( 'https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=usd&days=1'));

    if (res.statusCode == 200) {
      final data = await jsonDecode(res.body);

      CryptoData mData = CryptoData.fromJson(data);

      prices = mData.prices;
    }

    return prices ?? null;
  }

  Future<void> fetchTokenMarketPrice(BuildContext context) async {

    final contract = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);
    sortDataMarket.clear();

    for (int i = 0; i < id.length; i++) {
      try {

        final response = await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}${id[i]}'));

        final jsonResponse = List<Map<String, dynamic>>.from(await json.decode(response.body));

        if (response.statusCode == 200 && jsonResponse.isNotEmpty) {
          sortDataMarket.addAll({jsonResponse[0]});

          final lineChartData = await fetchLineChartData(id[i]);

          final res = parseMarketData(jsonResponse);

          if (i == 0) {
            contract.setkiwigoMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 1) {
            contract.setEtherMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 2) {
            contract.setBnbMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h'].toStringAsFixed(2).toString(),
            );
          } else if (i == 3) {
            await api.setDotMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
              context: context
            );
          } else if (i == 4) {
            await api.setBtcMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h'].toStringAsFixed(2).toString(),
              context: context
            );
          }
        }

        notifyListeners();
      } catch (e) {
        if (ApiProvider().isDebug == true) print("error market $e");
      }
    }

    // Sort Market Price
    // Map<String, dynamic> tmp = {};
    // for (int i = 0; i < sortDataMarket.length; i++) {
    //   for (int j = i + 1; j < sortDataMarket.length; j++) {
    //     tmp = sortDataMarket[i];
    //     if (sortDataMarket[j]['market_cap_rank'] < tmp['market_cap_rank']) {
    //       sortDataMarket[i] = sortDataMarket[j];
    //       sortDataMarket[j] = tmp;
    //     }
    //   }
    // }

    notifyListeners();
  }

  Future<dynamic> queryCoinFromMarket(String id) async {
    print("id $id");
    print("queryCoinFromMarket");
    return json.decode((await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}${id}'))).body);
  }
}
