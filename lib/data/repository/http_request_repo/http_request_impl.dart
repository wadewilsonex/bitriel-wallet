import 'dart:convert';
import 'package:bitriel_wallet/data/api/get_api.dart';
import 'package:bitriel_wallet/data/repository/http_request_repo/http_request_repo.dart';
import 'package:http/http.dart' as http;

class HttpRequestImpl extends HttpRequestRepo {

  @override
  Future<http.Response> fetchAddrUxtoBTC(String btcAddr) async {
    return await GetRequest.fetchAddrUxtoBTC(btcAddr);
  }

  @override
  Future<Map<String, List<dynamic>>> fetchSelendraEndpoint() async {
    return await GetRequest.getSelendraEndpoint().then((value) {
      return Map<String, List<dynamic>>.from(json.decode(value.body));
    });
  }
  
  @override
  Future<List<Map<String, dynamic>>> fetchContractAddress() async {
    return await GetRequest.getContractAddress().then((value) {
      return List<Map<String, dynamic>>.from(json.decode(value.body));
    });
  }

  Future<Map<String, dynamic>> getContractById(String id) async {
    return json.decode( (await GetRequest.getContractById(id)).body );
  }
  
}