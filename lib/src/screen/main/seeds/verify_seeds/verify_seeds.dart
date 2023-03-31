import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/models/createkey_m.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/data_loading.dart';
import 'package:wallet_apps/src/screen/main/seeds/verify_seeds/body_verify_seeds.dart';
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
      if (kDebugMode) {
        print("animationController!.value ${_importAccountModel.animationController!.value}");
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
  }

  Future<void> importAcc() async {

    changeStatus("IMPORTING ACCOUNT", avg: "2/3");
    _importAccountModel.animationController!.forward(from: 0.2);
    
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

    changeStatus("CONNECT TO SELENDRA NETWORK", avg: "2/3");
    _importAccountModel.animationController!.forward(from: 0.2);

    await connectNetwork(widget.createKeyModel!.lsSeeds!.join(" "));
    
  }

  /// Return Boolean Value
  Future<bool> addNewAcc() async {
    print("addNewAcc");
    try {

      final jsn = await _apiProvider!.getSdk.api.keyring.importAccount(
        _apiProvider!.getKeyring, 
        keyType: KeyType.mnemonic, 
        key: widget.createKeyModel!.lsSeeds!.join(" "),
        name: 'User', 
        password: widget.createKeyModel!.passCode
      );

      print("jsn $jsn");

      await _apiProvider!.getSdk.api.keyring.addAccount(
        _apiProvider!.getKeyring, 
        keyType: KeyType.mnemonic, 
        acc: jsn!,
        password: widget.createKeyModel!.passCode
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

      final res = await _apiProvider!.encryptPrivateKey(resPk, "123");
      
      await StorageServices().writeSecure(DbKey.private, res);

      // Store PIN 6 Digit
      // await StorageServices().writeSecure(DbKey.passcode, _importAccModel.pwCon.text);

      await Future.delayed(const Duration(seconds: 2));

      changeStatus("GETTING READY", avg: "2/3");
      _importAccountModel.animationController!.forward(from: 0.5);

      if(!mounted) return;
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      if(!mounted) return;
      await _apiProvider!.queryBtcData(context, mnemonic, "123");

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
  
  Future<void> verifySeeds() async {

    dynamic res;
    ApiProvider api = Provider.of<ApiProvider>(context, listen: false);
    try {
      res = await api.validateMnemonic(widget.createKeyModel!.missingSeeds.join(" "));
      if (res == true){ 

        if(!mounted) return;

        if (widget.newAcc != null){
          print("widget.newAcc != null");
          await addNewAcc().then((value) async {
            if (value == true){

              Provider.of<ApiProvider>(context, listen: false).notifyListeners();
              
              Navigator.popUntil(context, ModalRoute.withName('/multipleWallets'));
              
            } else {
              await DialogComponents().dialogCustom(context: context, contents: "Something wrong");
            }
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

        // await Navigator.push(
        //   context, 
        //   Transition(
        //     child: FingerPrint(initStateData: initStateData, importAccountModel: _importAccountModel,),
        //     transitionEffect: TransitionEffect.RIGHT_TO_LEFT
        //   )
        // );
        
      }
      else{
        if(!mounted) return;
        await DialogComponents().dialogCustom(context: context, titles: "Oops", contents: "Your seeds verify is wrong.\nPlease try again!");
      }
    } catch (e) {
        if (kDebugMode) {
          print("Error validateMnemonic $e");
        }
      
    }
    return res;
  }

  Future<void> unVerifySeed() async {

    dialogLoading(context);

    await StorageServices().readSecure(DbKey.privateList)!.then((value) async {

      /// From Multi Account
      if(value.isNotEmpty){
        widget.createKeyModel!.seedList = CreateKeyModel().fromJsonDb(List<Map<String, dynamic>>.from(jsonDecode(value)));
      }

      /// From Welcome, Or From Multi Account
      widget.createKeyModel!.seedList.add(SeedStore(seed: widget.createKeyModel!.seed, status: false));

      await StorageServices().writeSecureList(DbKey.privateList, jsonEncode(widget.createKeyModel!.seedListToJson()));

    });
    
    await addNewAcc().then((value) async {
      if (value == true){

        Provider.of<ApiProvider>(context, listen: false).notifyListeners();
        
        Navigator.popUntil(context, ModalRoute.withName('/multipleWallets'));
        
      } else {
        await DialogComponents().dialogCustom(context: context, contents: "Something wrong");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return VerifyPassphraseBody(
      createKeyModel: widget.createKeyModel,
      submit: verifySeeds,
      submitUnverify: unVerifySeed,
      onTap: onTap,
      remove3Seeds: remove3Seeds
    );
  }
}
