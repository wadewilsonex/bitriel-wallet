import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/backend.dart';
<<<<<<< HEAD
import 'package:wallet_apps/src/models/swap_m.dart';
=======
>>>>>>> daveat

String? _api;

Future<http.Response> getSelendraEndpoint() async {
  return await http.get(Uri.parse(dotenv.get('SELENDRA_API_BITRIEL')));
}

Future<http.Response> getContractAddress() async {
  return await http.get(Uri.parse(dotenv.get('SELENDRA_API_CONTRACT_ADDRESS')));
}

Future<http.Response> getDeepLinkRoutes() async {
  return await http.get(Uri.parse(dotenv.get('SELENDRA_API_DEEPLINK')));
}

Future<http.Response> getEventJSON() async {
  debugPrint("getEventJSON");
  return await http.get(Uri.parse(dotenv.get('EVENT')));
}

/* MetaDoers World */

Future<http.Response> getAllEvent() async {
  return await http.get(Uri.parse("${dotenv.get('DOERS_API')}events"));
}

Future<http.Response> getTickets(String tk) async {
  // String js = await rootBundle.loadString('assets/json/tickets.json');
  // debugPrint(js);
  // return http.Response(js, 200);

  return await http.get(
      // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
      Uri.parse("${dotenv.get('DOERS_API')}tickets"),
      headers: conceteHeader(key: "Authorization", value: tk));
}

Future<http.Response> queryEventById(String evntId) async {

  return await http.get(
    // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
    Uri.parse("${dotenv.get('DOERS_API')}events/$evntId"),
    headers: conceteHeader()
  );
}

Future<http.Response> queryTrxStatus(String id) async {

  _api = dotenv.get('LETS_EXCHANGE_API');
  return await http.get(
    // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
    Uri.parse("$_api/v1/transaction/$id"),
    headers: conceteHeader()
  );
}


/// Token Info
/// 
Future<http.Response> coins() async {
  debugPrint('coins');
  _api ??= dotenv.get('LETS_EXCHANGE_API');

  debugPrint(_api);

  return await http.get(
    Uri.parse("$_api/v2/coins"),
    headers: conceteHeader()
  );

}
<<<<<<< HEAD
=======


// Convert Coin
Future<http.Response> convertCoin(String fromCoin, String toCoin, String amount) async {
  return await http.get(
    Uri.parse("https://api.coinconvert.net/convert/$fromCoin/$toCoin?amount=$amount"),
    headers: conceteHeader(),
  );

}

// Convert Coin
Future<http.Response> downloadAssets(String fileName) async {
  return await http.get(
    Uri.parse("${dotenv.get('BITRIEL_ASSETS')}$fileName"),
    headers: conceteHeader(),
  );

}
>>>>>>> daveat
