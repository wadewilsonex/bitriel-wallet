import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class ImportJson extends StatefulWidget {

  final String? password;
  final Map<String, dynamic>? json;
  final InAppWebViewController? webViewController;

  const ImportJson({Key? key, this.json, this.password, required this.webViewController}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImportJsonState();
  }
}

class ImportJsonState extends State<ImportJson> with TickerProviderStateMixin {

  final ImportAccModel _importAccModel = ImportAccModel();

  String? loadingMgs;

  bool? status;
  int? currentVersion;
  bool? enable = false;
  String? tempMnemonic;
  ApiProvider? _api;

  Timer? _timer;

  AnimationController? animationController;

  Animation<double>? animation;
  
  double? value = 0.0;
  String? average = "0/4";

  @override
  void initState() {
    
    loadingMgs = "LOADING...";
    
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    animation = Tween(
      begin: 0.0, end: 1.0
    ).animate(animationController!);  

    animationController!.addListener(() {
      print("animationController!.value ${animationController!.value}");

      if (animationController!.value >= 0.17 && animationController!.value <= 0.19) {
        
        value = animationController!.value;
        animationController!.stop();

      } 

      else if (animationController!.value >= 0.47 && animationController!.value <= 0.49) {
        value = animationController!.value;
        animationController!.stop();
      }

      else if (animationController!.value >= 0.77 && animationController!.value <= 0.79) {
        value = animationController!.value;
        animationController!.stop();
      }

      else if (animationController!.value >= 0.85 && animationController!.value <= 0.86) {
        value = animationController!.value;
        animationController!.stop();
      }
      
      setState(() { });

    });

    _api = Provider.of<ApiProvider>(context, listen: false);

    importAccFromJson();

    AppServices.noInternetConnection(context: context);
    
    super.initState();

  }

  @override
  dispose(){
    animationController!.dispose();
    super.dispose();
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

  /// EVM JSON
  Future<void> importAccFromJson() async {

    await Future.delayed(const Duration(seconds: 1));

    changeStatus("DECRYPTING ACCOUNT", avg: "1/4");
    animationController!.forward();    

    // Execute JS
    // await widget.webViewController!.callAsyncJavaScript(functionBody: "return await decrypt.decrypt(${widget.json!['user']['encrypted']}, '${widget.password}')").then((value) async {
        print("finish DECRYPTING ACCOUNT");

        await Future.delayed(const Duration(seconds: 2));
        print("animationController ${animationController!.value}");
        
    //   if (value!.value != null){
        changeStatus("IMPORTING ACCOUNT", avg: "2/4");
        animationController!.forward(from: 0.2);
        
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

        // await importAccountNAsset(_api!, value.value);

        await Future.delayed(const Duration(seconds: 2));

        print("CONNECT TO SELENDRA NETWORK ${animationController!.value}");

        changeStatus("CONNECT TO SELENDRA NETWORK", avg: "3/4");
        animationController!.forward(from: 0.5);

        await Future.delayed(const Duration(seconds: 2));
        changeStatus("GETTING READ", avg: "4/4");
        animationController!.forward(from: 0.8);

        await Future.delayed(const Duration(seconds: 2));
        
        animationController!.forward(from: 1);
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
  
  Future<void> importAccountNAsset(ApiProvider api, String mnemonic) async {
    
    final resPk = await api.getPrivateKey(mnemonic);
    
    /// Cannot connect Both Network On the Same time
    /// 
    /// It will be wrong data of that each connection. 
    /// 
    /// This Function Connect Polkadot Network And then Connect Selendra Network
    
    changeStatus("CONNECT TO SELENDRA NETWORK", avg: "3/4");

    await api.connectSELNode(context: context, funcName: "account").then((value) async {

      await api.getAddressIcon();
      // Get From Account js
      await api.getCurrentAccount(context: context);

      await ContractProvider().extractAddress(resPk);

      final res = await api.encryptPrivateKey(resPk, _importAccModel.pwCon.text);
      
      await StorageServices().writeSecure(DbKey.private, res);

      animationController!.forward(from: 0.6);
      changeStatus("FETCHING ASSETS", avg: "3/4");

      // Store PIN 6 Digit
      // await StorageServices().writeSecure(DbKey.passcode, _importAccModel.pwCon.text);

      if(!mounted) return;
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      if(!mounted) return;
      await api.queryBtcData(context, _importAccModel.mnemonicCon.text, _importAccModel.pwCon.text);

      animationController!.forward(from: 0.9);
      changeStatus("GETTING READY", avg: "4/4");

      await ContractsBalance().getAllAssetBalance(context: context);

      
    }); 
  }

  void changeStatus(String? status, {String? avg}){
    
    if (mounted){
      
      setState(() {
        average = avg;
        value = value! + 0.333;
        loadingMgs = status;
      });
    } 
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
    
                Lottie.asset("${AppConfig.animationPath}data_center_loading.json", width: 70.w, height: 70.w),
    
                Container(
                  
                  child: AnimatedTextKit(
                    repeatForever: true,
                    pause: const Duration(seconds: 1),
                    animatedTexts: [
      
                      TypewriterAnimatedText(
                        loadingMgs!,
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
      
                    ],
                  ),
                ),
    
                Expanded(child: Container()),
    
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  child: LiquidLinearProgressIndicator(
                    borderRadius: 16,
                    value: animation!.value.toDouble(), // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(hexaCodeToColor(AppColors.primaryColor)), // Defaults to the current Theme's accentColor.
                    backgroundColor: Colors.grey, // Defaults to the current Theme's backgroundColor.
                    borderColor: Colors.white,
                    borderWidth: 5.0,
                    direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                    center: MyText(
                      fontSize: 15,
                      text: average ?? '..',
                      color2: Colors.white,
                    ),
                  ),
                ),
    
              ],
            ),
          ),
        )
      ),
    );
  }
}
