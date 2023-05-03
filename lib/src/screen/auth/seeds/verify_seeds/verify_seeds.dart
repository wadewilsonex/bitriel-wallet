import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/models/createkey_m.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/provider/verify_seed_p.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/auth/data_loading.dart';
import 'package:wallet_apps/src/screen/auth/seeds/verify_seeds/body_verify_seeds.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';

class VerifyPassphrase extends StatefulWidget {

  final CreateKeyModel? createKeyModel;
  final NewAccount? newAcc;
  
  const VerifyPassphrase({Key? key, this.createKeyModel, @required this.newAcc}) : super(key: key);

  @override
  State<VerifyPassphrase> createState() => VerifyPassphraseState();
}

class VerifyPassphraseState extends State<VerifyPassphrase> {
  
  ApiProvider? _apiProvider;

  final ImportAccAnimationModel _importAccountModel = ImportAccAnimationModel();

  ContractProvider? conProvider;

  String? _pk;

  void remove3Seeds() {

    widget.createKeyModel!.missingSeeds = [];
    widget.createKeyModel!.tmpThreeNum = [];

    // Add Origin Three Number To tmpThreeNum
    for (var element in widget.createKeyModel!.threeNum!) {
      widget.createKeyModel!.tmpThreeNum!.addAll({element});
    }

    // Add Origin lsSeeds To tmpThreeNum
    for (var element in widget.createKeyModel!.lsSeeds!) {
      widget.createKeyModel!.missingSeeds.add(element);
    }

    // Replace match index with Empty
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![0])] = "";
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![1])] = "";
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![2])] = "";

    widget.createKeyModel!.tmpSeed = widget.createKeyModel!.missingSeeds.join(" ");
    setState(() { });
  }

  @override
  void initState() {

    _apiProvider = Provider.of<ApiProvider>(context, listen: false);
    conProvider = Provider.of<ContractProvider>(context, listen: false);

    AppServices.noInternetConnection(context: context);
    remove3Seeds();
    super.initState();
  }

  @override
  void dispose() {
    
    widget.createKeyModel!.missingSeeds = [];
    widget.createKeyModel!.tmpThreeNum = [];

    super.dispose();
  }

  void onTap(index, rmIndex){
    
    for(int i = 0; i < widget.createKeyModel!.missingSeeds.length; i++){
      if (widget.createKeyModel!.missingSeeds[i] == ""){
        widget.createKeyModel!.missingSeeds[i] = widget.createKeyModel!.lsSeeds![index];
        break;
      }
    }
    widget.createKeyModel!.tmpSeed = widget.createKeyModel!.missingSeeds.join(" ");
    widget.createKeyModel!.tmpThreeNum!.removeAt(rmIndex);
    setState(() { });

  }
  void initStateData(TickerProvider tickerProvider, Function mySetState){

    _importAccountModel.animationController = AnimationController(vsync: tickerProvider, duration: const Duration(seconds: 2));
    
    _importAccountModel.loadingMgs = "LOADING...";

    _importAccountModel.animation = Tween(
      begin: 0.0, end: 1.0
    ).animate(_importAccountModel.animationController!);  

    _importAccountModel.animationController!.addListener(() {

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
  }

  Future<void> importAcc() async {

    changeStatus("IMPORTING ACCOUNT", avg: "1/3");
    
    await addAndImport();

    changeStatus("CONNECT TO SELENDRA NETWORK", avg: "2/3");
    _importAccountModel.animationController!.forward(from: 0.2);
    
    await connectNetwork();
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

    final res = await _apiProvider!.encryptPrivateKey(_pk!, widget.createKeyModel!.lsSeeds!.join(" "));
    
    await StorageServices.writeSecure(DbKey.private, res);

    // Store PIN 6 Digit
    // await StorageServices.writeSecure(DbKey.passcode, _importAccModel.pwCon!.text);

    changeStatus("GETTING READY", avg: "2/3");
    _importAccountModel.animationController!.forward(from: 0.5);

    if(!mounted) return;
    await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

    _importAccountModel.animationController!.forward(from: 8);
    changeStatus("READY", avg: "3/3");

    await ContractsBalance.getAllAssetBalance();

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

  /// Condition Inside verifyLater Below
  /// 
  /// Is Use For Routing To Home Page Or Just Stay At Multi Account After Finish

  Future<void> verifyLater() async {

    _importAccountModel.status = false;

    /// From Multi Account
    if (widget.newAcc != null){

      dialogLoading(context);

      await addAndImport();
      
      Provider.of<ApiProvider>(context, listen: false).notifyListeners();
          
      Navigator.popUntil(context, ModalRoute.withName('/multipleWallets'));
    }

    /// From Onboading Page Create New
    else {

      if(!mounted) return;
      
      Navigator.push(
        context, 
        Transition(
          child: DataLoading(initStateData: initStateData, importAnimationAccModel: _importAccountModel,),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT
        )
      );
    }

  }

  
  Future<void> addAndImport() async {

    await StorageServices.readSecure(DbKey.privateList)!.then((value) async {

      if(value.isNotEmpty){
        widget.createKeyModel!.unverifyList = CreateKeyModel().fromJsonDb(List<Map<String, dynamic>>.from(jsonDecode(value)));
      }

    });

    final jsn = await _apiProvider!.getSdk.api.keyring.importAccount(
      _apiProvider!.getKeyring, 
      keyType: KeyType.mnemonic, 
      key: widget.createKeyModel!.lsSeeds!.join(" "),   
      name: 'User', 
      password: widget.createKeyModel!.passCode
    );

    await _apiProvider!.getSdk.api.keyring.addAccount(
      _apiProvider!.getKeyring, 
      keyType: KeyType.mnemonic, 
      acc: jsn!,
      password: widget.createKeyModel!.passCode
    );

    _pk = await _apiProvider!.getPrivateKey(widget.createKeyModel!.lsSeeds!.join(" "));
    // ignore: use_build_context_synchronously
    await Provider.of<ContractProvider>(context, listen: false).extractAddress(_pk!);

    // ignore: use_build_context_synchronously
    await _apiProvider!.queryBtcData(context, widget.createKeyModel!.lsSeeds!.join(" "), widget.createKeyModel!.passCode);

    widget.createKeyModel!.unverifyList.add(
      UnverifySeed(address: jsn["address"],
      status: _importAccountModel.status, 
      ethAddress: Provider.of<ContractProvider>(context, listen: false).ethAdd,
      btcAddress: conProvider!.listContract[_apiProvider!.btcIndex].address
    ));

    await StorageServices.writeSecureList(DbKey.privateList, jsonEncode(widget.createKeyModel!.unverifyListToJson()));

    ContractsBalance.getAllAssetBalance();

  }
  
  Future<void> verifySeeds() async {

    dynamic res;
    ApiProvider api = Provider.of<ApiProvider>(context, listen: false);

    conProvider = Provider.of<ContractProvider>(context, listen: false);

    try {

      res = await api.validateMnemonic(widget.createKeyModel!.missingSeeds.join(" "));
      if (res == true){ 

        if(!mounted) return;

        dialogLoading(context);

        /// From Multiple Account
        if (widget.newAcc != null){
          
          await addAndImport();
          
          await ContractsBalance.getAllAssetBalance();

          Provider.of<ApiProvider>(context, listen: false).notifyListeners();
          
          Navigator.popUntil(context, ModalRoute.withName('/multipleWallets'));

        }
        /// From Wallet Home Screen
        /// 
        /// User Attempting To Verify Account
        else {

          if (Provider.of<VerifySeedsProvider>(context, listen: false).isVerifying == true){

            await StorageServices.readSecure(DbKey.privateList)!.then((value) async {

              /// From Multi Account
              if(value.isNotEmpty){
                widget.createKeyModel!.unverifyList = CreateKeyModel().fromJsonDb(List<Map<String, dynamic>>.from(jsonDecode(value)));
              }
              
              List<UnverifySeed> tmp = CreateKeyModel().fromJsonDb(List<Map<String, dynamic>>.from(jsonDecode(value)));

              List<UnverifySeed> obj = tmp.where((element) {
                if (element.address == api.getKeyring.current.address) return true; 
                return false;
              }).toList();

              // debugPrint("Obj found ${obj[0].address}");
              // int indexOfVerifyingSeed = tmp.indexOf(obj[0]);

              /// From Welcome, Or From Multi Account
              widget.createKeyModel!.unverifyList[tmp.indexOf(obj[0])] = UnverifySeed(
                address: api.getKeyring.current.address, 
                status: true, 
                ethAddress: conProvider!.ethAdd,
                btcAddress: conProvider!.listContract[_apiProvider!.btcIndex].address
              );

              // addAndImport

              await StorageServices.writeSecureList(DbKey.privateList, jsonEncode(widget.createKeyModel!.unverifyListToJson()));

              Provider.of<VerifySeedsProvider>(context, listen: false).getPrivateList[ tmp.indexOf(obj[0]) ] = UnverifySeed(
                address: api.getKeyring.current.address, status: true, ethAddress: conProvider!.ethAdd, btcAddress: conProvider!.listContract[_apiProvider!.btcIndex].address
              ).toMap();

              Provider.of<VerifySeedsProvider>(context, listen: false).unverifyAcc = UnverifySeed(
                address: api.getKeyring.current.address, status: true, ethAddress: conProvider!.ethAdd, btcAddress: conProvider!.listContract[_apiProvider!.btcIndex].address
              ).toMap();
              
              Provider.of<VerifySeedsProvider>(context, listen: false).isVerifying = false;

              Provider.of<VerifySeedsProvider>(context, listen: false).notifyListeners();
              
              Navigator.popUntil(context, ModalRoute.withName(AppString.homeView));

            });
            
          }

          // For Create New Account From Welcome
          else {

            Navigator.push(
              context, 
              Transition(
                child: DataLoading(initStateData: initStateData, importAnimationAccModel: _importAccountModel,),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT
              )
            );

          }
        }
      }
      else{

        if(!mounted) return;
        await DialogComponents().dialogCustom(
          context: context, 
          titles: "Oops", 
          contents: "Your seed verify is wrong.\nPlease try again!",
          btn2: MyGradientButton(
            textButton: "Close",
            textColor: AppColors.lowWhite,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            action: () async {
              Navigator.pop(context);
            },
          )
        );

      }
    } catch (e) {
      
      if (kDebugMode) {
      }
      
    }
    return res;
  }
  @override
  Widget build(BuildContext context) {
    return VerifyPassphraseBody(
      createKeyModel: widget.createKeyModel,
      submit: verifySeeds,
      submitUnverify: verifyLater,
      onTap: onTap,
      remove3Seeds: remove3Seeds
    );
  }
}
