// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/constants/db_key_con.dart';
// import 'package:wallet_apps/src/models/import_acc_m.dart';
// import 'package:wallet_apps/src/provider/provider.dart';

// class DataQuery {

//   ImportAccountModel? _importAccountModel;
//   ApiProvider? _apiProvider;
//   BuildContext? context;

//   set setAccModel(ImportAccountModel model){
//     _importAccountModel = model;
//   }

//   set setApi(ApiProvider api){
//     _apiProvider = api;
//   }

//   void initStateData(TickerProvider tickerProvider, Function mySetState){
//     _importAccountModel!.loadingMgs = "LOADING...";
    
//     _importAccountModel!.animationController = AnimationController(vsync: tickerProvider, duration: const Duration(seconds: 2));

//     _importAccountModel!.animation = Tween(
//       begin: 0.0, end: 1.0
//     ).animate(_importAccountModel!.animationController!);  

//     _importAccountModel!.animationController!.addListener(() {
//       print("animationController!.value ${_importAccountModel!.animationController!.value}");

//       if (_importAccountModel!.animationController!.value >= 0.17 && _importAccountModel!.animationController!.value <= 0.19) {
        
//         _importAccountModel!.value = _importAccountModel!.animationController!.value;
//         _importAccountModel!.animationController!.stop();

//       } 

//       else if (_importAccountModel!.animationController!.value >= 0.47 && _importAccountModel!.animationController!.value <= 0.49) {
//         _importAccountModel!.value = _importAccountModel!.animationController!.value;
//         _importAccountModel!.animationController!.stop();
//       }

//       else if (_importAccountModel!.animationController!.value >= 0.77 && _importAccountModel!.animationController!.value <= 0.79) {
//         _importAccountModel!.value = _importAccountModel!.animationController!.value;
//         _importAccountModel!.animationController!.stop();
//       }

//       else if (_importAccountModel!.animationController!.value >= 0.85 && _importAccountModel!.animationController!.value <= 0.86) {
//         _importAccountModel!.value = _importAccountModel!.animationController!.value;
//         _importAccountModel!.animationController!.stop();
//       }
      
//       mySetState();

//     });

//     importAcc();
//   }

//   Future<void> importAcc() async {

//     await Future.delayed(const Duration(seconds: 1));

//     changeStatus("DECRYPTING ACCOUNT", avg: "1/4");
//     _importAccountModel!.animationController!.forward();    

//     // Execute JS
//     // await widget.webViewController!.callAsyncJavaScript(functionBody: "return await decrypt.decrypt(${widget.json!['user']['encrypted']}, '${widget.password}')").then((value) async {
//         print("finish DECRYPTING ACCOUNT");

//         await Future.delayed(const Duration(seconds: 2));
//         print("animationController ${_importAccountModel!.animationController!.value}");
        
//     //   if (value!.value != null){
//         changeStatus("IMPORTING ACCOUNT", avg: "2/4");
//         _importAccountModel!.animationController!.forward(from: 0.2);
        
//         // final jsn = await _api!.apiKeyring.importAccount(
//         //   _api!.getKeyring, 
//         //   keyType: KeyType.mnemonic, 
//         //   key: value.value,   
//         //   name: 'User', 
//         //   password: widget.password!
//         // );

//         // await _api!.apiKeyring.addAccount(
//         //   _api!.getKeyring, 
//         //   keyType: KeyType.mnemonic, 
//         //   acc: jsn!,
//         //   password: widget.password!
//         // );

//         // await connectNetwork(value.value);

//         await Future.delayed(const Duration(seconds: 2));

//         print("CONNECT TO SELENDRA NETWORK ${_importAccountModel!.animationController!.value}");

//         changeStatus("CONNECT TO SELENDRA NETWORK", avg: "3/4");
//         _importAccountModel!.animationController!.forward(from: 0.5);

//         await Future.delayed(const Duration(seconds: 2));
//         changeStatus("GETTING READ", avg: "4/4");
//         _importAccountModel!.animationController!.forward(from: 0.8);

//         await Future.delayed(const Duration(seconds: 2));
        
//         _importAccountModel!.animationController!.forward(from: 1);
//         changeStatus("DONE", avg: "4/4");

//         // if(!mounted) return;
//         // Navigator.pushAndRemoveUntil(
//         //   context, 
//         //   Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
//         //   ModalRoute.withName('/')
//         // );
        
//     //   }

//     // });
    
//   }

//   Future<void> connectNetwork(String mnemonic) async {
    
//     final resPk = await _apiProvider!.getPrivateKey(mnemonic);
    
//     /// Cannot connect Both Network On the Same time
//     /// 
//     /// It will be wrong data of that each connection. 
//     /// 
//     /// This Function Connect Polkadot Network And then Connect Selendra Network
    
//     changeStatus("CONNECT TO SELENDRA NETWORK", avg: "3/4");

//     await _apiProvider!.connectSELNode(context: context, funcName: "account").then((value) async {

//       await _apiProvider!.getAddressIcon();
//       // Get From Account js
//       await _apiProvider!.getCurrentAccount(context: context);

//       await ContractProvider().extractAddress(resPk);

//       final res = await _apiProvider!.encryptPrivateKey(resPk, "123");
      
//       await StorageServices().writeSecure(DbKey.private, res);

//       _importAccountModel!.animationController!.forward(from: 0.6);
//       changeStatus("FETCHING ASSETS", avg: "3/4");

//       // Store PIN 6 Digit
//       // await StorageServices().writeSecure(DbKey.passcode, _importAccModel.pwCon.text);

//       if(!mounted) return;
//       await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

//       if(!mounted) return;
//       await _apiProvider!.queryBtcData(context, mnemonic, "123");

//       _importAccountModel!.animationController!.forward(from: 0.9);
//       changeStatus("GETTING READY", avg: "4/4");

//       ContractsBalance().getAllAssetBalance();

      
//     }); 
//   }

//   void changeStatus(String? status, {String? avg}){
    
//     _importAccountModel!.average = avg;
//     _importAccountModel!.value = _importAccountModel!.value! + 0.333;
//     _importAccountModel!.loadingMgs = status;
//   }
// }