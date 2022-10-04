import 'package:http/http.dart' as http;
import 'package:wallet_apps/index.dart';

/// Scan QR Get SEL 
class PostRequest {

  http.Response? res;
  String? body;
  PackageInfo? _info;

  Future<http.Response> requestReward(final String url, final String address) async {
    _info = await PackageInfo.fromPlatform();
    body = json.encode({
      "address": address,
      "bitriel_Id": _info!.packageName
    });

    return await http.post(
      Uri.parse("$url/api/claim"),
      headers: _conceteHeader(),
      body: body
    );
  }

  /// Http Header
  Map<String, String> _conceteHeader({String? key, String? value}) { /* Concete More Content Of Header */
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
}