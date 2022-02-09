import 'dart:math';
// import 'package:flutter_aes_ecb_pkcs5_fork/flutter_aes_ecb_pkcs5_fork.dart';
import 'package:aes_ecb_pkcs5_flutter/aes_ecb_pkcs5_flutter.dart';
import 'package:defichaindart/defichaindart.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
// import 'package:polkawallet_sdk/kabob__sdk.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/utils/index.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/models/lineChart_m.dart';
import 'package:wallet_apps/src/models/smart_contract.m.dart';
// import 'package:polkawallet_plugin_kusama/polkawallet_plugin_kusama.dart';
import 'package:http/http.dart' as http;
// import 'package:bitcoin_flutter/bitcoin_flutter.dart';

class ApiProvider with ChangeNotifier {
  
  WalletSDK _sdk = WalletSDK();

  Keyring _keyring = Keyring();

  Keyring get getKeyring => _keyring;
  WalletSDK get getSdk => _sdk;

  static const int bitcoinDigit = 8;

  num bitcoinSatFmt = pow(10, 8);

  double amount = 0.0008;

  bool _isConnected = false;

  String btcAdd = '';

  ContractProvider? contractProvider;

  AccountM accountM = AccountM();

  String? _jsCode;

  bool isMainnet = true;
  
  int selNativeIndex = 0;
  int selV1Index = 1;
  int selV2Index = 2;
  int kgoIndex = 3;
  int ethIndex = 4;
  int bnbIndex = 5;
  int dotIndex = 6;
  int btcIndex = 7;
  int attIndex = 8;

  SmartContractModel nativeM = SmartContractModel(
    id: 'selendra',
    logo: AppConfig.assetsPath+'SelendraCircle-White.png',
    symbol: 'SEL',
    name: "SELENDRA",
    balance: '0.0',
    org: 'Testnet',
    lineChartModel: LineChartModel()
  );

  bool get isConnected => _isConnected;

  void setAccount(AccountM acc){
    accountM = acc;

    notifyListeners();
  }

  Future<void> initApi({@required BuildContext? context}) async {

    contractProvider = Provider.of<ContractProvider>(context!, listen: false);

    try {

      await rootBundle.loadString('lib/src/js_api/dist/main.js').then((String js) {
        _jsCode = js;
      });
      await _keyring.init([0, isMainnet ? AppConfig.networkList[0].ss58MN! : AppConfig.networkList[0].ss58!]);
      await _sdk.init(_keyring, jsCode: _jsCode);
      // await connectPolNon(context: context);

    } catch (e) {
      print("Error initApi $e");
    }
  }

  Future<NetworkParams?> connectSELNode({@required BuildContext? context}) async {
    print("connectSELNode");
    try {

      final node = NetworkParams();

      node.name = 'Indranet hosted By Selendra';
      node.endpoint = isMainnet ? AppConfig.networkList[0].wsUrlMN : AppConfig.networkList[0].wsUrlTN;
      node.ss58 = isMainnet ? AppConfig.networkList[0].ss58MN : AppConfig.networkList[0].ss58;

      final res = await _sdk.api.connectNode(_keyring, [node]);

      // final res = await _sdk.webView!.evalJavascript("settings.connect(${jsonEncode([node].map((e) => e.endpoint).toList())})");

      if (res != true) await getSelNativeChainDecimal(context: context!);

      notifyListeners();

      return res;
    } catch (e) {
      print("Error connectSELNode $e");
    }
    return null;
  }

  Future<NetworkParams> connectPolNon({@required BuildContext? context}) async {
    print("connectPolNon");
    dynamic res;
    try {

      final node = NetworkParams();
      node.name = 'Polkadot(Live, hosted by PatractLabs)';
      node.endpoint = isMainnet ? AppConfig.networkList[1].wsUrlMN : AppConfig.networkList[1].wsUrlTN;//'wss://westend-rpc.polkadot.io';//'wss://polkadot.elara.patract.io';//AppConfig.networkList[1].wsUrlMN; ;
      node.ss58 = 0;

      // final node = NetworkParams();
      // node.name = 'Polkadot(Live, hosted by PatractLabs)';
      // node.endpoint = 'wss://polkadot.elara.patract.io';
      // node.ss58 = 0;

      res = await _sdk.api.connectNode(_keyring, [node]);

      await getDotChainDecimal(context: context!);

      notifyListeners();
    } catch (e) {
      print("Error connectPolNon $e");
    }

    return res ?? NetworkParams();
  }

  Future<bool> validateBtcAddr(String address) async {
    return Address.validateAddress(address, bitcoin);
  }

  void setBtcAddr(String btcAddress) {
    btcAdd = btcAddress;
    notifyListeners();
  }

  Future<String> calBtcMaxGas() async {
    
    int input = 0;

    final from = await StorageServices.fetchData(DbKey.bech32);

    final txb = TransactionBuilder();
    txb.setVersion(1);
    final res = await getAddressUxto(from);

    if (res.length != 0) {
      for (final i in res) {
        if (i['status']['confirmed'] == true) {
          txb.addInput(i['txid'], int.parse(i['vout'].toString()), null);
          input++;
        }
      }
    }

    final trxSize = calTrxSize(input, 2);

    return trxSize.toString();
  }

  Future<int> sendTxBtc(BuildContext context, String from, String to, double amount, String wif) async {
    int totalSatoshi = 0;
    int input = 0;
    final alice = ECPair.fromWIF(wif);

    final p2wpkh = new P2WPKH(data: new PaymentData(pubkey: alice.publicKey)).data;

    final txb = TransactionBuilder();
    
    txb.setVersion(1);

    final res = await getAddressUxto(from);

    if (res.length != 0) {
      for (final i in res) {
        if (i['status']['confirmed'] == true) {
          txb.addInput(i['txid'], int.parse(i['vout'].toString()), null, p2wpkh!.output);
          totalSatoshi += int.parse(i['value'].toString());
          input++;
        }
      }
    }

    final totaltoSend = (amount * bitcoinSatFmt).floor();

    if (totalSatoshi < totaltoSend) {
      await customDialog(context, 'You do not have enough in your wallet to send that much.', 'Opps');
    }

    final fee = calTrxSize(input, 2) * 88;

    if (fee > (amount * bitcoinSatFmt).floor()) {
      await customDialog(
        context,
        "BitCoin amount must be larger than the fee. (Ideally it should be MUCH larger)",
        'Opps'
      );
    }

    final change = totalSatoshi - ((amount * bitcoinSatFmt).floor() + fee);

    txb.addOutput(to, totaltoSend);
    txb.addOutput(from, change);

    for (int i = 0; i < input; i++) {
      txb.sign(vin: i, keyPair: alice);
    }

    final response = await pushTx(txb.build().toHex());

    return response;
  }

  Future<void> customDialog(BuildContext context, String text1, String text2) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Align(
            child: Text(text1),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(text2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<int> pushTx(String hex) async {
    final res = await http.post(Uri.parse('https://api.smartbit.com.au/v1/blockchain/pushtx'),
      //headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: json.encode({"hex": hex}));
    return res.statusCode;
  }

  int calTrxSize(int nInput, int nOutput) {
    return nInput * 180 + nOutput * 34 + 10 + nInput;
  }

  Future<dynamic> getAddressUxto(String address) async {
    try {

      final res = await http.get(Uri.parse('https://blockstream.info/api/address/$address/utxo'));

      return jsonDecode(res.body);
    } catch (e){
      print("Err getAddressUxto $e");
    }
  }

  Future<void> getBtcBalance({@required BuildContext? context}) async {
    final contract = await Provider.of<ContractProvider>(context!, listen: false);
    print("getBtcBalance ${contract.listContract[btcIndex].address!}");
    try {
      int totalSatoshi = 0;
      final res = await getAddressUxto(contract.listContract[btcIndex].address!);

      if (res.length == 0) {
        contract.listContract[btcIndex].balance = '0';
      } else {
        for (final i in res) {
          if (i['status']['confirmed'] == true) {
            totalSatoshi += int.parse(i['value'].toString());
          }
        }

        contract.listContract[btcIndex].balance = (totalSatoshi / bitcoinSatFmt).toString();
      }

      contract.listContract[btcIndex].lineChartModel = LineChartModel().prepareGraphChart(contract.listContract[btcIndex]);

      notifyListeners();
    } catch (e) {
      print("Err getBtcBalance $e");
    }
  }

  void isBtcAvailable(String? contain, {@required BuildContext? context}) {
    final con = Provider.of<ContractProvider>(context!, listen: false);
    if (contain != null) {
      con.listContract[btcIndex].isContain = true;
      notifyListeners();
    }
  }

  Future<void> setBtcMarket(Market marketData, List<List<double>> lineChartData, String currentPrice, String priceChange24h, {@required BuildContext? context}) async {

    // btc.marketData = marketData;
    // btc.marketPrice = currentPrice;
    // btc.change24h = priceChange24h;
    // btc.lineChartList = lineChartData ?? [];

    final contract = await Provider.of<ContractProvider>(context!, listen: false);
    contract.listContract[btcIndex].marketData = marketData;
    contract.listContract[btcIndex].marketPrice = currentPrice;
    contract.listContract[btcIndex].change24h = priceChange24h;
    contract.listContract[btcIndex].lineChartList = lineChartData;
    notifyListeners();
  }

  // void dotIsNotContain() {
  //   dot.isContain = false;
  //   notifyListeners();
  // }
  Future<bool>? validateMnemonic(String mnemonic) async {

    dynamic res;
    try {

      res = await _sdk.api.service.webView!.evalJavascript('keyring.validateMnemonic("$mnemonic")');
      return res;
    } catch (e) {
      print("Error validateMnemonic $e");
    }
    return res;
  }
  
  Future<bool> validateEther(String address) async {
    try {

      dynamic res = await _sdk.api.service.webView!.evalJavascript('wallets.validateEtherAddr("$address")');
      return res;
    } catch (e) {
      print("Error validateEther $e");
    }
    return false;
  }

  Future<String> getPrivateKey(String mnemonic) async {
    try {

      final res = await _sdk.api.service.webView!.evalJavascript("wallets.getPrivateKey('$mnemonic')");//ApiProvider._sdk.api.getPrivateKey(mnemonic);
      return res;
    } catch (e) {
      print("Error getPrivateKey $e");
    }
    return '';
  }

  Future<bool> validateAddress(String address) async {
    try {

      final res = await _sdk.api.service.webView!.evalJavascript("keyring.validateAddress('$address')");
      return res;
    } catch (e) {
      print("Error validateAddress $e");
    }
    return false;
  }

  // Connect SEL Chain
  Future<void> getSelNativeChainDecimal({@required BuildContext? context}) async {
    print("getSelNativeChainDecimal");
    try {
      
      final contract = Provider.of<ContractProvider>(context!, listen: false);

      final res = await _sdk.api.service.webView!.evalJavascript('settings.getChainDecimal(api)');
      contract.listContract[0].chainDecimal = res[0].toString();
      _keyring.allAccounts.forEach((value){
        print("value.name ${value.name}");
        print("value.address ${value.address}");
      });
      await subSELNativeBalance(context: context);

      notifyListeners();
    } catch (e) {
      print("Error getChainDecimal $e");
    }
  }

  Future<void> subSELNativeBalance({@required BuildContext? context}) async {
    try {

      final contract = Provider.of<ContractProvider>(context!, listen: false);
      await _sdk.webView!.evalJavascript("account.getBalance(api, '${contract.listContract[0].address}', 'Balance')").then((value) {
        contract.listContract[0].balance = Fmt.balance(
          value['freeBalance'].toString(),
          int.parse(contract.listContract[0].chainDecimal!),
        );
      });
      // await _sdk.api.account.subscribeBalance(contract.listContract[0].address, (res) {
      //   print("Res $res");
      //   contract.listContract[0].balance = Fmt.balance(
      //     res.freeBalance.toString(),
      //     int.parse(contract.listContract[0].chainDecimal!),
      //   );

      //   notifyListeners();
      // });
      Provider.of<ContractProvider>(context, listen: false).setSELNativeAddr(contract.listContract[0].address!);
    } catch (e) {
      print("Error subscribeSELBalance $e");
    }
  }

  void isDotContain({@required BuildContext? context}) {
    final con = Provider.of<ContractProvider>(context!, listen: false);
    con.listContract[dotIndex].isContain = true;
    notifyListeners();
  }

  Future<void> setDotMarket(Market marketData, List<List<double>> lineChartData, String currentPrice, String priceChange24h, {@required BuildContext? context}) async {

    final contract = await Provider.of<ContractProvider>(context!, listen: false);
    contract.listContract[dotIndex].marketData = marketData;
    contract.listContract[dotIndex].marketPrice = currentPrice;
    contract.listContract[dotIndex].change24h = priceChange24h;
    contract.listContract[dotIndex].lineChartList = lineChartData;

    notifyListeners();
  }

  Future<void> getDotChainDecimal({@required BuildContext? context}) async {
    try {
      final contract = await Provider.of<ContractProvider>(context!, listen: false);
      final res = await _sdk.api.service.webView!.evalJavascript('settings.getChainDecimal(api)');
      contract.setDotAddr(_keyring.allAccounts[0].address!, res[0].toString());

      await subscribeDotBalance(context: context);

      notifyListeners();
    } catch (e) {
      print("Err getDotChainDecimal $e");
    }
  }

  Future<void> subscribeDotBalance({@required BuildContext? context}) async {
    print("subscribeDotBalance");
    print("_keyring.current.address ${_keyring.current.address}");
    try {

      final contract = await Provider.of<ContractProvider>(context!, listen: false);
      print(contract.listContract[dotIndex].address);
      print(contract.listContract[dotIndex].chainDecimal);
      // final msgChannel = 'NBalance';
      // final code = 'account.getBalance(api, "${_keyring.current.address}", "$msgChannel")';

      await _sdk.api.account.subscribeBalance(_keyring.current.address, (res){

        print("res $res");
        print("contract.listContract[dotIndex].chainDecimal! ${contract.listContract[dotIndex].chainDecimal!}");

        contract.listContract[dotIndex].balance = Fmt.balance(
          res.freeBalance.toString(),
          int.parse(contract.listContract[dotIndex].chainDecimal!),
        );

        contract.listContract[dotIndex].lineChartModel = LineChartModel().prepareGraphChart(contract.listContract[dotIndex]);
        notifyListeners();
      });
      
    } catch (e) {
      print("Error subscribeDotBalance $e");
    }
  }

  Future<void> getAddressIcon() async {
    try {

      final res = await _sdk.api.account.getPubKeyIcons(
        [_keyring.keyPairs[0].pubKey!],
      );

      accountM.addressIcon = res.toString();
      notifyListeners();
    } catch (e) {
      print("Error get icon from address $e");
    }
  }

  Future<void> getCurrentAccount() async {
    accountM.address = await _sdk.webView!.evalJavascript('keyring.getSELAddr()');
    accountM.name = _keyring.current.name;
    contractProvider!.setSELNativeAddr(accountM.address!);

    // contractProvider!.setSELNativeAddr(accountM.address!);
    
    notifyListeners();
  }

  Future<List> getCheckInList(String attender) async {
    final res = await _sdk.api.service.webView!.evalJavascript('settings.getCheckInList(aContract,"$attender")');
    return res;
  }

  Future<List> getCheckOutList(String attender) async {
    final res = await _sdk.api.service.webView!.evalJavascript('settings.getCheckOutList(aContract,"$attender")');
    return res;
  }

  Future<String> decryptPrivateKey(String privateKey, String password) async {
    final String key = Encrypt.passwordToEncryptKey(password);
    final String decryted = await FlutterAesEcbPkcs5.decryptString(privateKey, key);
    return decryted;
  }

  Future<String> encryptPrivateKey(String privateKey, String password) async {
    try {

      final String key = Encrypt.passwordToEncryptKey(password);
      final String encryted = await FlutterAesEcbPkcs5.encryptString(privateKey, key);
      return encryted;
    } catch (e) {
      print("Error encryptPrivateKey $e");
    }
    return '';
  }

  Future<Map> signAndSendDot(Map txInfo, String params, password, Function(String) onStatusChange) async {
    final msgId = "onStatusChange${_sdk.webView!.getEvalJavascriptUID()}";
    _sdk.webView!.addMsgHandler(msgId, onStatusChange);
    final code = '_keyring.sendTx(apiNon, ${jsonEncode(txInfo)}, $params, "$password", "$msgId")';

    final Map res = await _sdk.webView!.evalJavascript(code);
    _sdk.webView!.removeMsgHandler(msgId);

    return res;
  }

  /// Generate a set of new mnemonic.
  Future<String> generateMnemonic() async {
    final Map<String, dynamic> acc = await _sdk.webView!.evalJavascript('keyring.gen()');
    return acc['mnemonic'];
  }

  // void resetNativeObj({BuildContext context}) {
  //   final contract = Provider.of<ContractPro>(context);
  //   accountM = AccountM();
  //   nativeM = SmartContractModel(
  //     id: 'selendra',
  //     logo: 'assets/SelendraCircle-White.png',
  //     symbol: 'SEL',
  //     org: 'Testnet',
  //   );
  //   dot = SmartContractModel();

  //   notifyListeners();
  // }
}
