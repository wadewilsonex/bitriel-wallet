import 'dart:math';
import 'package:flutter_aes_ecb_pkcs5/flutter_aes_ecb_pkcs5.dart';
import 'package:flutter_bitcoin/flutter_bitcoin.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/utils/index.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/constants/db_key_con.dart';
import 'package:wallet_apps/data/models/account.m.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_apps/data/provider/receive_wallet_p.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:wallet_apps/data/provider/test_p.dart';

class ApiModel {

  MyMyKeyPair? myKeyPair = MyMyKeyPair();
  // bool? isConnected = false;

  ApiModel.initData(KeyPairData? key, bool connect){
    myKeyPair = MyMyKeyPair.fromJson(key!.name ?? '...', key.address ?? '');
    // isConnected = connect;
  }
}

class MyMyKeyPair{

  String? name = '';
  String? addr = '';

  MyMyKeyPair();

  MyMyKeyPair.fromJson(String n, String adr){
    name = n;
    addr = adr;
  }
}

class ApiProvider with ChangeNotifier {
  
  final WalletSDK _sdk = WalletSDK();
  final Keyring _keyring = Keyring();

  NetworkParams node = NetworkParams();

  Keyring get getKeyring => _keyring;
  WalletSDK get getSdk => _sdk;

  static const int bitcoinDigit = 8;

  num bitcoinSatFmt = pow(10, 8);

  double amount = 0.0008;

  String btcAdd = '';

  ContractProvider? contractProvider;

  String? _jsCode;

  bool isMainnet = true;
  
  int selNativeIndex = 0;
  int kgoIndex = 3;
  int ethIndex = 4;
  int bnbIndex = 5;
  int dotIndex = 6;
  int btcIndex = 7;
  int attIndex = 8;
  int tetherIndex = 9;

  /// Selendra Endpoint
  String? selNetwork;

  bool? netWorkConnected = false;

  ValueNotifier<ApiModel> apiModel = ValueNotifier<ApiModel>(ApiModel.initData(KeyPairData(), false));

  void checkConnect() async {

    // await _sdk.webView!.evalJavascript("settings.getIsConnected()").then((value) {
    //   isConnected!.value = value;
    // });
  }

  Future<void> initSelendraEndpoint(Map<String, dynamic> json) async {
    try {

      sldNetworkList = [
        json[ isMainnet ? 'mainnet' : 'testnet' ][0],
        json[ isMainnet ? 'mainnet' : 'testnet' ][1]
      ];

      // sldNetworkList = [
      //   S2Choice(value: json[ isMainnet ? 'mainnet' : 'testnet' ][0], title: 'SELENDRA RPC 0', subtitle: json[ isMainnet ? 'mainnet' : 'testnet' ][0]),
      //   S2Choice(value: json[ isMainnet ? 'mainnet' : 'testnet' ][1], title: 'SELENDRA RPC 1', subtitle: json[ isMainnet ? 'mainnet' : 'testnet' ][0]Z)
      // ];
      
      AppConfig.networkList[0].wsUrlMN = json['mainnet'][0];

      selNetwork = json['mainnet'][0];

      await StorageServices.storeData(json, DbKey.lsSldEndpoint);
      
    } catch (e) {
      if (kDebugMode) {
      }
    }
    
  }

  Future<void> initApi({@required BuildContext? context}) async {

    // Asign Network
    await StorageServices.fetchData(DbKey.sldNetwork).then((nw) async {
      /// Get Endpoint form Local DB
      /// 
      if (nw != null){

        selNetwork = nw;
      } else {
        selNetwork = isMainnet ? AppConfig.networkList[0].wsUrlMN : AppConfig.networkList[0].wsUrlTN;

      }

      await StorageServices.storeData(selNetwork, DbKey.sldNetwork);
      
    });

    contractProvider = Provider.of<ContractProvider>(context!, listen: false);

    try {

      await rootBundle.loadString('assets/js/main.js').then((String js) {
        _jsCode = js;
      });
    
      // await _keyring.init([0, isMainnet ? AppConfig.networkList[0].ss58MN! : AppConfig.networkList[0].ss58!]);
      await _keyring.init([isMainnet ? AppConfig.networkList[0].ss58MN! : AppConfig.networkList[0].ss58!]);
      await _sdk.init(_keyring, jsCode: _jsCode);


    } catch (e) {
      if (kDebugMode) {
      }
    }
    // notifyListeners();
  }

  // Future<NetworkParams> connectPolNon({@required BuildContext? context}) async {
  //   dynamic res;
  //   try {

  //     NetworkParams polNode = NetworkParams();
  //     // NetworkParams selNode = NetworkParams();
  //     polNode.name = 'Polkadot(Live, hosted by PatractLabs)';
  //     polNode.endpoint = isMainnet ? AppConfig.networkList[1].wsUrlMN : AppConfig.networkList[1].wsUrlTN;//'wss://westend-rpc.polkadot.io';//'wss://polkadot.elara.patract.io';//AppConfig.networkList[1].wsUrlMN; ;
  //     polNode.ss58 = 0;

  //     // selNode.name = 'Indranet hosted By Selendra';
  //     // selNode.endpoint = isMainnet ? AppConfig.networkList[0].wsUrlMN : AppConfig.networkList[0].wsUrlTN;
  //     // selNode.ss58 = isMainnet ? AppConfig.networkList[0].ss58MN : AppConfig.networkList[0].ss58;

  //     // final node = NetworkParams();
  //     // node.name = 'Polkadot(Live, hosted by PatractLabs)';
  //     // node.endpoint = 'wss://polkadot.elara.patract.io';
  //     // node.ss58 = 0;

  //     await _sdk.api.connectNode(_keyring, [polNode]).then((value) async {
  //       res = value;
  //       await getDotChainDecimal(context: context);
  //     });

  //     notifyListeners();
  //   } catch (e) {
  //     
  //       if (kDebugMode) {
  //         
  //       }
  //     
  //   }

  //   return res ?? NetworkParams();
  // }

  // Future<bool> validateBtcAddr(String address) async {
  //   return Address.validateAddress(address, bitcoin);
  // }

  // void setBtcAddr(String btcAddress) {
  //   btcAdd = btcAddress;
  //   notifyListeners();
  // }

  Future<void> queryBtcData(BuildContext context, String seeds, String passCode) async {
    final contractPro = Provider.of<ContractProvider>(context, listen: false);
    
    try {
      final seed = bip39.mnemonicToSeed(seeds);
      final hdWallet = HDWallet.fromSeed(seed);
      
      contractPro.listContract[btcIndex].address = hdWallet.address!;
      
      final keyPair = ECPair.fromWIF(hdWallet.wif!);

      final bech32Address = P2WPKH(data: PaymentData(pubkey: keyPair.publicKey), network: bitcoin).data.address;
      await StorageServices.storeData(bech32Address, DbKey.bech32);
      await StorageServices.storeData(hdWallet.address, DbKey.hdWallet);

      final res = await encryptPrivateKey(hdWallet.wif!, passCode);

      await StorageServices.writeSecure(DbKey.btcwif, res);

      // Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain', context: context);

      // setBtcAddr(bech32Address!);
      // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
      // await Provider.of<ApiProvider>(context, listen: false).getBtcBalance(context: context);

      contractPro.notifyListeners();

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

    final p2wpkh = P2WPKH(data: PaymentData(pubkey: alice.publicKey)).data;

    final txb = TransactionBuilder();
    
    txb.setVersion(1);

    final res = await getAddressUxto(from);

    if (res.length != 0) {
      for (final i in res) {
        if (i['status']['confirmed'] == true) {
          txb.addInput(i['txid'], int.parse(i['vout'].toString()), null, p2wpkh.output);
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
    if (kDebugMode) {
      
    }
    try {

      final res = await http.get(Uri.parse('https://blockstream.info/api/address/$address/utxo'));

      

      return json.decode(res.body);
    } catch (e){
      
        if (kDebugMode) {
          
        }
      
    }
  }

  Future<void> totalBalance({@required BuildContext? context}) async {
    
    final contract = Provider.of<ContractProvider>(context!, listen: false);
    
    double total = 0.0;

    var balanceList = [];
    
    for (var element in contract.sortListContract) {
      
      if(element.marketPrice != null && element.marketPrice!.isNotEmpty){
        total = double.parse(element.balance!.replaceAll(",", "")) * double.parse(element.marketPrice!);
        balanceList.add(total);
      }
    }

    total = balanceList.reduce((a, b) => a + b);

    contract.totalAmount = total;
  
  }

  Future<void> getBtcBalance({@required BuildContext? context}) async {
    
    final contract = Provider.of<ContractProvider>(context!, listen: false);
    
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
      
        if (kDebugMode) {
          
        }
      
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

    final contract = Provider.of<ContractProvider>(context!, listen: false);
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
      
        if (kDebugMode) {
          
        }
      
    }
    return res;
  }
  
  Future<bool> validateEther(String address) async {
    try {

      dynamic res = await _sdk.api.service.webView!.evalJavascript('wallets.validateEtherAddr("$address")');
      return res;
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
    return false;
  }

  Future<String> getPrivateKey(String mnemonic) async {
    try {

      final res = await _sdk.api.service.webView!.evalJavascript("wallets.getPrivateKey('$mnemonic')");//ApiProvider._sdk.api.getPrivateKey(mnemonic);
      return res;
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
    return '';
  }

  Future<bool> validateAddress(String address) async {
    try {

      final res = await _sdk.api.service.webView!.evalJavascript("keyring.validateAddress('$address')");
      return res;
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
    return false;
  }

  Future<void> connectSELNode({@required BuildContext? context, String? funcName = 'keyring', String? endpoint}) async {

    try {

      node.name = 'Selendra';
      node.endpoint = isMainnet ? AppConfig.networkList[0].wsUrlMN : AppConfig.networkList[0].wsUrlTN;//endpoint ?? network;
      node.ss58 = isMainnet ? AppConfig.networkList[0].ss58MN : AppConfig.networkList[0].ss58;

      await _sdk.api.connectNode(_keyring, [node]).then((value) async {

        apiModel.value = ApiModel.initData(_keyring.current, true);
      });

      // ignore: use_build_context_synchronously
      if (getKeyring.keyPairs.isNotEmpty) await getSelNativeChainDecimal(context: context, funcName: funcName);
      
      /// Save To Local After Connect Network 
      if (endpoint != null){
        selNetwork = endpoint;
        
        await StorageServices.storeData(
          selNetwork,
          DbKey.sldNetwork
        );

        // ignore: use_build_context_synchronously
        // checkConnect();
      }

    } catch (e) {
      if (kDebugMode) {
        
      }
    }
  }

  /// Connect SEL Chain
  /// 
  /// Inside This Chain Decimal Also Call Get Balance
  Future<void> getSelNativeChainDecimal({@required BuildContext? context, String? funcName = 'keyring'}) async {
    
    try {
      dynamic res;
      
      ContractProvider contract = Provider.of<ContractProvider>(context!, listen: false);
      
      await querySELAddress().then((value) async {
        await _sdk.api.service.webView!.evalJavascript('settings.getChainDecimal(api)').then((value) async {
          
          res = value;
          contract.listContract[selNativeIndex].chainDecimal = res[0];
          await subSELNativeBalance(context: context);

        });
      });
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
  }

  Future<void> querySELAddress() async {
    
    // Get SEL native Address From Account 
    await _sdk.webView!.evalJavascript('account.getSELAddr()').then((value) async {
      if (value != null){
        contractProvider!.listContract[selNativeIndex].address = value;
      } else {
        await _sdk.webView!.evalJavascript('keyring.getSELAddr()').then((value) async {
          contractProvider!.listContract[selNativeIndex].address = value;
        });
      }
    });
  }

  Future<void> subSELNativeBalance({@required BuildContext? context}) async {
    try {

      final contract = Provider.of<ContractProvider>(context!, listen: false);
      // Provider.of<ContractProvider>(context, listen: false).setSELNativeAddr(contract.listContract[selNativeIndex].address ?? '');
      
      await _sdk.webView!.evalJavascript("account.getBalance(api, '${_keyring.current.address}', 'Balance')").then((value) async {
        
        contract.listContract[selNativeIndex].balance = Fmt.balance(
          value['freeBalance'].toString(),
          contract.listContract[selNativeIndex].chainDecimal!,
        );
        await contract.sortAsset();
      });
      // await _sdk.api.account.subscribeBalance(contract.listContract[selNativeIndex].address, (res) async {
      //   
      //   contract.listContract[selNativeIndex].balance = Fmt.balance(
      //     res.freeBalance.toString(),
      //     int.parse(contract.listContract[selNativeIndex].chainDecimal!),
      //   );
      //   
      //   await contract.sortAsset();
      // });

    } catch (e) {

      if (kDebugMode) {
        
      }
    }
  }

  void isDotContain({@required BuildContext? context}) {
    final con = Provider.of<ContractProvider>(context!, listen: false);
    con.listContract[dotIndex].isContain = true;
    notifyListeners();
  }

  Future<void> setDotMarket(Market marketData, List<List<double>> lineChartData, String currentPrice, String priceChange24h, {@required BuildContext? context}) async {

    final contract = Provider.of<ContractProvider>(context!, listen: false);
    contract.listContract[dotIndex].marketData = marketData;
    contract.listContract[dotIndex].marketPrice = currentPrice;
    contract.listContract[dotIndex].change24h = priceChange24h;
    contract.listContract[dotIndex].lineChartList = lineChartData;

    notifyListeners();
  }

  Future<void> getDotChainDecimal({@required BuildContext? context}) async {
    
    try {
      dynamic res;
      final contract = Provider.of<ContractProvider>(context!, listen: false);
      await _sdk.api.service.webView!.evalJavascript('settings.getChainDecimal(api)').then((value) async {
        res = value;
        contract.setDotAddr(_keyring.allAccounts[0].address!, res[0]);
        await subscribeDotBalance(context: context);
      });
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
  }

  Future<void> subscribeDotBalance({@required BuildContext? context}) async {
    try {

      final contract = Provider.of<ContractProvider>(context!, listen: false);
      // final msgChannel = 'NBalance';
      // final code = 'account.getBalance(api, "${_keyring.current.address}", "$msgChannel")';
      await _sdk.webView!.evalJavascript("account.getBalance(api, '${contract.listContract[dotIndex].address}', 'Balance')").then((value) {//_sdk.api.account.subscribeBalance(contract.listContract[dotIndex].address, (res) async {
        
        contract.listContract[dotIndex].balance = Fmt.balance(
          value['freeBalance'].toString() == "0" ? "0.0" : value['freeBalance'].toString(),
          contract.listContract[dotIndex].chainDecimal!,
        );

        contract.listContract[dotIndex].lineChartModel = LineChartModel().prepareGraphChart(contract.listContract[dotIndex]);

      });

      // await connectSELNode(context: context);
      
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
  }

  Future<void> getAddressIcon({int accIndex = 0}) async {

    try {

      final res = await _sdk.api.account.getPubKeyIcons(
        [_keyring.keyPairs[accIndex].pubKey!],
      );

      _keyring.current.icon = res.toString();
      
    } catch (e) {
      
        if (kDebugMode) {
          
        }
      
    }
  }

  // Future<void> getCurrentAccount({required BuildContext? context, String funcName = 'account'}) async {
  //   try {

  //     accountM.address = await _sdk.webView!.evalJavascript('$funcName.getSELAddr()');
  //     accountM.name = _keyring.current.name;
  //     accountM.pubKey = _keyring.current.pubKey;

  //     Provider.of<ReceiveWalletProvider>( context!, listen: false).getAccount(accountM);
      
  //     contractProvider!.setSELNativeAddr(accountM.address!);

  //   } catch (e){
  //     
  //       if (kDebugMode) {
  //         
  //       }
  //     
  //   }

  //   notifyListeners();
  // }

  // Future<void> checkPassword({required BuildContext? context, String? pubKey, String? passOld, String? passNew}) async {
  //   try {

  //     accountM.address = await _sdk.webView!.evalJavascript('keyring.checkPassword()');
      
  //     contractProvider!.setSELNativeAddr(_keyring.current.address!);
  //   } catch (e){
  //     
  //       if (kDebugMode) {
  //         
  //       }
  //     
  //   }

  //   notifyListeners();
  // }

  Future<void> changePin({required BuildContext? context, String? pubKey, String? passOld, String? passNew}) async {
    try {

      await _sdk.webView!.evalJavascript("keyring.changePassword('$pubKey', '$passOld', '$passNew')");
      
    } catch (e){
      
        if (kDebugMode) {
          
        }
      
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
    final String? decryted = await FlutterAesEcbPkcs5.decryptString(privateKey, key);
    return decryted!;
  }

  Future<String> encryptPrivateKey(String privateKey, String password) async {
    try {

      final String key = Encrypt.passwordToEncryptKey(password);
      final String? encryted = await FlutterAesEcbPkcs5.encryptString(privateKey, key);
      return encryted!;
    } catch (e) {
      
      if (kDebugMode) {
        
      }
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
}