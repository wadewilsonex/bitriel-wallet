import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';

class ImportAcc extends StatefulWidget {
  final String? reimport;
  const ImportAcc({Key? key, this.reimport}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImportAccState();
  }
}

class ImportAccState extends State<ImportAcc> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  final ImportAccModel _importAccModel = ImportAccModel();

  bool? status;
  int? currentVersion;
  bool? enable = false;
  String? tempMnemonic;
  ApiProvider? _api;

  @override
  void initState() {
    _api = Provider.of<ApiProvider>(context, listen: false);
    AppServices.noInternetConnection(context: context);
    StorageServices().readSecure(DbKey.passcode)!.then((value) => _importAccModel.pwCon.text = value );
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
    if (enable == true){
      Navigator.push(
        context, 
        Transition(
          child: FingerPrint(importAccount: addAccount,),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT
        )
      );
    } else {
      await DialogComponents().dialogCustom(context: context, titles: "Oops", contents: "Your seeds is invalid.\nPlease try again!");
    }
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

  Future<void> addAccount() async {

    // Lottie.asset('assets/animation/blockchain-animation.json');
    // MyText(
    //   text: "Adding and fetching Wallet\n\nThis processing may take a bit longer\nPlease wait a moment",
    //   fontSize: 14.sp,
    //   color: AppColors.whiteColorHexa,
    // );
    
    dialogLoading(context, content: "Fetching and adding asset\n\nThis processing may take a bit longer\nPlease wait a moment");

    dynamic json = await _api!.apiKeyring.importAccount(
      _api!.getKeyring,
      keyType: KeyType.mnemonic,
      key: _importAccModel.mnemonicCon.text,
      name: "User",
      password: _importAccModel.pwCon.text, 
    );
    
    await _api!.apiKeyring.addAccount(
      _api!.getKeyring,
      keyType: KeyType.mnemonic,
      acc: json,
      password: _importAccModel.pwCon.text,
    );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ImportAccBody(
          reImport: widget.reimport,
          importAccModel: _importAccModel,
          onChanged: onChanged,
          onSubmit: widget.reimport != null ? onSubmitIm : onSubmit,
          clearInput: clearInput,
          enable: enable,
          submit: widget.reimport != null ? onSubmitIm : addAccount,
        ),
      )
    );
  }
}
