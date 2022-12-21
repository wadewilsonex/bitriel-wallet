

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/backend.dart';

Future<http.Response> getSelendraEndpoint() async {
  return await http.get(Uri.parse(dotenv.get('SELENDRA_API')));
}

/* MetaDoers World */

Future<http.Response> getAllEvent() async {
  return await http.get(Uri.parse("${dotenv.get('DOERS_API')}events"));
}

Future<http.Response> getTickets(String tk) async {
  
  // String js = await rootBundle.loadString('assets/json/tickets.json');
  // print(js);
  // return http.Response(js, 200);

  return await http.get(
    // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
    Uri.parse("${dotenv.get('DOERS_API')}tickets"),
    headers: conceteHeader(key: "Authorization", value: tk)
  );
}

Future<http.Response> queryEventById(String evntId) async {

  return await http.get(
    // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
    Uri.parse("${dotenv.get('DOERS_API')}events/$evntId"),
    headers: conceteHeader()
  );
}