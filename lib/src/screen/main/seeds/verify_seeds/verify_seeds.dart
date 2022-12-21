import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/createkey_m.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/seeds/verify_seeds/body_verify_seeds.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';

class VerifyPassphrase extends StatefulWidget {

  final CreateKeyModel? createKeyModel;
  
  const VerifyPassphrase({Key? key, this.createKeyModel}) : super(key: key);

  @override
  State<VerifyPassphrase> createState() => VerifyPassphraseState();
}

class VerifyPassphraseState extends State<VerifyPassphrase> {
  
  ApiProvider? _apiProvider;

  final ImportAccountModel _importAccountModel = ImportAccountModel();

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
    // widget.createKeyModel!.empty();

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

    changeStatus("IMPORTING ACCOUNT", avg: "2/4");
    _importAccountModel.animationController!.forward(from: 0.2);
    
    final jsn = await _apiProvider!.apiKeyring.importAccount(
      _apiProvider!.getKeyring, 
      keyType: KeyType.mnemonic, 
      key: widget.createKeyModel!.lsSeeds!.join(" "),   
      name: 'User', 
      password: widget.createKeyModel!.passCode
    );

    await _apiProvider!.apiKeyring.addAccount(
      _apiProvider!.getKeyring, 
      keyType: KeyType.mnemonic, 
      acc: jsn!,
      password: widget.createKeyModel!.passCode
    );

    changeStatus("CONNECT TO SELENDRA NETWORK", avg: "2/3");
    _importAccountModel.animationController!.forward(from: 0.2);

    await connectNetwork(widget.createKeyModel!.lsSeeds!.join(" "));
    
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
        await Navigator.push(
          context, 
          Transition(
            child: FingerPrint(initStateData: initStateData, importAccountModel: _importAccountModel,),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
        
      }
      else{
        await DialogComponents().dialogCustom(context: context, titles: "Oops", contents: "Your seeds verify is wrong.\nPlease try again!");
      }
    } catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error validateMnemonic $e");
        }
      }
    }
    return res;
  }


  @override
  Widget build(BuildContext context) {
    return VerifyPassphraseBody(
      createKeyModel: widget.createKeyModel,
      submit: verifySeeds,
      onTap: onTap,
      remove3Seeds: remove3Seeds
    );
  }
}
