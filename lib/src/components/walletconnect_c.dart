import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wallet_apps/index.dart';
import 'package:http/http.dart' as http;

const maticRpcUri = 'https://rpc-mainnet.maticvigil.com/v1/140d92ff81094f0f3d7babde06603390d7e581be';

// enum MenuItems {
//   PREVIOUS_SESSION,
//   KILL_SESSION,
//   SCAN_QR,
//   PASTE_CODE,
//   CLEAR_CACHE,
// }

class WalletConnectComponent with ChangeNotifier {

  List<WCSessionStore> lsWcClients = [];
  late WCClient wcClient;
  late SharedPreferences prefs;
  late TextEditingController textEditingController;
  late String walletAddress = "", privateKey = "";
  WCSession? session;
  bool isApprove = false;
  WCSessionStore? sessionStore;
  BuildContext? context;
  final web3client = Web3Client(
    maticRpcUri,
    http.Client(),
  );

  String? ip;
  List<InternetAddress>? _internetAddress;

  Map<String, dynamic>? result = {};

  WalletConnectComponent(){
    wcClient = WCClient(
      onSessionRequest: onSessionRequest,
      onFailure: onSessionError,
      onDisconnect: onSessionClosed,
      onEthSign: onSign,
      onEthSignTransaction: onSignTransaction,
      onEthSendTransaction: onSendTransaction,
      onCustomRequest: (_, __) {},
      onConnect: onConnect,
    );
    // getIP();
    initSession();
  }

  Future<void> killAllSession() async {

    
    for(int i = 0; i < lsWcClients.length; i++) {
      await Future.delayed(const Duration(seconds: 1), (){ 
        connectToPreviousSession(lsWcClients[i], autoKill: true);
      });

      if (kDebugMode) {
        print("kill session");
      }
    }
    lsWcClients.clear();
    await StorageServices.removeKey(DbKey.wcSession);
    notifyListeners();
  }

  void getIP() async {
    // print("getIP");
    List<NetworkInterface> l = await NetworkInterface.list();
    for (int i = 0; i < l.length; i++ ){
      _internetAddress = l[0].addresses;
      ip = _internetAddress![0].address;
      break;
    }

    notifyListeners();
  }

  set setBuildContext(BuildContext context) {
    this.context = context;
    // notifyListeners();
  }
  
  initSession() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String? value = pref.getString("session");
      if (kDebugMode) {
        print("initSession value $value");
      }
      if (value != null){
        sessionStore = WCSessionStore.fromJson(jsonDecode(value));
        notifyListeners();
      }
    }
    catch(error){
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Err initSession $error");
        }
      }
    }
  }

  void fromJsonFilter(List<Map<String, dynamic>> data){
    lsWcClients = [];
    for (var element in data) {
      lsWcClients.add(WCSessionStore.fromJson(element));
    }
    notifyListeners();
  }

  void afterKill(){
    notifyListeners();
  }

  qrScanHandler(String value) {
    if (kDebugMode) {
      print("qrScanHandler");
    }
    try {

      final session = WCSession.from(value);
      final peerMeta = WCPeerMeta(
        name: "Example Wallet",
        url: session.bridge,
        description: "Example Wallet",
        icons: [
          // "https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png"
        ],
      );
      // walletAddress = Provider.of<ApiProvider>(context!, listen: false).accountM.address!;
      wcClient.connectNewSession(session: session, peerMeta: peerMeta);
    } catch (e){
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("error qrScanHandler $e");
        }
      }
    }
  }

  connectToPreviousSession(WCSessionStore session, {bool? autoKill = false}) async {
    if (kDebugMode) {
      print("connectToPreviousSession ");
    }
    // prefs = await SharedPreferences.getInstance();
    // final _sessionSaved = prefs.getString(DbKey.wcSession);
    // debugPrint("_sessionSaved ${jsonDecode(_sessionSaved!)['remotePeerMeta']}");
    // Navigator.push(context!, MaterialPageRoute(builder: (context) => WalletConnectPage())); // walletConnect: jsonDecode(_sessionSaved)['remotePeerMeta']
    sessionStore = session;
    // _sessionSaved != null
    //   ? WCSessionStore.fromJson(jsonDecode(_sessionSaved))
    //   : null;
      
    if (sessionStore != null) {
      if (kDebugMode) {
        print("connectToPreviousSession sessionStore != null");
      }
      await wcClient.connectFromSessionStore(sessionStore!);

      if (kDebugMode) {
        print(wcClient.isConnected);
      }
      if (kDebugMode) {
        print("wcClient id ${wcClient.peerMeta!.name}");
      }
      if (autoKill == true) await wcClient.killSession();
      
    } else {
      ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(
        content: Text('No previous session found.'),
      ));
    }
    
  }

  onConnect() {
    // print(sessionStore!.session.toJson());

    // Close Dialog Approve
    if (isApprove) Navigator.pop(context!);

    isApprove = false;

    // Navigator.push(
    //   context!, 
    //   Transition(child: WalletConnectPage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
    // );
    // setState(() {
    //   connected = true;
    // });
  }

  // After Scan QR
  onSessionRequest(int id, WCPeerMeta peerMeta) async {
    await showDialog(
      context: context!,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: hexaCodeToColor(AppColors.darkBgd),
          title: Column(
            children: [
              // if (peerMeta.icons.isNotEmpty)
              //   Container(
              //     height: 100.0,
              //     width: 100.0,
              //     padding: const EdgeInsets.only(bottom: 8.0),
              //     child: Image.network(peerMeta.icons.first.replaceAll("localhost", ip!)),
              //   ),
              MyText(text: peerMeta.name, fontWeight: FontWeight.w700, hexaColor: AppColors.lowWhite, fontSize: 17,),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [

            if (peerMeta.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: MyText(text: peerMeta.description, hexaColor: AppColors.lowWhite,),
              ),
            if (peerMeta.url.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: MyText(text: 'Connection to ${peerMeta.url}', hexaColor: AppColors.lowWhite),
              ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: hexaCodeToColor(AppColors.orangeColor),
                    ),
                    onPressed: () async {
                      isApprove = true;
                      wcClient.approveSession(
                        accounts: [Provider.of<ContractProvider>(context!, listen: false).ethAdd],
                        chainId: wcClient.chainId,
                      );

                      // await StorageServices.storeData(wcClient.sessionStore.toJson(), DbKey.wcSession);
                      sessionStore = wcClient.sessionStore;
                      
                      lsWcClients.add(wcClient.sessionStore);

                      List<Map<String, dynamic>> tmpWcSession = [];

                      for (var element in lsWcClients) {
                        tmpWcSession.add(element.toJson());
                      }

                      await StorageServices.storeData(tmpWcSession, DbKey.wcSession);
                      
                      // Close Approve Dialog
                      // Navigator.pop(context!);

                      // print("Start navigate");
                      // await Navigator.pushReplacement(
                      //   context!, 
                      //   Transition(child: WalletConnectPage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                      // );
                      // Navigator.pop(context!);
                      notifyListeners();
                    },
                    child: const MyText(text: 'APPROVE', hexaColor: AppColors.lowWhite,),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: hexaCodeToColor(AppColors.orangeColor),
                    ),
                    onPressed: () {
                      wcClient.rejectSession();
                      Navigator.pop(context!);
                    },
                    child: const MyText(text: 'REJECT', hexaColor: AppColors.lowWhite),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  onSessionError(dynamic message) async {
    await showDialog(
      context: context!,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: hexaCodeToColor(AppColors.darkBgd),
          title: const MyText(text: "Error", fontWeight: FontWeight.w700, hexaColor: AppColors.lowWhite, fontSize: 17,),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: MyText(text: "Some Error Occured. $message", hexaColor: AppColors.lowWhite,),
            ),
            Row(
              children: [
                TextButton(
                  // style: TextButton.styleFrom(
                  //   primary: Colors.white,
                  //   backgroundColor: hexaCodeToColor(AppColors.orangeColor),
                  // ),
                  onPressed: () {
                    Navigator.pop(context!);
                  },
                  child: const Text('CLOSE'),
                ),
              ],
            ),
          ],
        );
      },
    );
    
  }

  onSessionClosed(int? code, String? reason) async {
    
    if (kDebugMode) {
      print("close session code: $code");
    }
    if (kDebugMode) {
      print("close session reason: $reason");
    }
    // await StorageServices.removeKey(DbKey.wcSession);
    await wcClient.approveRequest(id: wcClient.chainId!, result: result);

    await showDialog(
      context: context!,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: hexaCodeToColor(AppColors.darkBgd),
          title: const MyText(text: "Session Ended", fontWeight: FontWeight.w700, hexaColor: AppColors.lowWhite, fontSize: 17,),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [

            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: MyText(text: "Some Error Occured. ERROR CODE: $code", color: AppColors.lowWhite,),
            // ),
            if (reason != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: MyText(text: "Failure Reason: $reason", hexaColor: AppColors.lowWhite,),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  // style: TextButton.styleFrom(
                  //   primary: Colors.white,
                  //   backgroundColor: Theme.of(context!).colorScheme.secondary,
                  // ),
                  onPressed: () {
                    // Close Dialog
                    Navigator.pop(context!);
                    // Close Wallet Connect Page
                    Navigator.pop(context!);
                  },
                  child: const Text('CLOSE'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  onSignTransaction(
    int id,
    WCEthereumTransaction ethereumTransaction,
  ) async {
    await onTransaction(
      id: id,
      ethereumTransaction: ethereumTransaction,
      title: 'Sign Transaction',
      onConfirm: () async {
        final creds = EthPrivateKey.fromHex(privateKey);
        final tx = await web3client.signTransaction(
          creds,
          _wcEthTxToWeb3Tx(ethereumTransaction),
          chainId: wcClient.chainId!,
        );
        // final txhash = await web3client.sendRawTransaction(tx);
        // debugPrint('txhash $txhash');
        wcClient.approveRequest<String>(
          id: id,
          result: bytesToHex(tx),
        );
        Navigator.pop(context!);
      },
      onReject: () {
        wcClient.rejectRequest(id: id);
        Navigator.pop(context!);
      },
    );
  }

  onSendTransaction(
    int id,
    WCEthereumTransaction ethereumTransaction,
  ) async {
    await onTransaction(
      id: id,
      ethereumTransaction: ethereumTransaction,
      title: 'Send Transaction',
      onConfirm: () async {
        
        final creds = EthPrivateKey.fromHex(privateKey);
        final txhash = await web3client.sendTransaction(
          creds,
          _wcEthTxToWeb3Tx(ethereumTransaction),
          chainId: wcClient.chainId!,
        );
        wcClient.approveRequest<String>(
          id: id,
          result: txhash,
        );
        Navigator.pop(context!);
      },
      onReject: () {
        wcClient.rejectRequest(id: id);
        Navigator.pop(context!);
      },
    );
  }

  Future<void> onTransaction({
    required int id,
    required WCEthereumTransaction ethereumTransaction,
    required String title,
    required VoidCallback onConfirm,
    required VoidCallback onReject,
  }) async {
    ContractFunction? contractFunction;
    BigInt gasPrice = BigInt.parse(ethereumTransaction.gasPrice ?? '0');
    try {
      final abiUrl =
          'https://api.polygonscan.com/api?module=contract&action=getabi&address=${ethereumTransaction.to}&apikey=BCER1MXNFHP1TVE93CMNVKC5J4FV8R4CPR';
      final res = await http.get(Uri.parse(abiUrl));
      final Map<String, dynamic> resMap = jsonDecode(res.body);
      final abi = ContractAbi.fromJson(resMap['result'], '');
      final contract = DeployedContract(
          abi, EthereumAddress.fromHex(ethereumTransaction.to));
      final dataBytes = hexToBytes(ethereumTransaction.data);
      final funcBytes = dataBytes.take(4).toList();
      final maibiFunctions = contract.functions
          .where((element) => listEquals<int>(element.selector, funcBytes));
      if (maibiFunctions.isNotEmpty) {
        // contractFunction.parameters.forEach((element) {
        //   debugPrint("params ${element.name} ${element.type.name}");
        // });
        // final params = dataBytes.sublist(4).toList();
        // debugPrint("params $params ${params.length}");
      }
      if (gasPrice == BigInt.zero) {
        gasPrice = await web3client.estimateGas();
      }
    } catch (e, trace) {
      if (ApiProvider().isDebug == true) debugPrint("failed to decode\n$e\n$trace");
    }
    await showDialog(
      context: context!,
      builder: (_) {
        return SimpleDialog(
          title: Column(
            children: [
              if (wcClient.remotePeerMeta!.icons.isNotEmpty)
                Container(
                  height: 100.0,
                  width: 100.0,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(wcClient.remotePeerMeta!.icons.first),
                ),
              Text(
                wcClient.remotePeerMeta!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Receipient',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    ethereumTransaction.to,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: const [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Transaction Fee',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Text(
                  //     '${EthConver .weiToEthUnTrimmed(gasPrice * BigInt.parse(ethereumTransaction.gas ?? '0'), 18)} MATIC',
                  //     style: TextStyle(fontSize: 16.0),
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: const [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Transaction Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Text(
                  //     '${EthConversions.weiToEthUnTrimmed(BigInt.parse(ethereumTransaction.value ?? '0'), 18)} MATIC',
                  //     style: TextStyle(fontSize: 16.0),
                  //   ),
                  // ),
                ],
              ),
            ),
            if (contractFunction != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Function',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      contractFunction.name,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            Theme(
              data:
                  Theme.of(context!).copyWith(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text(
                    'Data',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  children: [
                    Text(
                      ethereumTransaction.data,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context!).colorScheme.secondary,
                    ),
                    onPressed: onConfirm,
                    child: const Text('CONFIRM'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context!).colorScheme.secondary,
                    ),
                    onPressed: onReject,
                    child: const Text('REJECT'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  onSign(
    int id,
    WCEthereumSignMessage ethereumSignMessage,
  ) async {
    final decoded = (ethereumSignMessage.type == WCSignType.TYPED_MESSAGE)
        ? ethereumSignMessage.data!
        : ascii.decode(hexToBytes(ethereumSignMessage.data!));
    await showDialog(
      context: context!,
      builder: (_) {
        return SimpleDialog(
          title: Column(
            children: [
              if (wcClient.remotePeerMeta!.icons.isNotEmpty)
                Container(
                  height: 100.0,
                  width: 100.0,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(wcClient.remotePeerMeta!.icons.first),
                ),
              Text(
                wcClient.remotePeerMeta!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: const Text(
                'Sign Message',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Theme(
              data:
                  Theme.of(context!).copyWith(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  children: [
                    Text(
                      decoded,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context!).colorScheme.secondary,
                    ),
                    onPressed: () async {
                      String signedDataHex;
                      if (ethereumSignMessage.type ==
                          WCSignType.TYPED_MESSAGE) {
                        signedDataHex = EthSigUtil.signTypedData(
                          privateKey: privateKey,
                          jsonData: ethereumSignMessage.data!,
                          version: TypedDataVersion.V4,
                        );
                      } else {
                        final creds = EthPrivateKey.fromHex(privateKey);
                        final encodedMessage =
                            hexToBytes(ethereumSignMessage.data!);
                        final signedData =
                            await creds.signPersonalMessage(encodedMessage);
                        signedDataHex = bytesToHex(signedData, include0x: true);
                      }
                      wcClient.approveRequest<String>(
                        id: id,
                        result: signedDataHex,
                      );
                      Navigator.pop(context!);
                    },
                    child: const Text('SIGN'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context!).colorScheme.secondary,
                    ),
                    onPressed: () {
                      wcClient.rejectRequest(id: id);
                      Navigator.pop(context!);
                    },
                    child: const Text('REJECT'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    
  }

  Transaction _wcEthTxToWeb3Tx(WCEthereumTransaction ethereumTransaction) {
    return Transaction(
      from: EthereumAddress.fromHex(ethereumTransaction.from),
      to: EthereumAddress.fromHex(ethereumTransaction.to),
      maxGas: ethereumTransaction.gasLimit != null
          ? int.tryParse(ethereumTransaction.gasLimit!)
          : null,
      gasPrice: ethereumTransaction.gasPrice != null
          ? EtherAmount.inWei(BigInt.parse(ethereumTransaction.gasPrice!))
          : null,
      value: EtherAmount.inWei(BigInt.parse(ethereumTransaction.value ?? '0')),
      data: hexToBytes(ethereumTransaction.data),
      nonce: ethereumTransaction.nonce != null
          ? int.tryParse(ethereumTransaction.nonce!)
          : null,
    );
  }
}