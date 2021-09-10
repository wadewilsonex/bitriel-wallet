import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';

import '../../index.dart';

class MarketProvider with ChangeNotifier {
  List<String> id = [
    'kiwigo',
    'ethereum',
    'binancecoin',
    'polkadot',
    'bitcoin',
    'selendra'
  ];

  List<Map<String, dynamic>> sortDataMarket = [];

  Market parseMarketData(String responseBody) {
    Market data;
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    for (var i in parsed) {
      data = Market.fromJson(i as Map<String, dynamic>);
    }
    return data;
  }

  Future<List<List<double>>> fetchLineChartData(String id) async {
    List<List<double>> prices;
    final res = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=usd&days=1'));

    if (res.statusCode == 200) {
      final data = await jsonDecode(res.body);

      CryptoData mData = CryptoData.fromJson(data);

      prices = mData.prices;
    }

    return prices ?? null;
  }

  Future<void> findMarketPrice(String asset) async {
    String marketPrice;
    final contract = ContractProvider();
    final api = ApiProvider();
    switch (asset) {
      case 'KGO':
        marketPrice = contract.listContract[2].marketPrice;
        print(contract.listContract[2].marketPrice);
        break;
      case 'BTC':
        print(api.btc.marketPrice);
        marketPrice = api.btc.marketPrice;
        break;
      case 'ETH':
        print(contract.listContract[3].marketPrice);
        marketPrice = contract.listContract[3].marketPrice;
        break;
      case 'BNB':
        print(contract.listContract[4].marketPrice);
        marketPrice = contract.listContract[4].marketPrice;
        break;
    }
    return marketPrice;
  }

  Future<void> fetchTokenMarketPrice(BuildContext context) async {
    final contract = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);
    sortDataMarket.clear();

    for (int i = 0; i < id.length; i++) {
      try {
        final response =
            await http.get('${AppConfig.coingeckoBaseUrl}${id[i]}');
        // print("id[i] ${id[i]}");
        // print(response.body);
        // print("id[i] ${id[i]}");
        // print("${id[i]} ${json.decode(response.body)[0]}");
        sortDataMarket.addAll({await json.decode(response.body)[0]});
        final lineChartData = await fetchLineChartData(id[i]);

        if (response.statusCode == 200) {
          final jsonResponse = await convert.jsonDecode(response.body);

          final res = parseMarketData(response.body);

          //final market = Market.fromJson(jsonResponse);

          if (i == 0) {
            contract.setkiwigoMarket(
              res,
              lineChartData,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 1) {
            contract.setEtherMarket(
              res,
              lineChartData,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 2) {
            contract.setBnbMarket(
              res,
              lineChartData,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 3) {
            api.setDotMarket(
              res,
              lineChartData,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 4) {
            api.setBtcMarket(
              res,
              lineChartData,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          }
        }
      } catch (e) {
        // contract.setReady();
      }
    }

    // Fill Market Price Into Asset
    // for (int i = 0; i< sortDataMarket.length; i++){
    //   contract.listContract[i].marketPrice = sortDataMarket[i]['current_price'];
    // }

    // Sort Market Price
    Map<String, dynamic> tmp = {};
    for (int i = 0; i < sortDataMarket.length; i++) {
      for (int j = i + 1; j < sortDataMarket.length; j++) {
        tmp = sortDataMarket[i];
        if (sortDataMarket[j]['market_cap_rank'] < tmp['market_cap_rank']) {
          sortDataMarket[i] = sortDataMarket[j];
          sortDataMarket[j] = tmp;
        }
      }
    }

    // notifyListeners();
  }
}
