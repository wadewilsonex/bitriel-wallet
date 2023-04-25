import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/createkey_m.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/src/provider/verify_seed_p.dart';
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

  final CreateKeyModel? createKeyModel = CreateKeyModel();

  final ImportAccAnimationModel _importAccountModel = ImportAccAnimationModel();
  ApiProvider? _apiProvider;
  ContractProvider? _contractProvider;
  
  String? _pk;

  bool? status;
  int? currentVersion;
  bool? enable = false;
  String? tempMnemonic;

  @override
  void initState() {

    debugPrint("widget.passCode ${widget.passCode}");

    _apiProvider = Provider.of<ApiProvider>(context, listen: false);
    _contractProvider = Provider.of<ContractProvider>(context, listen: false);

    AppServices.noInternetConnection(context: context);

    /// Create Or Add New Account in Accont Screen
    if (widget.passCode != null) {
      _importAccModel.pwCon!.text = widget.passCode!;
    } {
      StorageServices.readSecure(DbKey.pin)!.then((value) => _importAccModel.pwCon!.text = value );
    }
    super.initState();
  }

  String? onChanged(String value) {
    verifySeeds();
    return value;
  }

  void clearInput() {
    _importAccModel.key!.clear();
    setState(() {
      enable = false;
    });
  }

  void onSubmit() async {

    await Provider.of<ApiProvider>(context, listen: false).getSdk.api.keyring.addressFromMnemonic(204, mnemonic: _importAccModel.key!.text).then((value) async {


      List account = _apiProvider!.getKeyring.keyPairs.where((element) {
        if (value.address == element.address) return true;
        return false;
      }).toList();

      if (account.isNotEmpty) {
        enable = false;
        setState(() { });
        await DialogComponents().dialogCustom(
          context: context, 
          titles: "Oops", 
          contents: "This wallet mnemonic already exist.\nPlease try another mnemonic!",
          btn2: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: MyGradientButton(
              textButton: "Close",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: () => Navigator.pop(context),
            ),
          ),
        );
      } else if (enable == true){
        
  
        // New Account From Multi Account
        if (widget.isAddNew == true){

          dialogLoading(context);
          await addNewAcc(status: true).then((value) {
            ContractsBalance.getAllAssetBalance();
            
            // Close Dialog Loading
            Navigator.pop(context);

            Navigator.pop(context, value);

          });
        } else {

          if(!mounted) return;

    

          Navigator.push(
            context, 
            Transition(
              child: DataLoading(initStateData: initStateData, importAnimationAccModel: _importAccountModel,),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            )
          );
        }

      } else {
        await DialogComponents().dialogCustom(
          context: context, 
          titles: "Oops", 
          contents: "Your seed is invalid.\nPlease try again!",
          btn2: MyGradientButton(
            textButton: "OK",
            textColor: AppColors.lowWhite,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            action: () async {
              Navigator.pop(context);
            },
          )
        );
      }
    });
  }

  Future<void> onSubmitIm() async {
    
    Navigator.push(
      context,
      Transition(
        child: Authentication(
          initStateData: initStateData,
          importAccountModel: _importAccountModel,
        )
      )
    );
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
        if (kDebugMode) {
          debugPrint("Error validateMnemonic $e");
        }
    }
  }

  void initStateData(TickerProvider tickerProvider, Function mySetState) async {

    _importAccountModel.animationController = AnimationController(vsync: tickerProvider, duration: const Duration(seconds: 2));

    _importAccountModel.loadingMgs = "LOADING...";
    
    _importAccountModel.animation = Tween(
      begin: 0.0, end: 1.0
    ).animate(_importAccountModel.animationController!);  

    _importAccountModel.animationController!.addListener(() {
      if (kDebugMode) {
        debugPrint("_importAccountModel!.animationController!.value ${_importAccountModel.animationController!.value}");
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

    await importAcc();
    // importJson();
  }

  Future<void> importAcc() async { 
    
    changeStatus("IMPORTING ACCOUNT", avg: "1/3");
    
    await addAndImport();

    changeStatus("CONNECT TO SELENDRA NETWORK", avg: "2/3");
    _importAccountModel.animationController!.forward(from: 0.2);
    
    await connectNetwork();

  }

  Future<void> addAndImport() async {
    
    await StorageServices.readSecure(DbKey.privateList)!.then((value) async {

      if(value.isNotEmpty){
        createKeyModel!.unverifyList = CreateKeyModel().fromJsonDb(List<Map<String, dynamic>>.from(jsonDecode(value)));
      }

    });

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

    _pk = await _apiProvider!.getPrivateKey(_importAccModel.key!.text);
    
    // ignore: use_build_context_synchronously
    await Provider.of<ContractProvider>(context, listen: false).extractAddress(_pk!);


    // ignore: use_build_context_synchronously
    await _apiProvider!.queryBtcData(context, _importAccModel.key!.text, _importAccModel.pwCon!.text);

    createKeyModel!.unverifyList.add(
      UnverifySeed(
        address: jsn["address"],
        status: true,
        // ignore: use_build_context_synchronously
        ethAddress: Provider.of<ContractProvider>(context, listen: false).ethAdd,
        btcAddress: _contractProvider!.listContract[_apiProvider!.btcIndex].address
      )
    );

    await StorageServices.writeSecureList(DbKey.privateList, jsonEncode(createKeyModel!.unverifyListToJson()));

  }

  /// Return Boolean Value
  Future<bool> addNewAcc({required bool status}) async {

    try {
      await addAndImport();

      return true;

    } catch (e){
      debugPrint("Error addNewAcc $e");
      return false;
    }
  }

  Future<void> connectNetwork() async {
    
    /// Cannot connect Both Network On the Same time
    /// 
    /// It will be wrong data of that each connection. 
    /// 
    /// This Function Connect Polkadot Network And then Connect Selendra Network

    await _apiProvider!.getSelNativeChainDecimal(context: context); 
    // ignore: use_build_context_synchronously
    await _apiProvider!.subSELNativeBalance(context: context); 
    await _apiProvider!.getAddressIcon();
    // Get From Account js
    // await _apiProvider!.getCurrentAccount(context: context);


    final res = await _apiProvider!.encryptPrivateKey(_pk!, _importAccModel.pwCon!.text);
    
    await StorageServices.writeSecure(DbKey.private, res);

    changeStatus("GETTING READY", avg: "2/3");
    _importAccountModel.animationController!.forward(from: 0.5);

    if(!mounted) return;
    await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

    _importAccountModel.animationController!.forward(from: 8);
    changeStatus("DOWNLOAD ASSETS", avg: "3/4");
    await ContractsBalance.multipleAsset();

    _importAccountModel.animationController!.forward(from: 8);
    changeStatus("QUERY BALANCES", avg: "4/4");

    await ContractsBalance.getAllAssetBalance();

    changeStatus("READY", avg: "4/4");
    await Future.delayed(Duration(seconds: 1), (){});
    
    if(!mounted) return;
    Navigator.pushAndRemoveUntil(
      context, 
      Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
      ModalRoute.withName('/')
    );
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
