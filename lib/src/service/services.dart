import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_apps/index.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:polkawallet_sdk/api/apiTx.dart';
import 'package:polkawallet_sdk/service/tx.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:polkawallet_sdk/api/api.dart';

// ignore: avoid_classes_with_only_static_members
class AppServices {

  static int myNumCount = 0;

  static Future noInternetConnection({required BuildContext? context}) async {
    try {
      final Connectivity connectivity = Connectivity();

      final myResult = await connectivity.checkConnectivity();

      connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        if (result == ConnectivityResult.none) {
          // openSnackBar(globalKey, AppString.contentConnection);
          ScaffoldMessenger.of(context!).showSnackBar(
            snackBarBody(AppString.contentConnection, context),
          );
        } else {
          ScaffoldMessenger.of(context!).removeCurrentSnackBar();
          // ignore: deprecated_member_use
          // globalKey.currentState!.removeCurrentSnackBar();
        }
      });

      if (myResult == ConnectivityResult.none) {
        snackBarBody(AppString.contentConnection, context!);
      }
    } catch (e) {
      if (kDebugMode) {
        print("noInternetConnection $e");
      }
    }
  }

  static Future connectivityStatus(BuildContext context) async {
    try {
      final Connectivity connectivity = Connectivity();

      final myResult = await connectivity.checkConnectivity();

      connectivity.onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (result == ConnectivityResult.none) {
          await dialogSuccess(context, const Text(''), const Text(''));
        }
      });

      if (myResult == ConnectivityResult.none) {
        await dialogSuccess(context, const Text(''), const Text(''));
      }
    } catch (e) {
      if (kDebugMode) {
        print("connectivityStatus $e");
      }
    }
  }

  static void openSnackBar(context, String content) {
    ScaffoldMessenger.of(context!).showSnackBar(
      snackBarBody(content, context),
    );
  }

  // ignore: avoid_void_async
  static void closeSnackBar(
      GlobalKey<ScaffoldState> globalKey, String content) async {
    // await globalKey.currentState.showSnackBar(snackBarBody(content, globalKey)).closed.then((value) =>
    //   print("value $value")
    // );
  }

  static SnackBar snackBarBody(String content, BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(days: 365),
      backgroundColor: Colors.red,
      content: Text(content,
          style: const TextStyle(
            color: Colors.white,
          )),
      action: SnackBarAction(
        label: "Close",
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        },
      ),
    );
  }

  // ignore: avoid_void_async
  Future<void> clearStorage() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  // Remove Zero At The Position Of Phone Number
  static String removeZero(String number) {
    return number.replaceFirst("0", "", 0);
  }

  static double getRadienFromDegree(double degree) {
    const double unitRadien = 57.295779513;
    return degree / unitRadien;
  }

  static Timer appLifeCycle(Timer timer) {
    return timer;
  }

  static Map<String, dynamic> emptyMapData() {
    return Map<String, dynamic>.unmodifiable({});
  }

  // ignore: avoid_void_async
  static void timerOutHandler(http.Response res, Function timeCounter) async {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (timer.tick <= 10) {
        timeCounter(timer);
        // ignore: invariant_booleans
      } else if (timer.tick > 10) {
        timer.cancel();
      }
    });
  }

  Future<bool> checkBiometrics(BuildContext context) async {
    bool canCheckBiometrics = false;
    try {
      // Check For Support Device
      bool support = await LocalAuthentication().isDeviceSupported();
      if (support) {
        canCheckBiometrics = await LocalAuthentication().canCheckBiometrics;
      } else {
          await customDialog(
            context, 
            'Opps', 
            "Your device doesn't support finger print",
          );
        // await showDialog(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10.0)),
        //       title: Align(
        //         child: MyText(
        //           text: "Oops",
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       content: Padding(
        //         padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        //         child: Text("Your device doesn't support finger print",
        //             textAlign: TextAlign.center),
        //       ),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () => Navigator.pop(context),
        //           child: const Text('Close'),
        //         ),
        //       ],
        //     );
        //   },
        // );
      }

      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error checkBiometrics $e");
        }
      }
      // canCheckBiometrics = false;
    }

    return canCheckBiometrics;
  }

  static Future<String>? getPrivateKey(String pin, BuildContext context) async {
    String privateKey = '';
    try {
      final encrytKey = await StorageServices().readSecure(DbKey.private);
      privateKey = await Provider.of<ApiProvider>(context, listen: false).decryptPrivateKey(encrytKey!, pin);
    } catch (e) {
      await customDialog(context, 'Opps', 'PIN verification failed');
    }
    return privateKey;
  }

  static List<List<double>> flListToList(List<FlSpot> flList) {
    List<List<double>> tmp = [];
    for (var element in flList) {
      tmp.add(
        List.from([
          element.x,
          element.y
        ])
      );
    }

    return tmp;
  }
  
  static List<FlSpot> jsonToFlList(dynamic flJson) {
    List<FlSpot> tmp = [];
    flJson.forEach((element) {
      tmp.add(
        FlSpot(element[0], element[1])
      );
    });
    return tmp;
  }

  List<SmartContractModel> sortAsset(List<SmartContractModel> lsAsset){
    SmartContractModel tmp = SmartContractModel();
    for (int i = 0; i < lsAsset.length; i++) {
      // if (lsAsset[i].balance!.contains(",")) {
      //   lsAsset[i].balance = lsAsset[i].balance!.replaceAll(",", "");
      // } 

      for (int j = i + 1; j < lsAsset.length; j++) {
        tmp = lsAsset[i];
        if ( (double.parse(lsAsset[j].balance!.replaceAll(",", ""))) > (double.parse(lsAsset[i].balance!.replaceAll(",", ""))) ) {
          lsAsset[i] = lsAsset[j];
          lsAsset[j] = tmp;
        }
      }
    }
    return lsAsset;
  }

}

class Encryptt {
  static String passwordToEncryptKey(String password) {
    String passHex = hex.encode(utf8.encode(password));
    if (passHex.length > 32) {
      return passHex.substring(0, 32);
    }
    return passHex.padRight(32, '0');
  }
}

// class AppUpdate {
  
//   Future<AppUpdateInfo> checkUpdate() async {
//     return await InAppUpdate.checkForUpdate();
//   }

//   Future<void> performImmediateUpdate() async {
//     await InAppUpdate.performImmediateUpdate();
//   }
// }

class SendTrx extends ApiTx{

  final PolkawalletApi apiRoot;
  final ServiceTx service;

  SendTrx(this.apiRoot, this.service) : super(apiRoot, service);
  
  /// Estimate tx fees, [params] will be ignored if we have [rawParam].
  @override
  Future<TxFeeEstimateResult> estimateFees(TxInfoData txInfo, List params, {String? rawParam, String? jsApi}) async {
    final String param = rawParam ?? jsonEncode(params);
    final Map tx = txInfo.toJson();
    final res = await (service.estimateFees(tx, param, jsApi: jsApi));
    return TxFeeEstimateResult.fromJson(res as Map<String, dynamic>);
  }

  @override
  Future<Map> signAndSend(
    TxInfoData txInfo,
    List params,
    String password, {
    Function(String)? onStatusChange,
    String? rawParam,
  }) async {
    final param = rawParam ?? jsonEncode(params);
    final Map tx = txInfo.toJson();
    dynamic res = await (service.signAndSend(
      tx,
      param,
      password,
      onStatusChange ?? (status) {},
    ));
    if (res['error'] != null) {
      throw Exception(res['error']);
    }
    return res;
  }

}