import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  // Web2 wallet api
  Future<http.Response> registerPhoneNumber(final String? phoneNumber) async {
    print("registerPhoneNumber phoneNumber $phoneNumber");
    body = json.encode({
      "phoneNumber": phoneNumber,
    });

    return await http.post(
      Uri.parse("${dotenv.get("WEB2_URL_API")}/register"),
      headers: _conceteHeader(),
      body: body
    );
  }

  Future<http.Response> registerVerifyOPT(final String phoneNumber, final String opt) async {

    body = json.encode({
      "phoneNumber": phoneNumber,
      "opt" : opt
    });

    print("body $body");

    return await http.post(
      Uri.parse("${dotenv.get("WEB2_URL_API")}/register/verify/otp"),
      headers: _conceteHeader(),
      body: body
    );
  }

  Future<http.Response> registerSetPassword(final String phoneNumber, final String password, final String confirmPassword) async {
    body = json.encode({
      "phoneNumber": phoneNumber,
      "password" : password,
      "confirmPassword": confirmPassword
    });

    return await http.post(
      Uri.parse("${dotenv.get("WEB2_URL_API")}/register/submit/password"),
      headers: _conceteHeader(),
      body: body
    );
  }

  Future<http.Response> loginPhoneNumber(final String phoneNumber) async {
    body = json.encode({
      "phoneNumber": phoneNumber,
    });

    return await http.post(
      Uri.parse("${dotenv.get("WEB2_URL_API")}/login"),
      headers: _conceteHeader(),
      body: body
    );
  }

  Future<http.Response> loginVerifyOPT(final String phoneNumber, final String opt) async {
    print("loginVerifyOPT ${phoneNumber.length} ${opt.length}");
    print("${dotenv.get("WEB2_URL_API")}/login/verify/otp");
    body = json.encode({
        "phoneNumber": "+85511725228",
        "otp": "672789"
    });
    print("body $body");
    print("body.runtimeType ${body.runtimeType}");
    // ({
    //   "phoneNumber": phoneNumber,
    //   "opt" : opt
    // });

    return await http.post(
      Uri.parse("${dotenv.get("WEB2_URL_API")}/login/verify/otp"),
      headers: _conceteHeader(),
      body: body
    );
  }

  /// Http Headerm
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