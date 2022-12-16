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

  ImportAccountModel? _importAccountModel = ImportAccountModel();

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

    _importAccountModel!.loadingMgs = "LOADING...";
    
    _importAccountModel!.animationController = AnimationController(vsync: tickerProvider, duration: const Duration(seconds: 2));

    _importAccountModel!.animation = Tween(
      begin: 0.0, end: 1.0
    ).animate(_importAccountModel!.animationController!);  

    _importAccountModel!.animationController!.addListener(() {
      print("animationController!.value ${_importAccountModel!.animationController!.value}");

      if (_importAccountModel!.animationController!.value >= 0.17 && _importAccountModel!.animationController!.value <= 0.19) {
        
        _importAccountModel!.value = _importAccountModel!.animationController!.value;
        _importAccountModel!.animationController!.stop();

      } 

      else if (_importAccountModel!.animationController!.value >= 0.37 && _importAccountModel!.animationController!.value <= 0.39) {
        _importAccountModel!.value = _importAccountModel!.animationController!.value;
        _importAccountModel!.animationController!.stop();
      }

      else if (_importAccountModel!.animationController!.value >= 0.77 && _importAccountModel!.animationController!.value <= 0.79) {
        _importAccountModel!.value = _importAccountModel!.animationController!.value;
        _importAccountModel!.animationController!.stop();
      }

      else if (_importAccountModel!.animationController!.value >= 0.85 && _importAccountModel!.animationController!.value <= 0.86) {
        _importAccountModel!.value = _importAccountModel!.animationController!.value;
        _importAccountModel!.animationController!.stop();
      }
      
      mySetState();

    });

    importAcc();
  }

  Future<void> importAcc() async {

    changeStatus("DECRYPTING ACCOUNT", avg: "1/4");
    _importAccountModel!.animationController!.forward();    

    print("finish DECRYPTING ACCOUNT");

    await Future.delayed(const Duration(seconds: 2));
    print("animationController ${_importAccountModel!.animationController!.value}");
    
    changeStatus("IMPORTING ACCOUNT", avg: "2/4");
    _importAccountModel!.animationController!.forward(from: 0.2);
    
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

    changeStatus("CONNECT TO SELENDRA NETWORK", avg: "3/4");
    _importAccountModel!.animationController!.forward(from: 0.5);

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

      _importAccountModel!.animationController!.forward(from: 0.6);
      changeStatus("FETCHING ASSETS", avg: "3/4");

      // Store PIN 6 Digit
      // await StorageServices().writeSecure(DbKey.passcode, _importAccModel.pwCon.text);

      if(!mounted) return;
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      if(!mounted) return;
      await _apiProvider!.queryBtcData(context, mnemonic, "123");

      _importAccountModel!.animationController!.forward(from: 0.9);
      changeStatus("GETTING READY", avg: "4/4");

      ContractsBalance().getAllAssetBalance();

      
    }); 
  }

  void changeStatus(String? status, {String? avg}){
    
    _importAccountModel!.average = avg;
    _importAccountModel!.value = _importAccountModel!.value! + 0.333;
    _importAccountModel!.loadingMgs = status;
  }
  
  Future<void> verifySeeds() async {
    dynamic res;
    ApiProvider api = Provider.of<ApiProvider>(context, listen: false);
    try {
      res = await api.validateMnemonic(widget.createKeyModel!.missingSeeds.join(" "));
      if (res == true){ 

        if(!mounted) return;

        dialogLoading(context, content: "Fetching and adding asset\n\nThis processing may take a bit longer\nPlease wait a moment");

        dynamic json = await api.apiKeyring.importAccount(
          api.getKeyring,
          keyType: KeyType.mnemonic,
          key: widget.createKeyModel!.lsSeeds!.join(" "),
          name: "User",
          password: widget.createKeyModel!.passCode, 
        );
        
        await api.apiKeyring.addAccount(
          api.getKeyring,
          keyType: KeyType.mnemonic,
          acc: json,
          password: widget.createKeyModel!.passCode,
        );

        await importAccountNAsset(api);
        
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

        if(!mounted) return;
        Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
          ModalRoute.withName('/')
        );
      }
      else{
        
        await DialogComponents().dialogCustom(
          context: context,
          titles: "Opps",
          contents: "Invalid seeds spot. Please try again!",
          textButton: "Close",
          btn2: MyGradientButton(
            edgeMargin: const EdgeInsets.only(left: 20, right: 20),
            textButton: "Close",
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
        print("Error validateMnemonic $e");
      }
    }
    return res;
  }
  
  Future<void> importAccountNAsset(ApiProvider api) async {

    final resPk = await api.getPrivateKey(widget.createKeyModel!.lsSeeds!.join(" "));

    /// Cannot connect Both Network On the Same time
    /// 
    /// It will be wrong data of that each connection. 
    /// 
    /// This Function Connect Polkadot Network And then Connect Selendra Network
    await api.connectSELNode(context: context).then((value) async {

      await api.getAddressIcon();
      // Get From Account js
      await api.getCurrentAccount(context: context);

      await ContractProvider().extractAddress(resPk);

      final res = await api.encryptPrivateKey(resPk, widget.createKeyModel!.passCode);
      
      // Store Private Key with Encrypt With PassCode Or PIN.
      await StorageServices().writeSecure(DbKey.private, res);

      // Store PIN 6 Digit
      await StorageServices().writeSecure(DbKey.passcode, widget.createKeyModel!.passCode);

      if(!mounted) return;
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      if(!mounted) return;
      await api.queryBtcData(context, widget.createKeyModel!.lsSeeds!.join(" "), widget.createKeyModel!.passCode);

      await ContractsBalance().getAllAssetBalance();
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return VerifyPassphraseBody(
      createKeyModel: widget.createKeyModel,
      submit: () async {
        await Navigator.push(
          context, 
          Transition(
            child: FingerPrint(initStateData: initStateData, importAccountModel: _importAccountModel,),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      },
      onTap: onTap,
      remove3Seeds: remove3Seeds
    );
  }
}
