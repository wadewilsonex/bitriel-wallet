import 'package:http/http.dart' as http;

abstract class HttpRequestRepo {
  
  Future<http.Response> fetchAddrUxtoBTC(String btcAddr);
  Future<List<String>> fetchSelendraEndpoint();
}