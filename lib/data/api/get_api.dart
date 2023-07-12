import 'package:bitriel_wallet/index.dart';
import 'package:http/http.dart' as http;

class GetRequest {

  static String? _api;
  /// Http Requests Header
  static Map<String, String> conceteHeader({String? key, String? value}) { /* Concete More Content Of Header */
    return key != null 
    ? { /* if Parameter != Null = Concete Header With  */
      "Content-Type": "application/json; charset=utf-8", 
      'accept': 'application/json',
      key: value!
    }
    : { /* if Parameter Null = Don't integrate */
      "Content-Type": "application/json; charset=utf-8",
      'accept': 'application/json'
    };
  }

  static Future<http.Response> getSelendraEndpoint() async {
    return await http.get(Uri.parse(dotenv.get('SELENDRA_API_BITRIEL')));
  }

  static Future<http.Response> getContractAddress() async {
    return await http.get(Uri.parse(dotenv.get('SELENDRA_API_CONTRACT_ADDRESS')));
  }

  static Future<http.Response> getDeepLinkRoutes() async {
    return await http.get(Uri.parse(dotenv.get('SELENDRA_API_DEEPLINK')));
  }

  /*--------------- LETS EXCHANGE API FUNCTION ---------------*/
  static Future<http.Response> queryTrxStatus(String id) async {

    _api = dotenv.get('LETS_EXCHANGE_API');
    return await http.get(
      // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
      Uri.parse("$_api/v1/transaction/$id"),
      headers: conceteHeader()
    );
  }

  /// Token Info
  /// 
  static Future<http.Response> coins() async {
    _api ??= dotenv.get('LETS_EXCHANGE_API');

    return await http.get(
      Uri.parse("$_api/v2/coins"),
      headers: conceteHeader()
    );

  }

  // Convert Coin
  static Future<http.Response> convertCoin(String fromCoin, String toCoin, String amount) async {
    return await http.get(
      Uri.parse("https://api.coinconvert.net/convert/$fromCoin/$toCoin?amount=$amount"),
      headers: conceteHeader(),
    );

  }

  // Get News article
  static Future<http.Response> getNewsArticle() async {
    return await http.get(
      Uri.parse("https://min-api.cryptocompare.com/data/v2/news/?categories=Blockchain,Mining?lang=EN&api_key=${dotenv.get("CRYPTOCOMPARE_APIKEY")}"),
      headers: conceteHeader(),
    );
  }

  // Convert Coin
  static Future<http.Response> downloadFile(String fileName) async {
    return await http.get(
      Uri.parse("${dotenv.get('BITRIEL_ASSETS')}$fileName"),
      headers: conceteHeader(),
    );

  }

  static Future<http.Response> fetchAddrUxtoBTC(String btcAddr) async {
    return await http.get(
      Uri.parse("https://blockstream.info/api/address/$btcAddr/utxo"),
      headers: conceteHeader(),
    );

  }

  static Future<List<ListMetketCoinModel>> listMarketCoin() async{
    
    List<ListMetketCoinModel> lsMarketLimit = List<ListMetketCoinModel>.empty(growable: true);

    final String ua = await userAgent();

    try {

      final res = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'),
        headers: ApiClient.conceteHeader(
          key: "User-Agent",
          value: ua,
        )
      );

      lsMarketLimit = List<ListMetketCoinModel>.empty(growable: true);

      if (res.statusCode == 200) {
        final data = await jsonDecode(res.body);

        for(int i = 0; i < data.length; i++){
          
          lsMarketLimit.add(ListMetketCoinModel().fromJson(data[i]));

        }

        return lsMarketLimit;
      }
      
    } catch (e){
      
      if (kDebugMode) {
        debugPrint("error fetch listMarketCoin $e");
      }
    }

    return [];

  }

}
