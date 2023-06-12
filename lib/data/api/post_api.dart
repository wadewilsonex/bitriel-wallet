import 'package:bitriel_wallet/index.dart';
import 'package:http/http.dart' as http;

class GetRequest {

  static String? _api;
  /// Http Header
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

  static Future<http.Response> getEventJSON() async {
    return await http.get(Uri.parse(dotenv.get('EVENT')));
  }

  /* MetaDoers World */

  static Future<http.Response> getAllEvent() async {
    return await http.get(Uri.parse("${dotenv.get('DOERS_API')}events"));
  }

  static Future<http.Response> getTickets(String tk) async {

    return await http.get(
      // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
      Uri.parse("${dotenv.get('DOERS_API')}tickets"),
      headers: conceteHeader(key: "Authorization", value: tk)
    );
  }

  static Future<http.Response> queryEventById(String evntId) async {

    return await http.get(
      // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
      Uri.parse("${dotenv.get('DOERS_API')}events/$evntId"),
      headers: conceteHeader()
    );
  }

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
}
