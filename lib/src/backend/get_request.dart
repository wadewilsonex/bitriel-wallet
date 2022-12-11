

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as _http;
import 'package:wallet_apps/src/backend/backend.dart';

Future<_http.Response> getSelendraEndpoint() async {
  print("getSelendarEndpoint ${dotenv.get('SELENDRA_API')}");
  return await _http.get(Uri.parse(dotenv.get('SELENDRA_API')));
}

/* MetaDoers World */

Future<_http.Response> getAllEvent() async {
  print("getAllEvent ${dotenv.get('DOERS_API')}");
  return await _http.get(Uri.parse("${dotenv.get('DOERS_API')}events"));
}