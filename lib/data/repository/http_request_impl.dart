import 'dart:convert';

import 'package:bitriel_wallet/data/api/get_api.dart';
import 'package:bitriel_wallet/data/repository/http_request_repo.dart';
import 'package:http/http.dart' as http;

class HttpRequestImpl extends HttpRequestRepo {

  @override
  Future<http.Response> fetchAddrUxtoBTC(String btcAddr) async {
    return await GetRequest.fetchAddrUxtoBTC(btcAddr);
  }

  @override
  Future<List<String>> fetchSelendraEndpoint() async {
    return await GetRequest.getSelendraEndpoint().then((value) {
      return List<String>.from( (json.decode(value.body))['mainnet'] );
    });
  }
}