import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:wallet_apps/index.dart';

const post_headers = {"Content-type": "application/json", "Accept": "*/*"};

class WalletApi {
  static const String _endpoint = 'https://api.polkawallet.io';
  static const String _configEndpoint = 'https://acala.subdao.com';

  static const String _jsCodeStorageKey = 'js_service_';
  static const String _jsCodeStorageVersionKey = 'js_service_version_';

  static Response? res;

  static String getSnEndpoint(String relayChainName) {
    return 'https://$relayChainName.api.subscan.io/api/scan';
  }

  static Future<Map> getXcmEnabledConfig() async {
    try {
      res =
          await get(Uri.parse('$_configEndpoint/wallet/nativeTokenXCM.json'));
      
        return jsonDecode(utf8.decode(res!.bodyBytes)) as Map;
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<Map> getDisabledCalls() async {
    try {
      res =
          await get(Uri.parse('$_configEndpoint/wallet/disabledCalls.json'));
      
        return jsonDecode(utf8.decode(res!.bodyBytes)) as Map;
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
    
  }

  static Future<Map> getLatestVersion() async {
    try {
      res = await get(Uri.parse('$_configEndpoint/wallet/versions.json'));
      
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
    }
    return jsonDecode(utf8.decode(res!.bodyBytes)) as Map;
  }

  static Future<Map> fetchPolkadotJSVersion() async {
    try {
      res =
          await get(Uri.parse('$_configEndpoint/wallet/jsCodeVersions.json'));
      
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      // return null;
    }

      return Map.of(jsonDecode(res!.body));
  }

  static Future<String> fetchPolkadotJSCode(String networkName) async {
    try {
      res =
          await get(Uri.parse('$_configEndpoint/wallet/js/$networkName.js'));
      
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      // return null;
    }

      return utf8.decode(res!.bodyBytes);
  }

  static int getPolkadotJSVersion(
    GetStorage jsStorage,
    String networkName,
    int appJSVersion,
  ) {
    final String? version = jsStorage.read('$_jsCodeStorageVersionKey$networkName');
    if (version != null) {
      final updatedVersion = int.parse(version);
      return updatedVersion > appJSVersion ? updatedVersion : appJSVersion;
    }
    // default version
    return appJSVersion;
  }

  static String getPolkadotJSCode(
    GetStorage jsStorage,
    String networkName,
  ) {
    final String jsCode = jsStorage.read('$_jsCodeStorageKey$networkName');
    return jsCode;
  }

  static void setPolkadotJSCode(
    GetStorage jsStorage,
    String networkName,
    String code,
    int version,
  ) {
    jsStorage.write('$_jsCodeStorageKey$networkName', code);
    jsStorage.write(
        '$_jsCodeStorageVersionKey$networkName', version.toString());
  }

  static Future<List> getAnnouncements() async {
    try {
      res = await get(Uri.parse('$_endpoint/announce.json'));
      // if (res == null) {
      //   return null;
      // } else {
      // }
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      // return null;
    }
      return jsonDecode(utf8.decode(res!.bodyBytes));
  }

  static Future<Map> getTokenPriceFromSubScan(String network) async {
    final url =
        'https://${network.toLowerCase()}.api.subscan.io/api/scan/token';
    try {
      res = await get(Uri.parse(url));
      
      return jsonDecode(utf8.decode(res!.bodyBytes));
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<Map> getTokenPrice(String token) async {
    final url = '$_endpoint/price/price/latest?token=$token';
    try {
      res = await get(Uri.parse(url));
      
      return jsonDecode(utf8.decode(res!.bodyBytes));
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<Map> getAdBannerStatus() async {
    try {
      res = await get(Uri.parse('$_endpoint/crowdloan/health'));
      // if (res == null) {
      //   return null;
      // } else {
      // }

        return jsonDecode(utf8.decode(res!.bodyBytes));
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<Map> getKarCrowdLoanStatement(String endpoint) async {
    try {
      res = await get(Uri.parse('https://$endpoint/statement'));
      // if (res == null) {
      //   return null;
      // } else {
      // }

      return jsonDecode(utf8.decode(res!.bodyBytes));
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<Map> getKarCrowdLoanPromotion(
      String endpoint, int blockNumber) async {
    try {
      res = await get(
          Uri.parse('https://$endpoint/promotion?blockNumber=$blockNumber'));
      // if (res == null) {
      //   return null;
      // } else {
      // }

      return jsonDecode(utf8.decode(res!.bodyBytes));
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<List> getKarCrowdLoanHistory(
      String address, String endpoint) async {
    try {
      res = await get(Uri.parse('https://$endpoint/contributions/$address'));
      // if (res == null) {
      //   return null;
      // } else {
      // }

      return jsonDecode(utf8.decode(res!.bodyBytes));
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return [];
    }
  }

  static Future<Map> verifyKarReferralCode(String code, String endpoint) async {
    try {
      res = await get(Uri.parse('https://$endpoint/referral/$code'));
      // if (res == null) {
      //   return null;
      // } else {
      // }

        return jsonDecode(utf8.decode(res!.bodyBytes));
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<Map> checkKarRewardValid(
      String address, String endpoint) async {
    try {
      res =
          await get(Uri.parse('https://$endpoint/promotion/karura/$address'));
      // if (res == null) {
      //   return null;
      // } else {
      // }
        return jsonDecode(utf8.decode(res!.bodyBytes));
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<Map> postKarCrowdLoan(
      String address,
      BigInt amount,
      String email,
      bool receiveEmail,
      String referral,
      String signature,
      String endpoint,
      {bool isProxy = false}) async {
    final headers = {
      "Content-type": "application/json",
      "Accept": "*/*",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoicG9sa2F3YWxsZXQiLCJpYXQiOjE2MzI5MDk1MTd9.iDMOCyRGAttGbgDeD14XLHlAo12VVTKRXdoET3urdZU"
    };
    final Map body = {
      "address": address,
      "amount": amount.toString(),
      "signature": signature,
    };
    if (email.isNotEmpty) {
      body.addAll({"email": email, "receiveEmail": receiveEmail});
    }
    if (referral.isNotEmpty) {
      body.addAll({"referral": referral});
    }
    try {
      res = await post(
          Uri.parse('https://$endpoint/${isProxy ? 'transfer' : 'contribute'}'),
          headers: headers,
          body: jsonEncode(body));
      // if (res == null) {
      //   return null;
      // } else {
      // }
        return jsonDecode(utf8.decode(res!.bodyBytes));
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<Map> getPluginsConfig() async {
    try {
      res =
          await get(Uri.parse('$_configEndpoint/wallet/plugins.json'));
      // if (res == null) {
      //   return null;
      // } else {
      // }
        return jsonDecode(res!.body) as Map;
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<Map> getKarModulesConfig() async {
    try {
      res = await get(Uri.parse('$_configEndpoint/config/modules.json'));
      // if (res == null) {
      //   return null;
      // } else {
      // }
        return jsonDecode(res!.body) as Map;
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<Map> getKSMCrowdLoansConfig() async {
    try {
      res = await get(Uri.parse('$_configEndpoint/wallet/paras.json'));
      // if (res == null) {
      //   return null;
      // } else {
      // }
        return jsonDecode(res!.body) as Map;
    } catch (err) {
      if (ApiProvider().isDebug == true) print(err);
      return {};
    }
  }

  static Future<Map> fetchBlocksFromSn(String relayChainName, {int count = 1}) async {
    final url = '${getSnEndpoint(relayChainName)}/blocks';
    final body = jsonEncode({
      "page": 0,
      "row": count,
    });
    final Response res = await post(Uri.parse(url), headers: post_headers, body: body);
    if (res.body != null) {
      final obj = await compute(jsonDecode, res.body);
      return obj['data'];
    }
    return {};
  }
}
