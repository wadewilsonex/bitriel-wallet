import 'package:http/http.dart' as http;

abstract class HttpRequestRepo {
  
  Future<http.Response> fetchAddrUxtoBTC(String btcAddr);
  Future<Map<String, List<dynamic>>> fetchSelendraEndpoint();
  Future<List<Map<String, dynamic>>> fetchContractAddress();
}