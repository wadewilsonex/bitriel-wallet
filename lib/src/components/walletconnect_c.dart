import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
<<<<<<< HEAD
=======
import 'package:wallet_apps/src/provider/app_p.dart';
>>>>>>> daveat
import 'package:wallet_apps/src/screen/home/menu/wallet_connect/confirm_trx.dart';
import 'package:web3dart/crypto.dart';
import 'package:wallet_apps/index.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

const maticRpcUri = 'https://rpc-mainnet.maticvigil.com/v1/140d92ff81094f0f3d7babde06603390d7e581be';

// enum MenuItems {
//   PREVIOUS_SESSION,
//   KILL_SESSION,
//   SCAN_QR,
//   PASTE_CODE,
//   CLEAR_CACHE,
// }

class WalletConnectProvider with ChangeNotifier {

  ContractProvider? contractPro;
  List<WCSessionStore> lsWcClients = [];
  late WCClient wcClient;
  late SharedPreferences prefs;
  late TextEditingController textEditingController;
  late String walletAddress = "", privateKey = "";
  WCSession? session;
  bool isApprove = false;
  WCSessionStore? sessionStore;
  BuildContext? context;

  String? ip;
  List<InternetAddress>? _internetAddress;

  Map<String, dynamic>? result = {};

  WalletConnectProvider(){
    wcClient = WCClient(
      onSessionRequest: onSessionRequest,
      onFailure: onSessionError,
      onDisconnect: onSessionClosed,
      onEthSign: onSign,
      onEthSignTransaction: onSignTransaction,
      onEthSendTransaction: onSendTransaction,
      onCustomRequest: (_, __) {},
      onWalletSwitchNetwork: onSwitchNetwork,
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
    // debugPrint("getIP");
    List<NetworkInterface> l = await NetworkInterface.list();
    for (int i = 0; i < l.length; i++ ){
      _internetAddress = l[0].addresses;
      ip = _internetAddress![0].address;
      // break;
    }

    notifyListeners();
  }

  set setBuildContext(BuildContext context) {
    this.context = context;
    contractPro = Provider.of<ContractProvider>(context, listen: false);
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
        debugPrint("Err initSession $error");
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
    if (value.contains('bridge') && value.contains('key')) {
      final session = WCSession.from(value);
      debugPrint('session $session');
      final peerMeta = WCPeerMeta(
        name: "Bitriel",
        url: "https://bitriel.com/",
        description: "Bitriel is a self-custody digital wallet that supports cross-chain multi-assets; crypto assets and NFTs.",
        icons: [
          "https://bitriel.com/static/media/bitriel-logo.bf35b690f5b262d75ab9.png"
        ],
      );
      wcClient.connectNewSession(session: session, peerMeta: peerMeta);
    }
  }
  
  // qrScanHandler(String value) {
    
  //   try {

  //     final session = WCSession.from(value);
  //     final peerMeta = WCPeerMeta(
  //       name: "WalletConnect",
  //       url: session.bridge,
  //       description: "WalletConnect Developer App",
  //       icons: [
  //         'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
  //       ],
  //     );
  //     // walletAddress = Provider.of<ApiProvider>(context!, listen: false).accountM.address!;
  //     wcClient.connectNewSession(session: session, peerMeta: peerMeta);
  //   } catch (e){
      
  //     if (kDebugMode) {
  //       debugPrint("error qrScanHandler $e");
  //     }
  //   }
  // }

  connectToPreviousSession(WCSessionStore session, {bool? autoKill = false}) async {
    
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
    // Close Dialog Approve
    if (isApprove) Navigator.pop(context!);

    isApprove = false;
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

<<<<<<< HEAD
                  Image.asset("assets/logo/bitriel-logo-v2.png", height: 55, width: 55),
=======
                  Consumer<AppProvider>(
                    builder: (context, pro, wg) {
                      if (pro.dirPath == null) return Container();
                      return Image.file(File("${pro.dirPath}/logo/bitriel-logo-v2.png"), height: 55, width: 55);
                    }
                  ),
>>>>>>> daveat
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
                child: MyText(text: peerMeta.url, hexaColor: AppColors.iconGreyColor),
              ),

            SizedBox(height: 2.h,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize),
              child: Column(
                children: [
                  const MyText(text: 'View you wallet balance and activity', hexaColor: AppColors.textColor),
                  SizedBox(height: .5.h,),
                  const MyText(text: 'Request approval for transactions', hexaColor: AppColors.textColor),
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
    
    await wcClient.approveRequest(id: wcClient.chainId!, result: result);

    await showDialog(
      context: context!,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: hexaCodeToColor(AppColors.whiteColorHexa),
          title: const MyText(text: "Session Ended", fontWeight: FontWeight.w700, hexaColor: AppColors.blackColor, fontSize: 17,),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Close Dialog
                    Navigator.pop(context!);
                  },
                  child: const MyText(text: 'CLOSE', hexaColor: AppColors.primaryColor,),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<dynamic>? getPrivateKey(String encryptKey, String pin, {@required BuildContext? context}) async {
    try {
      privateKey = await Provider.of<ApiProvider>(context!, listen: false).decryptPrivateKey(encryptKey, pin);
    } catch (e) {
      
      if (kDebugMode) {
        debugPrint('Error getPrivateKey $e');
      }
      
    }

    return privateKey;
  }

  onSignTransaction(
    int id,
    WCEthereumTransaction ethereumTransaction,
  ) async {
    debugPrint("onSignTransaction");
    debugPrint("ethereumTransaction ${ethereumTransaction.toJson()}");

    await onTransaction(
      id: id,
      ethereumTransaction: ethereumTransaction,
      title: 'Sign Transaction',
      onConfirm: () async {
        final creds = EthPrivateKey.fromHex(privateKey);
        final tx = await contractPro!.bscClient.signTransaction(
          creds,
          _wcEthTxToWeb3Tx(ethereumTransaction),
          chainId: wcClient.chainId!,
        );
        
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
        final txhash = await contractPro!.bscClient.sendTransaction(
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

    debugPrint("onTransaction");

    // try {
    //   final maxGas = await contractPro!.bscClient.estimateGas(
    //     sender: EthereumAddress.fromHex(ethereumTransaction.from),
    //     to: EthereumAddress.fromHex(ethereumTransaction.to!),
    //     data: _sendFunction().encodeCall(
    //       [
    //         trxInfo.receiver,
    //         BigInt.from(double.parse(trxInfo.amount!) * pow(10, trxInfo.chainDecimal!))
    //       ],
    //     ),
    //   );
    //   debugPrint("maxGas $maxGas");
    // } catch (e) {
    //   debugPrint("Error maxGas $e");
    // }
    
    // getMax(sender, txInfo);
    // BigInt gasPrice = BigInt.parse(ethereumTransaction.gasPrice ?? '0');
    // try {
    //   // final abiUrl =
    //   //     'https://api.polygonscan.com/api?module=contract&action=getabi&address=${ethereumTransaction.to}&apikey=BCER1MXNFHP1TVE93CMNVKC5J4FV8R4CPR';
    //   // final res = await http.get(Uri.parse(abiUrl));
    //   // final Map<String, dynamic> resMap = jsonDecode(res.body);
    //   // final abi = ContractAbi.fromJson(resMap['result'], '');
    //   // final contract = DeployedContract(
    //   //     abi, EthereumAddress.fromHex(ethereumTransaction.to!));
    //   // final dataBytes = hexToBytes(ethereumTransaction.data!);
    //   // final funcBytes = dataBytes.take(4).toList();
    //   // final maibiFunctions = contract.functions
    //   //     .where((element) => listEquals<int>(element.selector, funcBytes));
    //   // if (maibiFunctions.isNotEmpty) {
    //   //   // contractFunction.parameters.forEach((element) {
    //   //   //   debugPrint("params ${element.name} ${element.type.name}");
    //   //   // });
    //   //   // final params = dataBytes.sublist(4).toList();
    //   //   // debugPrint("params $params ${params.length}");
    //   // }
    //   if (gasPrice == BigInt.zero) {
    //     gasPrice = await contractPro!.bscClient.estimateGas();
    //   }
    // } catch (e, trace) {
    //   debugPrint(e);
    //   debugPrint(trace);
    // }

    debugPrint("lsWcClients $lsWcClients");

    Navigator.push(
      context!,
      Transition(
        child: ConfirmTrx(
          id: id,
          ethereumTransaction: ethereumTransaction,
          title: title,
          onConfirm: onConfirm,
          onReject: onReject,
          wcClient: wcClient,
          // peerMeta: peer,
        )
      )
    );

  }

  onSwitchNetwork(int id, int chainId) async {
    await wcClient.updateSession(chainId: chainId);
    wcClient.approveRequest<void>(id: id, result: null);
    ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      content: Text('Changed network to $chainId.'),
    ));
  }

  onSign(
    int id,
    WCEthereumSignMessage ethereumSignMessage,
  ) {
    debugPrint("on sign");
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context!,
      shape: const RoundedRectangleBorder( // <-- SEE HERE
        borderRadius: BorderRadius.vertical( 
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (wcClient.remotePeerMeta!.icons.isNotEmpty)
                  Container(
                    height: 100.0,
                    width: 100.0,
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.network(wcClient.remotePeerMeta!.icons.first),
                  ),
                ],
              ),

              const SizedBox(height: 10,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.zero,
                      title: const Text(
                        'Message',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      children: [
                        MyText(
                          text: "Welcome to ${wcClient.remotePeerMeta!.name}!",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),

                        const SizedBox(height: 10,),

                        MyText(
                          text: "Chain ID: ${wcClient.chainId}",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),

                        const SizedBox(height: 10,),

                        MyText(
                          text: "Wallet address:\n${ethereumSignMessage.raw[1]}",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),
                        
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ],
              ),
              
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
                        wcClient.rejectRequest(id: id);
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Expanded(
                    child: MyGradientButton(
                      edgeMargin: const EdgeInsets.all(paddingSize),
                      textButton: "Sign Message",
                      fontWeight: FontWeight.w400,
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      action: () async {
                        
                        String encryptKey = await StorageServices.readSecure(DbKey.private)!;

                        String resPin = await Navigator.push(context, Transition(child: const Pincode(label: PinCodeLabel.fromSendTx), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                        privateKey = await getPrivateKey(encryptKey, resPin, context: context);
                        
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
                          final encodedMessage = hexToBytes(ethereumSignMessage.data!);
                          final signedData = creds.signPersonalMessageToUint8List(encodedMessage);
                          signedDataHex = bytesToHex(signedData, include0x: true);
                        }
                        
                        wcClient.approveRequest<String>(
                          id: id,
                          result: signedDataHex,
                        );
                        
                        Navigator.pop(context);

                      },
                    ),
                
                  ),

                ],
              ),
            ],
          ),
        );
      }
    );
    
  }
  
  // ContractFunction _sendFunction() => contractPro!.bscClient .function('transfer');
  Transaction _wcEthTxToWeb3Tx(WCEthereumTransaction ethereumTransaction) {
    
    return Transaction(
      from: EthereumAddress.fromHex(ethereumTransaction.from),
      to: EthereumAddress.fromHex(ethereumTransaction.to!),
      // maxGas: getMaxGas
      // ethereumTransaction.gasLimit != null
      //     ? int.tryParse(ethereumTransaction.gasLimit!)
      //     : null,
      // gasPrice: ethereumTransaction.gasPrice != null
      //     ? EtherAmount.inWei(BigInt.parse(ethereumTransaction.gasPrice!))
      //     : null,
      // value: EtherAmount.inWei(BigInt.parse(ethereumTransaction.value ?? '0')),
      // data: hexToBytes(ethereumTransaction.data!),
      // nonce: ethereumTransaction.nonce != null
      //     ? int.tryParse(ethereumTransaction.nonce!)
      //     : null,
    );
  }
}