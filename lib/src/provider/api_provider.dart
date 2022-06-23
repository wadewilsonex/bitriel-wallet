import 'dart:math';
import 'package:aes_ecb_pkcs5_flutter/aes_ecb_pkcs5_flutter.dart';
import 'package:defichaindart/defichaindart.dart';
// import 'package:defichaindart/defichaindart.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
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
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:polkawallet_sdk/utils/localStorage.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/service/apiKeyring.dart';
import 'package:bip39/bip39.dart' as bip39;
// import 'package:bitcoin_flutter/bitcoin_flutter.dart';

class ApiProvider with ChangeNotifier {
  
  WalletSDK _sdk = WalletSDK();
  Keyring _keyring = Keyring();
  MyApiKeyring? _apiKeyring;

  KeyringStorage _keyringStorage = KeyringStorage();

  Keyring get getKeyring => _keyring;
  WalletSDK get getSdk => _sdk;
  MyApiKeyring get apiKeyring => _apiKeyring!;

  static const int bitcoinDigit = 8;

  num bitcoinSatFmt = pow(10, 8);

  double amount = 0.0008;

  bool _isConnected = false;

  String btcAdd = '';

  ContractProvider? contractProvider;

  AccountM accountM = AccountM();

  String? _jsCode;

  bool isMainnet = false;
  bool isDebug = true;
  
  int selNativeIndex = 0;
  int selV1Index = 1;
  int selV2Index = 2;
  int kgoIndex = 3;
  int ethIndex = 4;
  int bnbIndex = 5;
  int dotIndex = 6;
  int btcIndex = 7;
  int attIndex = 8;

  String? funcName;

  bool get isConnected => _isConnected;

  void setAccount(AccountM acc){
    accountM = acc;

    notifyListeners();
  }

  Future<void> initApi({@required BuildContext? context}) async {
    
    funcName = 'account';
    contractProvider = Provider.of<ContractProvider>(context!, listen: false);
    try {

      await rootBundle.loadString('lib/src/js_api/dist/main.js').then((String js) {
        _jsCode = js;
      });
      print("finish load json");

      // Setup ss58Format base on Network
      // await _sdk.webView!.evalJavascript("account.setupss58Format('$isMainnet')");

      await _keyring.init([0, isMainnet ? AppConfig.networkList[0].ss58MN! : AppConfig.networkList[0].ss58!]);
      await _sdk.init(_keyring, jsCode: _jsCode);

      _apiKeyring = MyApiKeyring(_sdk.api, _sdk.api.keyring.service!);
      notifyListeners();

    } catch (e) {
      if (ApiProvider().isDebug) print("Error initApi $e");
    }
  }

  Future<NetworkParams> connectPolNon({@required BuildContext? context}) async {
    print("connectPolNon");
    dynamic res;
    try {

      NetworkParams polNode = NetworkParams();
      // NetworkParams selNode = NetworkParams();
      polNode.name = 'Polkadot(Live, hosted by PatractLabs)';
      polNode.endpoint = isMainnet ? AppConfig.networkList[1].wsUrlMN : AppConfig.networkList[1].wsUrlTN;//'wss://westend-rpc.polkadot.io';//'wss://polkadot.elara.patract.io';//AppConfig.networkList[1].wsUrlMN; ;
      polNode.ss58 = 0;

      // selNode.name = 'Indranet hosted By Selendra';
      // selNode.endpoint = isMainnet ? AppConfig.networkList[0].wsUrlMN : AppConfig.networkList[0].wsUrlTN;
      // selNode.ss58 = isMainnet ? AppConfig.networkList[0].ss58MN : AppConfig.networkList[0].ss58;

      // final node = NetworkParams();
      // node.name = 'Polkadot(Live, hosted by PatractLabs)';
      // node.endpoint = 'wss://polkadot.elara.patract.io';
      // node.ss58 = 0;

      await _sdk.api.connectNode(_keyring, [polNode]).then((value) async {
        res = value;
        await getDotChainDecimal(context: context);
      });

      notifyListeners();
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error connectPolNon $e");
    }

    return res ?? NetworkParams();
  }

  // Future<bool> validateBtcAddr(String address) async {
  //   return Address.validateAddress(address, bitcoin);
  // }

  void setBtcAddr(String btcAddress) {
    btcAdd = btcAddress;
    notifyListeners();
  }

  Future<void> queryBtcData(BuildContext context, String _seeds, String _passCode) async {

    final contractPro = Provider.of<ContractProvider>(context, listen: false);
    
    try {
      final seed = bip39.mnemonicToSeed(_seeds);
      final hdWallet = HDWallet.fromSeed(seed);
      
      contractPro.listContract[btcIndex].address = hdWallet.address!;
      
      final keyPair = ECPair.fromWIF(hdWallet.wif!);

      final bech32Address = new P2WPKH(data: new PaymentData(pubkey: keyPair.publicKey), network: bitcoin).data!.address;
      await StorageServices.storeData(bech32Address, DbKey.bech32);
      await StorageServices.storeData(hdWallet.address, DbKey.hdWallet);

      final res = await encryptPrivateKey(hdWallet.wif!, _passCode);

      await StorageServices().writeSecure(DbKey.btcwif, res);

      // Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain', context: context);

      // Provider.of<ApiProvider>(context, listen: false).setBtcAddr(bech32Address!);
      // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
      // await Provider.of<ApiProvider>(context, listen: false).getBtcBalance(hdWallet.address!, context: context);

    } catch (e) {
      await customDialog(context, 'Oops', e.toString());
    }
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
      if (ApiProvider().isDebug == true) print("Err getAddressUxto $e");
    }
  }

  Future<void> totalBalance({@required BuildContext? context}) async {
    final contract = await Provider.of<ContractProvider>(context!, listen: false);
    
    double total = 0.0;

    var balance_list = [];
    
    contract.sortListContract.forEach((element) {
      if(element.marketPrice!.isNotEmpty){
        total = double.parse(element.balance!.replaceAll(",", "")) * double.parse(element.marketPrice!);
        balance_list.add(total);
      }
    });

    print("balance_list: ${balance_list}");
    print("balance_list length: ${balance_list.length}");
    

    total = balance_list.reduce((a, b) => a + b);;


    contract.totalAmount = total;
  
    print("total: ${contract.totalAmount}");
  }

  Future<void> getBtcBalance({@required BuildContext? context}) async {
    final contract = await Provider.of<ContractProvider>(context!, listen: false);
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
      if (ApiProvider().isDebug == true) print("Err getBtcBalance $e");
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
      if (ApiProvider().isDebug == true) print("Error validateMnemonic $e");
    }
    return res;
  }
  
  Future<bool> validateEther(String address) async {
    try {

      dynamic res = await _sdk.api.service.webView!.evalJavascript('wallets.validateEtherAddr("$address")');
      return res;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error validateEther $e");
    }
    return false;
  }

  Future<String> getPrivateKey(String mnemonic) async {
    try {

      final res = await _sdk.api.service.webView!.evalJavascript("wallets.getPrivateKey('$mnemonic')");//ApiProvider._sdk.api.getPrivateKey(mnemonic);
      return res;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error getPrivateKey $e");
    }
    return '';
  }

  Future<bool> validateAddress(String address) async {
    try {

      final res = await _sdk.api.service.webView!.evalJavascript("keyring.validateAddress('$address')");
      return res;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error validateAddress $e");
    }
    return false;
  }

  Future<NetworkParams?> connectSELNode({@required BuildContext? context, String? funcName = 'keyring'}) async {
    print("connectSELNode");
    try {

      NetworkParams node = NetworkParams();
      NetworkParams? res = NetworkParams();

      node.name = 'Indranet hosted By Selendra';
      node.endpoint = isMainnet ? AppConfig.networkList[0].wsUrlMN : AppConfig.networkList[0].wsUrlTN;
      node.ss58 = isMainnet ? AppConfig.networkList[0].ss58MN : AppConfig.networkList[0].ss58;

      await _sdk.api.connectNode(_keyring, [node]).then((value) async {
        res = value;
        if (getKeyring.keyPairs.isNotEmpty) await getSelNativeChainDecimal(context: context, funcName: funcName);
      });

      // final res = await _sdk.webView!.evalJavascript("settings.connect(${jsonEncode([node].map((e) => e.endpoint).toList())})");

      // if (res != null) 

      return res;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error connectSELNode $e");
    }
    return null;
  }

  /// Connect SEL Chain
  /// 
  /// Inside This Chain Decimal Also Call Get Balance
  Future<void> getSelNativeChainDecimal({@required BuildContext? context, String? funcName = 'keyring'}) async {
    print("getSelNativeChainDecimal");
    try {
      dynamic res;
      
      ContractProvider contract = Provider.of<ContractProvider>(context!, listen: false);
      
      await querySELAddress().then((value) async {
        await _sdk.api.service.webView!.evalJavascript('settings.getChainDecimal(api)').then((value) async {
          
          res = value;
          contract.listContract[selNativeIndex].chainDecimal = res[0].toString();
          print("contract.listContract[selNativeIndex].chainDecimal ${contract.listContract[selNativeIndex].chainDecimal}");
          await subSELNativeBalance(context: context);

          notifyListeners();
        });
      });
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error getChainDecimal $e");
    }
  }

  Future<void> querySELAddress() async {
    
    // Get SEL native Address From Account 
    await _sdk.webView!.evalJavascript('account.getSELAddr()').then((value) async {
      print("$funcName.getSELAddr() $value");
      if (value != null){
        contractProvider!.listContract[selNativeIndex].address = value;
      } else {
        await _sdk.webView!.evalJavascript('keyring.getSELAddr()').then((value) async {
          print("keyring.getSELAddr() $value");
          contractProvider!.listContract[selNativeIndex].address = value;
        });
      }
    });
  }

  Future<void> subSELNativeBalance({@required BuildContext? context}) async {
    print("subSELNativeBalance");
    try {

      final contract = Provider.of<ContractProvider>(context!, listen: false);
      Provider.of<ContractProvider>(context, listen: false).setSELNativeAddr(contract.listContract[selNativeIndex].address ?? '');
      // print("contract.listContract[selNativeIndex].address! ${contract.listContract[selNativeIndex].address!}");
      await _sdk.webView!.evalJavascript("account.getBalance(api, '${contract.listContract[selNativeIndex].address}', 'Balance')").then((value) async {
        contract.listContract[selNativeIndex].balance = Fmt.balance(
          value['freeBalance'].toString(),
          int.parse(contract.listContract[selNativeIndex].chainDecimal!),
        );
        await contract.sortAsset();
      });
      // await _sdk.api.account.subscribeBalance(contract.listContract[selNativeIndex].address, (res) async {
      //   print("finish subscribeBalance ${res.freeBalance}");
      //   contract.listContract[selNativeIndex].balance = Fmt.balance(
      //     res.freeBalance.toString(),
      //     int.parse(contract.listContract[selNativeIndex].chainDecimal!),
      //   );
      //   print("my balance ${contract.listContract[selNativeIndex].balance}");
      //   await contract.sortAsset();
      // });

    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error subscribeSELBalance $e");
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
      dynamic res;
      final contract = await Provider.of<ContractProvider>(context!, listen: false);
      await _sdk.api.service.webView!.evalJavascript('settings.getChainDecimal(api)').then((value) async {
        res = value;
        contract.setDotAddr(_keyring.allAccounts[0].address!, res[0].toString());
        await subscribeDotBalance(context: context);
      });
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err getDotChainDecimal $e");
    }
  }

  Future<void> subscribeDotBalance({@required BuildContext? context}) async {
    try {

      final contract = await Provider.of<ContractProvider>(context!, listen: false);
      // final msgChannel = 'NBalance';
      // final code = 'account.getBalance(api, "${_keyring.current.address}", "$msgChannel")';
      await _sdk.webView!.evalJavascript("account.getBalance(api, '${contract.listContract[dotIndex].address}', 'Balance')").then((value) {//_sdk.api.account.subscribeBalance(contract.listContract[dotIndex].address, (res) async {
        
        contract.listContract[dotIndex].balance = Fmt.balance(
          value['freeBalance'].toString() == "0" ? "0.0" : value['freeBalance'].toString(),
          int.parse(contract.listContract[dotIndex].chainDecimal!),
        );

        contract.listContract[dotIndex].lineChartModel = LineChartModel().prepareGraphChart(contract.listContract[dotIndex]);

      });

      // await connectSELNode(context: context);
      
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error subscribeDotBalance $e");
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
      if (ApiProvider().isDebug == true) print("Error get icon from address $e");
    }
  }

  Future<void> getCurrentAccount({required BuildContext? context, String funcName = 'account'}) async {
    try {

      accountM.address = await _sdk.webView!.evalJavascript('$funcName.getSELAddr()');

      print("getCurrentAccount ${accountM.address}");
      accountM.name = _keyring.current.name;

      Provider.of<ReceiveWalletProvider>( context!, listen: false).getAccount(this);
      
      contractProvider!.setSELNativeAddr(accountM.address!);
    } catch (e){
      if (ApiProvider().isDebug == true) print("Error getCurrentAccount $e");
    }

    notifyListeners();
  }

  Future<void> checkPassword({required BuildContext? context, String? pubKey, String? passOld, String? passNew}) async {
    try {

      accountM.address = await _sdk.webView!.evalJavascript('keyring.checkPassword()');
      accountM.name = _keyring.current.name;

      Provider.of<ReceiveWalletProvider>( context!, listen: false).getAccount(this);
      
      contractProvider!.setSELNativeAddr(accountM.address!);
    } catch (e){
      if (ApiProvider().isDebug == true) print("Error getCurrentAccount $e");
    }

    notifyListeners();
  }

  Future<void> changePin({required BuildContext? context, String? pubKey, String? passOld, String? passNew}) async {
    try {

      await _sdk.webView!.evalJavascript("keyring.changePassword('$pubKey', '$passOld', '$passNew')");
      
    } catch (e){
      if (ApiProvider().isDebug == true) print("Error getCurrentAccount $e");
    }

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
      if (ApiProvider().isDebug == true) print("Error encryptPrivateKey $e");
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

  // Future<KeyPairData> addAccount(
  //   Keyring keyring, {
  //   required KeyType keyType,
  //   required Map acc,
  //   required String password,
  // }) async {
  //   // save seed and remove it before add account
  //   // if (keyType == KeyType.mnemonic || keyType == KeyType.rawSeed) {
  //   // }
  //     final String type = keyType.toString().split('.')[1];
  //     final String? seed = acc[type];
  //     if (seed != null && seed.isNotEmpty) {
  //       await encryptSeedAndSave(acc['pubKey'], acc[type], type, password);
  //       acc.remove(type);
  //     }

  //   // save keystore to storage
  //   await keyring.store.addAccount(acc);

  //   return KeyPairData.fromJson(acc as Map<String, dynamic>);
  // }

  // Future<void> encryptSeedAndSave(String? pubKey, seed, seedType, password) async {
  //   print("encryptSeedAndSave");
  //   final String key = Encrypt.passwordToEncryptKey(password);
  //   final String encrypted = await FlutterAesEcbPkcs5.encryptString(seed, key);
  //   print("encrypted $encrypted");

  //   // read old data from storage-old
  //   dynamic stored = await _storageOld.getSeeds(seedType);
  //   stored[pubKey] = encrypted;
  //   print("stored[pubKey] $stored");
  //   // and save to new storage
  //   if (seedType == KeyType.mnemonic.toString().split('.')[1]) {
  //     final mnemonics = Map.from(_storage.encryptedMnemonics.val);
  //     mnemonics.addAll(stored);
  //     _storage.encryptedMnemonics.val = mnemonics;
  //     print(_storage.encryptedMnemonics.val);
  //     return;
  //   }
  //   if (seedType == KeyType.rawSeed.toString().split('.')[1]) {
  //     final seeds = Map.from(_storage.encryptedRawSeeds.val);
  //     seeds.addAll(stored);
  //     _storage.encryptedRawSeeds.val = seeds;
  //   }
  // }

  // Future<Map<String, dynamic>?> getDecryptedSeed(String? pubKey, password) async {
  //   print("getDecryptedSeed");
  //   print(_storage.encryptedMnemonics.val[pubKey]);
  //   final key = Encrypt.passwordToEncryptKey(password);
  //   final mnemonic = _storage.encryptedMnemonics.val[pubKey];
  //   if (mnemonic != null) {
  //     final res = {'type': KeyType.mnemonic.toString().split('.')[1]};
  //     try {
  //       res['seed'] = await FlutterAesEcbPkcs5.decryptString(mnemonic, key);
  //     } catch (err) {
  //       print(err);
  //     }
  //     return res;
  //   }
  //   final rawSeed = _storage.encryptedRawSeeds.val[pubKey];
  //   if (rawSeed != null) {
  //     final res = {'type': KeyType.rawSeed.toString().split('.')[1]};
  //     try {
  //       res['seed'] = await FlutterAesEcbPkcs5.decryptString(rawSeed, key);
  //     } catch (err) {
  //       print(err);
  //     }
  //     return res;
  //   }
  //   return null;
  // }
}
