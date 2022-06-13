import 'dart:math';

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

enum SocialMedia {facebook, twitter, telegram}

class AirDropProvider with ChangeNotifier {

  final text = "Claim \$SEL tokens airdrop via airdropv2.selendra.org. follow us on Twitter twitter.com/selendrachain and Telegram t.me/selendrachain. #Selendra #Blockchain #SmartContract #OpenSource https://airdropv2.selendra.org/";

  dynamic urls;

  final String contract = "0xb0DB809A5e28be3981771B5bbD6066E7996845Ca";

  String? _token;

  bool? isRegister;
  
  String _privateKey = '';

  set setPrivateKey(String pk){
    _privateKey = pk;
    notifyListeners();
  }
  String get getPrivateKey => _privateKey;

  set setToken(String tk) {
    _token = tk;
    notifyListeners();
  }
  String get getToken => _token!;

  DeployedContract? _deployedContract;
  ContractProvider? _contractP;
  ApiProvider? _apiProvider;

  AirDropProvider(){
    initContract();
    urls = {
      SocialMedia.twitter: 'https://twitter.com/intent/tweet?text=$text',
      SocialMedia.facebook: 'http://m.facebook.com/sharer.php?t=$text',
      SocialMedia.telegram: 'https://t.me/share/url?text=$text',
    };
  }

  /// Assign contract provider parameter
  void setConProvider(ContractProvider? con, BuildContext? context){
    _contractP = con;
    _apiProvider = Provider.of<ApiProvider>(context!, listen: false);
    notifyListeners();
  }

  Future<DeployedContract> initContract() async {
    try {

      final String abi = await rootBundle.loadString(AppConfig.abiPath+"airdrop.json");
      _deployedContract = DeployedContract(
        ContractAbi.fromJson(abi, "AirdropClaim"),
        EthereumAddress.fromHex(contract)
      );
      
      notifyListeners();
    } catch (e){
      if (ApiProvider().isDebug == true) print("Error initContract $e");
    }

    return _deployedContract!;
  }

  /* --------------------Read Contract-------------------- */
  Future<void> airdropTokenAddress() async {
    try {

      await _contractP!.initBscClient();
      final preFunction = _deployedContract!.function('airdropTokenAddress');
      final res = await _contractP!.bscClient.call(
        contract: _deployedContract!, 
        function: preFunction, 
        params: []
      );

    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error airdropTokenAddress $e");
    }
  }

  Future<String> getTrxFee() async {
    try {

      dynamic res = await _contractP!.bscClient.estimateGas(
        sender: EthereumAddress.fromHex(contract),
        to: EthereumAddress.fromHex(_contractP!.ethAdd),
        value: EtherAmount.inWei(BigInt.from(5 * pow(1, 18
        )))
      );
      res = (res / BigInt.from(pow(10, 9)));
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error getTrxFee $e");
    }
    return '';
  }

  Future<dynamic> signMessage(BuildContext context) async {
    final apiPro = await Provider.of<ApiProvider>(context, listen: false);
    return await apiPro.getSdk.webView!.evalJavascript("settings.signMessage('${Provider.of<ContractProvider>(context, listen: false).ethAdd}')").then((value) async {
      return await claim(context: context, amount: value['value'], expiredDate: value['expiredAt'], v: value['sig']['v'], r: List<int>.from(value['r']), s: List<int>.from(value['s']));
    });
  }

  /* --------------------Write Contract-------------------- */
  Future<String> claim({String? amount, int? expiredDate, String? v, List<int>? r, List<int>? s, @required BuildContext? context}) async {

    try {

      await _contractP!.initBscClient();
      final preFunction = _deployedContract!.function('claim');

      if (_privateKey != ''){

        final credentials = await EthPrivateKey.fromHex(_privateKey);

        final res = await _contractP!.bscClient.sendTransaction(
          credentials,
          Transaction.callContract(
            contract: _deployedContract!,
            function: preFunction,
            // maxGas: 2145000,
            parameters: [
              BigInt.parse(amount!),
              BigInt.from(expiredDate!),
              BigInt.parse(v!),
              Uint8List.fromList(r!),//rHash.hashString(HashType.SHA256,  )),
              Uint8List.fromList(s!)//rHash.hashString(HashType.SHA256, s ))
            ]
          ),
          chainId: null,
          fetchChainIdFromNetworkId: true
        );

        return res;
      }
    }
    catch (e) {
      // "Error airdrop_p.dart $e");

      throw Exception(e);
    }
  
    return '';
  }


  Future<void> signUp() async {
    try {
      await http.post(
        Uri.parse('https://airdropv2-api.selendra.org/auth/register'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: json.encode({
          "email": "${_apiProvider!.accountM.address}@gmail.com",
          "password": '123456',
          "wallet": "${_apiProvider!.accountM.address}"
        })
      ).then((value) async {
        final res = json.decode(value.body);
        if (res['success']){
          await signIn();
        }

      });

    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error signUp $e");
    }
  }

  Future<void> signIn() async {
    // try {
    //   await http.post(
    //     Uri.parse('https://airdropv2-api.selendra.org/auth/login'),
    //     headers: {"Content-Type": "application/json; charset=utf-8"},
    //     body: json.encode({
    //       "email": "${_apiProvider!.accountM.address}@gmail.com",
    //       "password": '123456',
    //     })
    //   ).then((value) async {
    //     final res = json.decode(value.body);
    //     if (res['success'] == false){
    //       await signUp();
    //     } else {
    //       setToken = res['token'];
    //       await StorageServices.storeData(res, DbKey.token);
    //     }
    //   });

    //   // var db = Db(AppConfig.mongoUrl);
    //   // await db.open().then((value) {
    //   //   print("Hello my db openDb $value");
    //   // });
    //   // print("Done connect to mongo");
    // } catch (e) {
    //   print("Error signIn $e");
    // }
  }

  Future<dynamic> encodeRS(BuildContext context, String r, String s) async {
    final apiPro = await Provider.of<ApiProvider>(context, listen: false);
    return await apiPro.getSdk.webView!.evalJavascript("settings.encodeHextoByte('$r', '$s')");
    // .then((value) async {
    //   print("resolve $value");
    //   return await claim(context: context, amount: value['value'], expiredDate: value['expiredAt'], v: value['sig']['v'], r: List<int>.from(value['r']), s: List<int>.from(value['s']));
    // });
  }

  Future<dynamic> signToDb() async {
    try {

      // dynamic res = await StorageServices.fetchData(DbKey.signData);

      // For First Time Sign
      // if (res == null){
        
        // For Airdrop
        // final res2 = await http.post(
        //   Uri.parse('https://airdropv2-api.selendra.org/sign'),
        //   headers: {"Content-Type": "application/json; charset=utf-8", "authorization": "Bearer $getToken"},
        //   body: json.encode({
        //     "wallet": "${_apiProvider!.accountM.address}",
        //   })
        // );

        // For Events Mainnet
        final res2 = await http.post(
          Uri.parse('https://airdrop.selendra.org/api/submit'),
          headers: {"Content-Type": "application/json; charset=utf-8", "authorization": "Bearer $getToken"},
          body: json.encode({
            "wallet": "${_apiProvider!.accountM.address}",
          })
        );

        return await json.decode(res2.body);
        
        // if (res2.statusCode == 200){
        //   // Map<String, dynamic> map = Map<String, dynamic>.from(json.decode(res.body));
        //   // if (map['data']['attempt'] == 1){

        //   //   map.addAll({
        //   //     'first': true
        //   //   });
        //   // }

        //   // First Sign Data
        //   await StorageServices.storeData(json.decode(res2.body), DbKey.signData);
        // }

        // print("Finish storeData");

        // return json.decode(res.body)['data'];
      // } else {
      //   // print("From DB $res");
      //   // res = {'success': true, 'data': {'hash': '0xafbe090b948e4674025adc3522a84ea5577bd7b52902cbcd3aa4d73d4502bed5', 'amount': '5000000000000000000', 'Date': '1641587654318', 'v': '0x1c', 'r': '0x54a875fb2430be202e0081977b22a4e01dd051e45f3499c49623bccf8e947a2d', 's': '0x0b8a5eb191d2213e801586bd1a3bbe2cfbf36f952b7690679092ed04ca640e57', 'attempt': 1, 'user': '61d895665362bce365200d53', '_id': '61d895b65362bce365200d59', '__v': '0'}};
      //   // Check If Time To Re Sign
      //   if ( DateTime.now().millisecondsSinceEpoch > int.parse(res['data']['Date']) && res['data']['attempt'] == 1) {
      //     print("Is time to api");
      //     await StorageServices.removeKey(DbKey.signData);
      //     return await signToDb();

      //   } else {
      //     return res['data'];
      //   }
      // }

      // var db = Db(AppConfig.mongoUrl);
      // await db.open().then((value) {
      //   print("Hello my db openDb $value");
      // });
      // print("Done connect to mongo");
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error signToDb $e");
    }
  }
  
  Future<bool> isClaimOut(Map<String ,dynamic>value, Map<String ,dynamic> byte32, {@required BuildContext? context}) async {
    dynamic res = await claim(context: context, amount: value['amount'], expiredDate: int.parse(value["Date"]), v: value['v'], r: List<int>.from(byte32['rr']), s: List<int>.from(byte32['ss']) );
    if (res != ''){
      return false;
    } else {
      // For wrong password
      return true;
    }
    // try {

    // } catch (e) {
      
    // }
    // return true;
  }

}