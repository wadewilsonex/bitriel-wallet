import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/main/data_loading.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SetPassword extends StatefulWidget {

  final String phoneNumber;
  final dynamic responseJson;
  const SetPassword({Key? key, required this.phoneNumber, this.responseJson}) : super(key: key);

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  // late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  
  ApiProvider? _apiProvider;

  final ImportAccountModel _importAccountModel = ImportAccountModel();

  @override
  initState(){

    _apiProvider = Provider.of<ApiProvider>(context, listen: false);
    super.initState();
  }

  Future<void> _registerWallet() async {
    
    try {

      Navigator.push(
        context, 
        Transition(
          child: DataLoading(
            importAccountModel: _importAccountModel,
            initStateData: initStateData,
          ), 
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT
        )
      );

      // final response = await PostRequest().registerSetPassword(widget.phoneNumber, password.text, confirmPassword.text);

      // final responseJson = json.decode(response.body);

      // if (response.statusCode == 200) {

      //   if(!mounted) return;
      //   // Navigator.push(context, Transition(child: OPTVerification(phoneNumber: getPhoneNumber), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          
      // }
      // else {
      //   if(!mounted) return;
      //   await customDialog(
      //     context, 
      //     "Error",
      //     responseJson['message']
      //   );
      // }

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void initStateData(TickerProvider tickerProvider, Function mySetState){
    
    _importAccountModel.loadingMgs = "LOADING...";
    
    _importAccountModel.animationController = AnimationController(vsync: tickerProvider, duration: const Duration(seconds: 2));

    _importAccountModel.animation = Tween(
      begin: 0.0, end: 1.0
    ).animate(_importAccountModel.animationController!);  

    _importAccountModel.animationController!.addListener(() {
      if (kDebugMode) {
        print("animationController!.value ${_importAccountModel.animationController!.value}");
      }

      if (_importAccountModel.animationController!.value >= 0.17 && _importAccountModel.animationController!.value <= 0.19) {
        
        _importAccountModel.value = _importAccountModel.animationController!.value;
        _importAccountModel.animationController!.stop();

      } 

      else if (_importAccountModel.animationController!.value >= 0.47 && _importAccountModel.animationController!.value <= 0.49) {
        _importAccountModel.value = _importAccountModel.animationController!.value;
        _importAccountModel.animationController!.stop();
      }

      else if (_importAccountModel.animationController!.value >= 0.77 && _importAccountModel.animationController!.value <= 0.79) {
        _importAccountModel.value = _importAccountModel.animationController!.value;
        _importAccountModel.animationController!.stop();
      }

      else if (_importAccountModel.animationController!.value >= 0.85 && _importAccountModel.animationController!.value <= 0.86) {
        _importAccountModel.value = _importAccountModel.animationController!.value;
        _importAccountModel.animationController!.stop();
      }
      
      mySetState();

    });

    importAcc();
  }

  Future<void> importAcc() async {

    await Future.delayed(const Duration(seconds: 1));

    changeStatus("DECRYPTING ACCOUNT", avg: "1/4");
    _importAccountModel.animationController!.forward();    

    // Execute JS
    // await widget.webViewController!.callAsyncJavaScript(functionBody: "return await decrypt.decrypt(${widget.json!['user']['encrypted']}, '${widget.password}')").then((value) async {
        if (kDebugMode) {
          print("finish DECRYPTING ACCOUNT");
        }

        await Future.delayed(const Duration(seconds: 2));
        if (kDebugMode) {
          print("animationController ${_importAccountModel.animationController!.value}");
        }
        
    //   if (value!.value != null){
        changeStatus("IMPORTING ACCOUNT", avg: "2/4");
        _importAccountModel.animationController!.forward(from: 0.2);
        
        // final jsn = await _api!.apiKeyring.importAccount(
        //   _api!.getKeyring, 
        //   keyType: KeyType.mnemonic, 
        //   key: value.value,   
        //   name: 'User', 
        //   password: widget.password!
        // );

        // await _api!.apiKeyring.addAccount(
        //   _api!.getKeyring, 
        //   keyType: KeyType.mnemonic, 
        //   acc: jsn!,
        //   password: widget.password!
        // );

        // await connectNetwork(value.value);

        await Future.delayed(const Duration(seconds: 2));

        if (kDebugMode) {
          print("CONNECT TO SELENDRA NETWORK ${_importAccountModel.animationController!.value}");
        }

        changeStatus("CONNECT TO SELENDRA NETWORK", avg: "3/4");
        _importAccountModel.animationController!.forward(from: 0.5);

        await Future.delayed(const Duration(seconds: 2));
        changeStatus("GETTING READ", avg: "4/4");
        _importAccountModel.animationController!.forward(from: 0.8);

        await Future.delayed(const Duration(seconds: 2));
        
        _importAccountModel.animationController!.forward(from: 1);
        changeStatus("DONE", avg: "4/4");

        // if(!mounted) return;
        // Navigator.pushAndRemoveUntil(
        //   context, 
        //   Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
        //   ModalRoute.withName('/')
        // );
        
    //   }

    // });
    
  }

  Future<void> connectNetwork(String mnemonic) async {
    
    final resPk = await _apiProvider!.getPrivateKey(mnemonic);
    
    /// Cannot connect Both Network On the Same time
    /// 
    /// It will be wrong data of that each connection. 
    /// 
    /// This Function Connect Polkadot Network And then Connect Selendra Network
    
    changeStatus("CONNECT TO SELENDRA NETWORK", avg: "3/4");

    await _apiProvider!.connectSELNode(context: context, funcName: "account").then((value) async {

      await _apiProvider!.getAddressIcon();
      // Get From Account js
      await _apiProvider!.getCurrentAccount(context: context);

      await ContractProvider().extractAddress(resPk);

      final res = await _apiProvider!.encryptPrivateKey(resPk, "123");
      
      await StorageServices().writeSecure(DbKey.private, res);

      _importAccountModel.animationController!.forward(from: 0.6);
      changeStatus("FETCHING ASSETS", avg: "3/4");

      // Store PIN 6 Digit
      // await StorageServices().writeSecure(DbKey.passcode, _importAccModel.pwCon.text);

      if(!mounted) return;
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      if(!mounted) return;
      await _apiProvider!.queryBtcData(context, mnemonic, "123");

      _importAccountModel.animationController!.forward(from: 0.9);
      changeStatus("GETTING READY", avg: "4/4");

      ContractsBalance().getAllAssetBalance();

      
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          color: hexaCodeToColor("#F2F2F2"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(paddingSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const MyText(
                text: "Set a password \nto encrypt your wallet",
                fontSize: 19,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
                top: 30,
                bottom: 30,
              ),
      
              tfPasswordWidget(password, "Password"),
              
              const SizedBox(height: 20),
      
              tfPasswordWidget(
                confirmPassword, "Confirm Password",
                onSubmit: _registerWallet
              ),
      
              Expanded(child: Container(),),
      
              MyGradientButton(
                textButton: "Finish",
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () {
                  _registerWallet();
                  // Navigator.push(context, Transition(child: OPTVerification(phoneNumber: getPhoneNumber), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}