import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
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

  ImportAccountModel? _importAccountModel = ImportAccountModel();
  ApiProvider? _apiProvider;

  bool? status;
  int? currentVersion;
  bool? enable = false;
  String? tempMnemonic;

  @override
  void initState() {

    _apiProvider = Provider.of<ApiProvider>(context, listen: false);

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
      
      if (kDebugMode) {
        print("Error validateMnemonic $e");
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
          child: FingerPrint(initStateData: initStateData, importAccountModel: _importAccountModel,),
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
      enable = await _apiProvider!.validateMnemonic(_importAccModel.mnemonicCon.text)!;
      setState(() { });
    } catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error validateMnemonic $e");
        }
      }
    }
  }

  void initStateData(TickerProvider tickerProvider, Function mySetState){

    _importAccountModel!.animationController = AnimationController(vsync: tickerProvider, duration: const Duration(seconds: 2));

    _importAccountModel!.loadingMgs = "LOADING...";
    
    _importAccountModel!.animation = Tween(
      begin: 0.0, end: 1.0
    ).animate(_importAccountModel!.animationController!);  

    _importAccountModel!.animationController!.addListener(() {
      print("_importAccountModel!.animationController!.value ${_importAccountModel!.animationController!.value}");
      if (_importAccountModel!.animationController!.value >= 0.15 && _importAccountModel!.animationController!.value <= 0.19) {
        
        _importAccountModel!.value = _importAccountModel!.animationController!.value;
        _importAccountModel!.animationController!.stop();

      } 

      else if (_importAccountModel!.animationController!.value >= 0.40 && _importAccountModel!.animationController!.value <= 0.49) {
        
        _importAccountModel!.value = _importAccountModel!.animationController!.value;
        _importAccountModel!.animationController!.stop();
      }

      else if (_importAccountModel!.animationController!.value >= 0.75 && _importAccountModel!.animationController!.value <= 0.79) {
        
        _importAccountModel!.value = _importAccountModel!.animationController!.value;
        _importAccountModel!.animationController!.stop();
      }

      mySetState();

    });

    importAcc();
  }

  Future<void> importAcc() async { 
    
    changeStatus("IMPORTING ACCOUNT", avg: "1/3");
    
    final jsn = await _apiProvider!.apiKeyring.importAccount(
      _apiProvider!.getKeyring, 
      keyType: KeyType.mnemonic, 
      key: _importAccModel.mnemonicCon.text,   
      name: 'User', 
      password: _importAccModel.pwCon.text
    );

    await _apiProvider!.apiKeyring.addAccount(
      _apiProvider!.getKeyring, 
      keyType: KeyType.mnemonic, 
      acc: jsn!,
      password: _importAccModel.pwCon.text
    );

    changeStatus("CONNECT TO SELENDRA NETWORK", avg: "2/3");
    _importAccountModel!.animationController!.forward(from: 0.2);
    
    await connectNetwork(_importAccModel.mnemonicCon.text);

  }

  Future<void> connectNetwork(String mnemonic) async {
    
    final resPk = await _apiProvider!.getPrivateKey(mnemonic);
    
    /// Cannot connect Both Network On the Same time
    /// 
    /// It will be wrong data of that each connection. 
    /// 
    /// This Function Connect Polkadot Network And then Connect Selendra Network

    await _apiProvider!.connectSELNode(context: context, funcName: "account").then((value) async {

      await _apiProvider!.getAddressIcon();
      // Get From Account js
      await _apiProvider!.getCurrentAccount(context: context);

      await ContractProvider().extractAddress(resPk);

      final res = await _apiProvider!.encryptPrivateKey(resPk, _importAccModel.pwCon.text);
      
      await StorageServices().writeSecure(DbKey.private, res);

      // Store PIN 6 Digit
      // await StorageServices().writeSecure(DbKey.passcode, _importAccModel.pwCon.text);

      changeStatus("GETTING READY", avg: "2/3");
      _importAccountModel!.animationController!.forward(from: 0.5);

      if(!mounted) return;
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      if(!mounted) return;
      await _apiProvider!.queryBtcData(context, mnemonic, _importAccModel.pwCon.text);

      _importAccountModel!.animationController!.forward(from: 8);
      changeStatus("DONE", avg: "3/3");

      ContractsBalance().getAllAssetBalance();

      await Future.delayed(Duration(milliseconds: 3), (){});

      if(!mounted) return;
      Navigator.pushAndRemoveUntil(
        context, 
        Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
        ModalRoute.withName('/')
      );
    }); 
  }

  void changeStatus(String? status, {String? avg}){
    
    _importAccountModel!.average = avg;
    _importAccountModel!.value = _importAccountModel!.value! + 0.333;
    _importAccountModel!.loadingMgs = status;
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
          onSubmit: widget.reimport != null ? onSubmit : (){
            Navigator.push(
              context,
              Transition(
                child: FingerPrint(
                  initStateData: initStateData,
                  importAccountModel: _importAccountModel,
                )
              )
            );
          },
          clearInput: clearInput,
          enable: enable,
          submit: widget.reimport != null ? onSubmit : (){
            Navigator.push(
              context,
              Transition(
                child: FingerPrint(
                  initStateData: initStateData,
                  importAccountModel: _importAccountModel,
                )
              )
            );
          },
        ),
      )
    );
  }
}
