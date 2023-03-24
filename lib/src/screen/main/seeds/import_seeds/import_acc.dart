import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/data_loading.dart';

class ImportAcc extends StatefulWidget {

  /// isBackBtn and isAddNew is from add new or create wallet
  final String? reimport;
  final bool? isBackBtn;
  final bool? isAddNew;
  final String? passCode;
  // ignore: invalid_required_named_param
  const ImportAcc({Key? key, this.reimport, @required this.isBackBtn = false, @required this.isAddNew = false, @required this.passCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImportAccState();
  }
}

class ImportAccState extends State<ImportAcc> {

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  final ImportAccModel _importAccModel = ImportAccModel();

  final ImportAccAnimationModel _importAccountModel = ImportAccAnimationModel();
  ApiProvider? _apiProvider;

  bool? status;
  int? currentVersion;
  bool? enable = false;
  String? tempMnemonic;

  @override
  void initState() {

    print("widget.passCode ${widget.passCode}");

    _apiProvider = Provider.of<ApiProvider>(context, listen: false);

    AppServices.noInternetConnection(context: context);

    /// Create Or Add New Account in Accont Screen
    if (widget.passCode != null) {
      _importAccModel.pwCon!.text = widget.passCode!;
    } {
      StorageServices().readSecure(DbKey.passcode)!.then((value) => _importAccModel.pwCon!.text = value );
    }
    super.initState();
  }

  String? onChanged(String value) {
    verifySeeds();
    return value;
  }

  Future<bool>? validateJson(String mnemonic) async {
    dynamic res;
    try {
      
      res = Provider.of<ApiProvider>(context, listen: false).getSdk.api.keyring;
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
    _importAccModel.key!.clear();
    setState(() {
      enable = false;
    });
  }

  void onSubmit() async {
    if (enable == true){

      if (widget.isAddNew == true){

        dialogLoading(context);
        await addNewAcc().then((value) {
          
          // Close Dialog Loading
          Navigator.pop(context);

          Navigator.pop(context, value);
        });
      } else {

        Navigator.push(
          context, 
          Transition(
            child: DataLoading(initStateData: initStateData, importAnimationAccModel: _importAccountModel,),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }

    } else {
      await DialogComponents().dialogCustom(context: context, titles: "Oops", contents: "Your seeds is invalid.\nPlease try again!");
    }
  }

  Future<void> onSubmitIm() async {
    // if(_importAccModel.formKey.currentState!.validate()){
      
    // }
    Navigator.push(
      context,
      Transition(
        child: FingerPrint(
          initStateData: initStateData,
          importAccountModel: _importAccountModel,
        )
      )
    );
  }

  Future<void> isDotContain() async {
    // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('DOT');
    // Provider.of<ApiProvider>(context, listen: false).isDotContain();
    // await Provider.of<ApiProvider>(context, listen: false).connectPolNon(context: context);
  }

  Future<bool> checkPassword(String pin) async {
    final res = Provider.of<ApiProvider>(context, listen: false);
    bool checkPass = await res.getSdk.api.keyring.checkPassword(res.getKeyring.current, pin);
    return checkPass;
  }
  
  Future<void> verifySeeds() async {
    try {
      enable = await _apiProvider!.validateMnemonic(_importAccModel.key!.text)!;
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

    _importAccountModel.animationController = AnimationController(vsync: tickerProvider, duration: const Duration(seconds: 2));

    _importAccountModel.loadingMgs = "LOADING...";
    
    _importAccountModel.animation = Tween(
      begin: 0.0, end: 1.0
    ).animate(_importAccountModel.animationController!);  

    _importAccountModel.animationController!.addListener(() {
      if (kDebugMode) {
        print("_importAccountModel!.animationController!.value ${_importAccountModel.animationController!.value}");
      }
      if (_importAccountModel.animationController!.value >= 0.15 && _importAccountModel.animationController!.value <= 0.19) {
        
        _importAccountModel.value = _importAccountModel.animationController!.value;
        _importAccountModel.animationController!.stop();

      } 

      else if (_importAccountModel.animationController!.value >= 0.40 && _importAccountModel.animationController!.value <= 0.49) {
        
        _importAccountModel.value = _importAccountModel.animationController!.value;
        _importAccountModel.animationController!.stop();
      }

      else if (_importAccountModel.animationController!.value >= 0.75 && _importAccountModel.animationController!.value <= 0.79) {
        
        _importAccountModel.value = _importAccountModel.animationController!.value;
        _importAccountModel.animationController!.stop();
      }

      mySetState();

    });

    importAcc();
    // importJson();
  }

  Future<void> importAcc() async { 
    
    changeStatus("IMPORTING ACCOUNT", avg: "1/3");
    
    final jsn = await _apiProvider!.getSdk.api.keyring.importAccount(
      _apiProvider!.getKeyring, 
      keyType: KeyType.mnemonic, 
      key: _importAccModel.key!.text,   
      name: 'User', 
      password: _importAccModel.pwCon!.text
    );

    await _apiProvider!.getSdk.api.keyring.addAccount(
      _apiProvider!.getKeyring, 
      keyType: KeyType.mnemonic, 
      acc: jsn!,
      password: _importAccModel.pwCon!.text
    );

    changeStatus("CONNECT TO SELENDRA NETWORK", avg: "2/3");
    _importAccountModel.animationController!.forward(from: 0.2);
    
    await connectNetwork(_importAccModel.key!.text);

  }

  Future<void> importJson() async { 
    
    try {
      changeStatus("IMPORTING ACCOUNT", avg: "1/3");
    
      final jsn = await _apiProvider!.getSdk.api.keyring.importAccount(
        _apiProvider!.getKeyring, 
        keyType: KeyType.keystore, 
        key: _importAccModel.key!.text,   
        name: 'User', 
        password: _importAccModel.pwCon!.text
      );

      print("jsn $jsn");

      await _apiProvider!.getSdk.api.keyring.addAccount(
        _apiProvider!.getKeyring, 
        keyType: KeyType.keystore, 
        acc: jsn!,
        password: _importAccModel.pwCon!.text
      );

      changeStatus("CONNECT TO SELENDRA NETWORK", avg: "2/3");
      _importAccountModel.animationController!.forward(from: 0.2);
    } catch (e) {
      if (kDebugMode){
        print("error importJson $e");
      }
    }
    
    await connectNetwork(_importAccModel.key!.text);

  }

  /// Return Boolean Value
  Future<bool> addNewAcc() async {
    print("_importAccModel.pwCon!.text ${_importAccModel.pwCon!.text}");
    print("_importAccModel.key!.text ${_importAccModel.key!.text}");
    print("addNewAcc");
    try {

      final jsn = await _apiProvider!.getSdk.api.keyring.importAccount(
        _apiProvider!.getKeyring, 
        keyType: KeyType.mnemonic, 
        key: _importAccModel.key!.text,   
        name: 'User', 
        password: _importAccModel.pwCon!.text
      );

      print("jsn $jsn");

      await _apiProvider!.getSdk.api.keyring.addAccount(
        _apiProvider!.getKeyring, 
        keyType: KeyType.mnemonic, 
        acc: jsn!,
        password: _importAccModel.pwCon!.text
      );

      print("added");
      return true;

    } catch (e){
      print("Error addNewAcc $e");
      return false;
    }
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
      // await _apiProvider!.getCurrentAccount(context: context);

      await ContractProvider().extractAddress(resPk);

      final res = await _apiProvider!.encryptPrivateKey(resPk, _importAccModel.pwCon!.text);
      
      await StorageServices().writeSecure(DbKey.private, res);

      // Store PIN 6 Digit
      // await StorageServices().writeSecure(DbKey.passcode, _importAccModel.pwCon!.text);

      changeStatus("GETTING READY", avg: "2/3");
      _importAccountModel.animationController!.forward(from: 0.5);

      if(!mounted) return;
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      if(!mounted) return;
      await _apiProvider!.queryBtcData(context, mnemonic, _importAccModel.pwCon!.text);

      _importAccountModel.animationController!.forward(from: 8);
      changeStatus("DONE", avg: "3/3");

      ContractsBalance().getAllAssetBalance();

      await Future.delayed(const Duration(milliseconds: 3), (){});

      if(!mounted) return;
      Navigator.pushAndRemoveUntil(
        context, 
        Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
        ModalRoute.withName('/')
      );
    }); 
  }

  void changeStatus(String? status, {String? avg}){
    
    _importAccountModel.average = avg;
    _importAccountModel.value = _importAccountModel.value! + 0.333;
    _importAccountModel.loadingMgs = status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isBackBtn! ? AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black,)
        ),
        elevation: 0,
      ) : null,
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
        ),
      )
    );
  }
}
