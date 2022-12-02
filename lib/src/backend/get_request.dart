

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as _http;

Future<_http.Response> getSelendraEndpoint() async {
  print("getSelendarEndpoint ${dotenv.get('SELENDRA_API')}");
  return await _http.get(Uri.parse(dotenv.get('SELENDRA_API')));
}