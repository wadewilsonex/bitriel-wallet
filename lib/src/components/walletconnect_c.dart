import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/crypto.dart';
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
      
      if (value != null){
        sessionStore = WCSessionStore.fromJson(jsonDecode(value));
        notifyListeners();
      }
    }
    catch(error){
      if (kDebugMode) {
        print("Err initSession $error");
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
      
      if (kDebugMode) {
        print("error qrScanHandler $e");
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
      
      await wcClient.connectFromSessionStore(sessionStore!);

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
    await showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context!,
      shape: const RoundedRectangleBorder( // <-- SEE HERE
        borderRadius: BorderRadius.vertical( 
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(paddingSize),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  SizedBox(height: 10.h,),

                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(peerMeta.icons[0]),
                    backgroundColor: Colors.transparent,
                  ),

                  SizedBox(width: 2.w,),

                  Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primaryColor), size: 50,),

                  SizedBox(width: 2.w,),

                  Image.asset("assets/logo/bitriel-logo-v2.png", height: 55, width: 55),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize),
              child: MyText(text: "${peerMeta.name} would like to connect to you wallet", fontWeight: FontWeight.w700, hexaColor: AppColors.textColor, fontSize: 17,),
            ),

            SizedBox(height: 2.h,),
            if (peerMeta.url.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                child: MyText(text: peerMeta.url, hexaColor: AppColors.iconGreyColor, fontSize: 14),
              ),

            SizedBox(height: 2.h,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize),
              child: Column(
                children: [
                  const MyText(text: 'View you wallet balance and activity', hexaColor: AppColors.textColor, fontSize: 14,),
                  SizedBox(height: .5.h,),
                  const MyText(text: 'Request approval for transactions', hexaColor: AppColors.textColor, fontSize: 14,),
                ],
              ),
            ),

            SizedBox(height: 2.5.h,),
            Row(
              children: [

                Expanded(
                  child: MyGradientButton(
                    edgeMargin: const EdgeInsets.all(paddingSize),
                    lsColor: const [AppColors.primaryColor, AppColors.primaryColor],
                    lsColorOpacity: const [0.2, 0.2],
                    textButton: "Cancel",
                    textColor: AppColors.textColor,
                    fontWeight: FontWeight.w400,
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    action: () async {
                      wcClient.rejectSession();
                      Navigator.pop(context);
                    },
                  ),
                ),

                Expanded(
                  child: MyGradientButton(
                    edgeMargin: const EdgeInsets.all(paddingSize),
                    textButton: "Connect",
                    fontWeight: FontWeight.w400,
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    action: () async {
                      isApprove = true;
                      wcClient.approveSession(
                        accounts: [Provider.of<ContractProvider>(context, listen: false).ethAdd],
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
                    
                      notifyListeners();
                    },
                  ),
               
                ),

              ],
            ),

          ],
        );
      }
    );
  }

  onSessionError(dynamic message) async {
    await showDialog(
      context: context!,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: hexaCodeToColor(AppColors.darkBgd),
          title: const MyText(text: "Error", fontWeight: FontWeight.w700, hexaColor: AppColors.lowWhite, fontSize: 2.6,),
          contentPadding: EdgeInsets.fromLTRB(2.4.vmax, 12.0, 2.4.vmax, 2.4.vmax),
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
    
    // await StorageServices.removeKey(DbKey.wcSession);
    await wcClient.approveRequest(id: wcClient.chainId!, result: result);

    await showDialog(
      context: context!,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: hexaCodeToColor(AppColors.darkBgd),
          title: const MyText(text: "Session Ended", fontWeight: FontWeight.w700, hexaColor: AppColors.lowWhite, fontSize: 2.6,),
          contentPadding: EdgeInsets.fromLTRB(2.4.vmax, 12.0, 2.4.vmax, 2.4.vmax),
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
          abi, EthereumAddress.fromHex(ethereumTransaction.to!));
      final dataBytes = hexToBytes(ethereumTransaction.data!);
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
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 2.9.vmax,
                ),
              ),
            ],
          ),
          contentPadding: EdgeInsets.fromLTRB(2.4.vmax, 12.0, 2.4.vmax, 2.4.vmax),
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 2.7.vmax,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receipient',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 2.4.vmax,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    ethereumTransaction.to!,
                    style: TextStyle(fontSize: 2.4.vmax),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Transaction Fee',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 2.4.vmax,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Transaction Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 2.4.vmax,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Text(
                  //     '${EthConversions.weiToEthUnTrimmed(BigInt.parse(ethereumTransaction.value ?? '0'), 18)} MATIC',
                  //     style: TextStyle(fontSize: 2.4.vmax),
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
                    Text(
                      'Function',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 2.4.vmax,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      contractFunction.name,
                      style: TextStyle(fontSize: 2.4.vmax),
                    ),
                  ],
                ),
              ),
            Theme(
              data: Theme.of(context!).copyWith(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'Data',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 2.4.vmax,
                    ),
                  ),
                  children: [
                    Text(
                      ethereumTransaction.data!,
                      style: TextStyle(fontSize: 2.4.vmax),
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
                SizedBox(width: 2.4.vmax),
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
          contentPadding: EdgeInsets.fromLTRB(2.4.vmax, 12.0, 2.4.vmax, 2.4.vmax),
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Sign Message',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 2.7.vmax,
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
                  title: Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 2.4.vmax,
                    ),
                  ),
                  children: [
                    Text(
                      decoded,
                      style: TextStyle(fontSize: 2.4.vmax),
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
                SizedBox(width: 2.4.vmax),
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
      to: EthereumAddress.fromHex(ethereumTransaction.to!),
      maxGas: ethereumTransaction.gasLimit != null
          ? int.tryParse(ethereumTransaction.gasLimit!)
          : null,
      gasPrice: ethereumTransaction.gasPrice != null
          ? EtherAmount.inWei(BigInt.parse(ethereumTransaction.gasPrice!))
          : null,
      value: EtherAmount.inWei(BigInt.parse(ethereumTransaction.value ?? '0')),
      data: hexToBytes(ethereumTransaction.data!),
      nonce: ethereumTransaction.nonce != null
          ? int.tryParse(ethereumTransaction.nonce!)
          : null,
    );
  }
}