import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/backend.dart';

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
      headers: conceteHeader(),
      body: body
    );
  }

  // Web2 wallet api
  Future<http.Response> registerPhoneNumber(final String? phoneNumber) async {
    body = json.encode({
      "phoneNumber": phoneNumber,
    });

    return await http.post(
      Uri.parse("${dotenv.get("WEB2_URL_API")}/register"),
      headers: conceteHeader(),
      body: body
    );
  }

  Future<http.Response> registerVerifyOPT(final String phoneNumber, final String opt) async {

    body = json.encode({
      "phoneNumber": phoneNumber,
      "opt" : opt
    });

    return await http.post(
      Uri.parse("${dotenv.get("WEB2_URL_API")}/register/verify/otp"),
      headers: conceteHeader(),
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
      headers: conceteHeader(),
      body: body
    );
  }

  Future<http.Response> loginPhoneNumber(final String phoneNumber) async {
    body = json.encode({
      "phoneNumber": phoneNumber,
    });

    return await http.post(
      Uri.parse("${dotenv.get("WEB2_URL_API")}/login"),
      headers: conceteHeader(),
      body: body
    );
  }

  Future<http.Response> loginVerifyOPT(final String phoneNumber, final String opt) async {
    body = json.encode({
        "phoneNumber": "+85511725228",
        "otp": "672789"
    });
    
    // ({
    //   "phoneNumber": phoneNumber,
    //   "opt" : opt
    // });

    return await http.post(
      Uri.parse("${dotenv.get("WEB2_URL_API")}/login/verify/otp"),
      headers: conceteHeader(),
      body: body
    );
  }

  /* MetaDoers World */

  Future<http.Response> getTicketsByEventId(String id) async {

    body = json.encode({
      "eventId": id
    });


    // String js = await rootBundle.loadString('assets/json/list_year.json');
    // print("js $js");
    // // print((await json.decode(js)));
    // return http.Response(js, 200);

    return await http.post(
      Uri.parse("${dotenv.get('DOERS_API')}ticket-types"),
      body: body,
      headers: conceteHeader()
    );
  }

  Future<http.Response> getTicketTypeGroupedByDate(String tkTypeId, String evntId) async {
    
    body = json.encode({
      "ticketTypeId": tkTypeId,
      "eventId": evntId
    });

    // String js = await rootBundle.loadString('assets/json/by-ticket-type-grouped-by-date.json');
    // print(js);
    // return http.Response(js, 200);
    return await http.post(
      // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
      Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type-grouped-by-date"),
      body: body,
      headers: conceteHeader()
    );
  }

  Future<http.Response> bookTicket(String body) async {

    return await http.post(
      // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
      Uri.parse("${dotenv.get('DOERS_API')}payments/stripe/pay"),
      body: body,
      headers: conceteHeader()
    );
  }
  
}

class EventCrewRestApi{

  Future<http.Response> bookTicket(String body) async {

    return await http.post(
      // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
      Uri.parse("${dotenv.get('DOERS_API')}payments/stripe/pay"),
      body: body,
      headers: conceteHeader()
    );
  }  
}