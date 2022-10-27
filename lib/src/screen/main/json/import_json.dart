import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';

class ImportJson extends StatefulWidget {

  final String? password;
  final Map<String, dynamic>? json;
  const ImportJson({Key? key, this.json, this.password}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImportJsonState();
  }
}

class ImportJsonState extends State<ImportJson> {

  final ImportAccModel _importAccModel = ImportAccModel();

  String? loadingMgs;

  bool? status;
  int? currentVersion;
  bool? enable = false;
  String? tempMnemonic;
  ApiProvider? _api;

  @override
  void initState() {
    print("password ${widget.password}");
    print("password ${widget.json}");
    loadingMgs = "Importing wallet";
    _api = Provider.of<ApiProvider>(context, listen: false);
    importAccFromJson();
    AppServices.noInternetConnection(context: context);
    // StorageServices().readSecure(DbKey.passcode)!.then((value) => _importAccModel.pwCon.text = value );
    super.initState();
  }

  String? onChanged(String value) {
    verifySeeds();
    return value;
  }

  Future<bool>? validateJson(String mnemonic) async {
    dynamic res;
    try {
      
      res = Provider.of<ApiProvider>(context, listen: false).apiKeyring;
      enable = res;
      
      setState((){});
    } catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error validateMnemonic $e");
        }
      }
    }
    return res;
  }

  void clearInput() {
    _importAccModel.mnemonicCon.clear();
    setState(() {
      enable = false;
    });
  }

  void onSubmit() async {
      /// EVM JSON
    await importAccFromJson();
    // if (enable == true){
    //   Navigator.push(
    //     context, 
    //     Transition(
        /// EVM JSON
    //       child: FingerPrint(importAccount: importAccFromJson,),
    //       transitionEffect: TransitionEffect.RIGHT_TO_LEFT
    //     )
    //   );
    // } else {
    //   await DialogComponents().dialogCustom(context: context, titles: "Oops", contents: "Your seeds is invalid.\nPlease try again!");
    // }
  }

  // Submit Mnemonic
  Future<void> submit() async {
    // try {
    //   if (_importAccModel.mnemonicCon.text.isNotEmpty){
    //     await validateMnemonic(_importAccModel.mnemonicCon.text)!.then((value) async {
    //       if (value) {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => ImportUserInfo(
    //               _importAccModel.mnemonicCon.text,
    //             ),
    //           ),
    //         );
    //       } else {

    //         await customDialog(context, 'Opps', 'Invalid seed phrases or mnemonic');
    //       }
    //     });
    //   } else {

    //   }
    // } catch (e) {
    //   if (ApiProvider().isDebug == true) print("Error submit $e");
    // }
  }

  Future<void> onSubmitIm() async {
    // if (_importAccModel.formKey.currentState!.validate()) {
    //   reImport();
    // }
  }

  Future<void> isDotContain() async {
    // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('DOT');
    // Provider.of<ApiProvider>(context, listen: false).isDotContain();
    await Provider.of<ApiProvider>(context, listen: false).connectPolNon(context: context);
  }

  Future<bool> checkPassword(String pin) async {
    final res = Provider.of<ApiProvider>(context, listen: false);
    bool checkPass = await res.apiKeyring.checkPassword(res.getKeyring.current, pin);
    return checkPass;
  }
  
  Future<void> verifySeeds() async {
    try {
      enable = await _api!.validateMnemonic(_importAccModel.mnemonicCon.text)!;
      setState(() { });
    } catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error validateMnemonic $e");
        }
      }
    }
  }

  /// EVM JSON
  Future<void> importAccFromJson() async {

    // Lottie.asset('assets/animation/blockchain-animation.json');
    // MyText(
    //   text: "Adding and fetching Wallet\n\nThis processing may take a bit longer\nPlease wait a moment",
    //   fontSize: 14.sp,
    //   color: AppColors.whiteColorHexa,
    // );

    print("widget.json!['encrypted'] ${widget.json!['user']['encrypted']}");

    setState(() {
      loadingMgs = "Decrypting Account";
    });
    await _api!.getSdk.webView!.evalJavascript('decrypt.decrypt(${widget.json!['user']['encrypted']}, "${widget.password}")').then((value) async {

      changeStatus("Importing account");
      print("hello");
      print("value['data'] $value");
      final jsn = await _api!.apiKeyring.importAccount(
        _api!.getKeyring, 
        keyType: KeyType.mnemonic, 
        key: value, 
        name: 'User', 
        password: widget.password!
      );

      await _api!.apiKeyring.addAccount(
        _api!.getKeyring, 
        keyType: KeyType.mnemonic, 
        acc: jsn!,
        password: widget.password!
      );

      changeStatus("Importing Assets and Tokens");

      await importAccountNAsset(_api!);
      
      await DialogComponents().dialogCustom(
        context: context,
        contents: "You have successfully create your account.",
        textButton: "Complete",
        image: Image.asset("assets/icons/success.png", width: 20.w, height: 10.h),
        btn2: MyGradientButton(
          edgeMargin: const EdgeInsets.only(left: 20, right: 20),
          textButton: "Complete",
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          action: () async {
            Navigator.pop(context);
          },
        )
      );

      if(!mounted) return;
      Navigator.pushAndRemoveUntil(
        context, 
        Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
        ModalRoute.withName('/')
      );
    });

    // final map = await json.decode(jsn);

    // // .getSdk.webView!.evalJavascript("""
    // //   keyring.recover(
    // //     '${KeyType.keystore.name}',
    // //     '${CryptoType.sr25519}',
    // //     '$jsn',
    // //     '123'
    // //   )
    // // """)
    // .then((value) async {
      
        /// EVM JSON
    //   await _api!.apiKeyring.importAccFromJson(
    //     _api!.getKeyring,
    //     keyType: KeyType.keystore,
    //     acc: value!,
    //     password: "123"//_importAccModel.pwCon.text,
    //   ).then((res) {
    //     print("res $res");
    //   });
    // });

    // .importAccount(
    //   _api!.getKeyring,
    //   keyType: KeyType.keystore,
    //   key: jsn,
    //   name: map['name'],
    //   password: "123"//_importAccModel.pwCon.text, 
    // );

    // await importAccountNAsset(_api!);
    
    // await DialogComponents().dialogCustom(
    //   context: context,
    //   contents: "You have successfully create your account.",
    //   textButton: "Complete",
    //   image: Image.asset("assets/icons/success.png", width: 20.w, height: 10.h),
    //   btn2: MyGradientButton(
    //     edgeMargin: const EdgeInsets.only(left: 20, right: 20),
    //     textButton: "Complete",
    //     begin: Alignment.bottomLeft,
    //     end: Alignment.topRight,
    //     action: () async {
    //       Navigator.pop(context);
    //     },
    //   )
    // );

    // if(!mounted) return;
    // Navigator.pushAndRemoveUntil(
    //   context, 
    //   Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
    //   ModalRoute.withName('/')
    // );
    
  }
  
  Future<void> importAccountNAsset(ApiProvider api) async {

    final resPk = await api.getPrivateKey(_importAccModel.mnemonicCon.text);

    /// Cannot connect Both Network On the Same time
    /// 
    /// It will be wrong data of that each connection. 
    /// 
    /// This Function Connect Polkadot Network And then Connect Selendra Network
    await api.connectSELNode(context: context, funcName: "account").then((value) async {

      await api.getAddressIcon();
      // Get From Account js
      await api.getCurrentAccount(context: context);

      await ContractProvider().extractAddress(resPk);

      final res = await api.encryptPrivateKey(resPk, _importAccModel.pwCon.text);
      
      await StorageServices().writeSecure(DbKey.private, res);

      // Store PIN 6 Digit
      // await StorageServices().writeSecure(DbKey.passcode, _importAccModel.pwCon.text);

      if(!mounted) return;
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      if(!mounted) return;
      await api.queryBtcData(context, _importAccModel.mnemonicCon.text, _importAccModel.pwCon.text);

      await ContractsBalance().getAllAssetBalance(context: context);
    }); 
  }

  void changeStatus(String? status){
    setState(() {
      loadingMgs = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            MyText(
              text: loadingMgs,
            )
          ],
        ),
      )
    );
  }
}
