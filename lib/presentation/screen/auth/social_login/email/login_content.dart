// import 'package:http/http.dart';
// import 'package:form_validation/form_validation.dart';
// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/components/login_component/animations/change_screen_animation.dart';
// import 'package:wallet_apps/src/components/login_component/helper_functions.dart';
// import 'package:wallet_apps/src/components/registration/head_title_c.dart';
// import 'package:wallet_apps/src/constants/db_key_con.dart';
// import 'package:wallet_apps/src/models/email_m.dart';
// import 'package:wallet_apps/src/models/import_acc_m.dart';
// import 'package:wallet_apps/src/provider/headless_webview_p.dart';
// import 'package:wallet_apps/src/provider/provider.dart';
// import 'package:wallet_apps/src/screen/main/data_loading.dart';

// enum Screens {
//   createAccount,
//   welcomeBack,
// }

// class LoginContent extends StatefulWidget {
//   const LoginContent({Key? key}) : super(key: key);

//   @override
//   State<LoginContent> createState() => _LoginContentState();
// }

// class _LoginContentState extends State<LoginContent> with TickerProviderStateMixin {
  
//   late final List<Widget> loginContent;
//   late final List<Widget> createAccountContent;

//   final ImportAccountModel _importAccountModel = ImportAccountModel();
//   ApiProvider? _apiProvider;
  
//   final EmailModel _model = EmailModel();
//   ChangeScreenAnimation animationS = ChangeScreenAnimation();

//   Future<void> login() async {

//     // if (_model.getFmKey.currentState!.validate()){
//       await _decryptDataLogin();
//     // }
    
//   }

//   Future<void> _decryptDataLogin() async {

//     if (kDebugMode) {
//       debugPrint("Provider.of<HeadlessWebView>(context, listen: false).headlessWebView!.isRunning() ${Provider.of<HeadlessWebView>(context, listen: false).headlessWebView!.isRunning()}");
//     }

//     try {

//       // Verify OTP with HTTPs
      
//       Response response = Response(await rootBundle.loadString('assets/json/phone.json'), 200);

//       final responseJson = json.decode(response.body);

//       if (kDebugMode) {
//         debugPrint("responseJson $responseJson");
//       }

//       if (response.statusCode == 200) {

//         if (responseJson['user'].containsKey("encrypted")){

//           if(!mounted) return;
//           Navigator.push(
//             context, 
//             Transition(
//               child: const DataLoading(
//                 // json: responseJson, 
//                 // password: "123",
//                 // webViewController: Provider.of<HeadlessWebView>(context, listen: false).headlessWebView!.webViewController,
//               ), 
//               transitionEffect: TransitionEffect.RIGHT_TO_LEFT
//             )
//           );
//         }
          
//       } else if (response.statusCode == 401) {

//         if(!mounted) return;
//         customDialog(
//           context, 
//           "Error",
//           responseJson['message']
//         );

//         if(!mounted) return;
//         Navigator.of(context).pop();

//       } else if (response.statusCode >= 500 && response.statusCode < 600) {

//         if(!mounted) return;
//         customDialog(
//           context, 
//           "Error",
//           responseJson['message']
//         );

//         if(!mounted) return;
//         Navigator.of(context).pop();

//       }

//     } catch (e) {
//       if (kDebugMode) {
//         debugPrint(e);
//       }
//     }
//   }


//   Widget _loginButton(String title) {
//     if (kDebugMode) {
//       debugPrint("_loginButton");
//     }
//     return MyGradientButton(
//       edgeMargin: const EdgeInsets.all(paddingSize),
//       textButton: title,
//       begin: Alignment.bottomLeft,
//       end: Alignment.topRight,
//       action: () {
//         login();
//       },
//     );
//   }

//   @override
//   void initState() {

//     _apiProvider = Provider.of<ApiProvider>(context, listen: false);
    
//     loginContent = [

//       myInputWidget(
//         context: context,
//         controller: _model.email,
//         hintText: "Email",
//         validator: (value) {
//           return Validator(
//             validators: [
//               RequiredValidator(),
//               EmailValidator()
//             ],
//           ).validate(
//             context: context,
//             label: 'Email',
//             value: value,
//           );
//         },
//       ),

//       // myInputWidget(
//       //   context: context,
//       //   controller: _model.password,
//       //   hintText: "Password",
//       //   validator: (value) {
//       //     return Validator(
//       //       validators: [
//       //         RequiredValidator(),
//       //         MinLengthValidator(length: 8),
//       //       ],
//       //     ).validate(
//       //       context: context,
//       //       label: 'Password',
//       //       value: value,
//       //     );
//       //   },
//       // ),

//       // myInputWidget(
//       //   context: context,
//       //   controller: _model.confirmPassword,
//       //   hintText: "Confirm Password",
//       //   validator: (value) {
//       //     return Validator(
//       //       validators: [
//       //         RequiredValidator(),
//       //         MinLengthValidator(length: 8),
//       //       ],
//       //     ).validate(
//       //       context: context,
//       //       label: 'Password',
//       //       value: value,
//       //     );
//       //   },
//       // ),

//       _loginButton("Login"),
//     ];


//     createAccountContent = [

//       myInputWidget(
//         context: context,
//         controller: _model.email,
//         hintText: "Email",
//         validator: (value) {
//           return Validator(
//             validators: [
//               RequiredValidator(),
//               EmailValidator()
//             ],
//           ).validate(
//             context: context,
//             label: 'Email',
//             value: value,
//           );
//         },
//       ),

//       // myInputWidget(
//       //   context: context,
//       //   controller: _model.password,
//       //   hintText: "Password",
//       //   validator: (value) {
//       //     return Validator(
//       //       validators: [
//       //         RequiredValidator(),
//       //         MinLengthValidator(length: 8),
//       //       ],
//       //     ).validate(
//       //       context: context,
//       //       label: 'Password',
//       //       value: value,
//       //     );
//       //   },
//       // ),

//       _loginButton("Sign Up"),
//     ];

//     animationS.initialize(
//       vsync: this,
//       loginItems: loginContent.length,
//       createAccountItems: createAccountContent.length,
//     );
    
//     for (var i = 0; i < loginContent.length; i++) {
//       loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
//         animation: animationS.loginAnimations[i],
//         child: loginContent[i],
//       );
//     }

//     for (var i = 0; i < createAccountContent.length; i++) {
//       createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
//         animation: animationS.createAccountAnimations[i],
//         child: createAccountContent[i],
//       );
//     }

//     super.initState();
//   }

//   @override
//   void dispose() {
    
//     animationS.dispose();

//     super.dispose();
//   }


//   void initStateData(TickerProvider tickerProvider, Function mySetState){
//     _importAccountModel.loadingMgs = "LOADING...";
    
//     _importAccountModel.animationController = AnimationController(vsync: tickerProvider, duration: const Duration(seconds: 2));

//     _importAccountModel.animation = Tween(
//       begin: 0.0, end: 1.0
//     ).animate(_importAccountModel.animationController!);  

//     _importAccountModel.animationController!.addListener(() {
//       if (kDebugMode) {
//         debugPrint("animationController!.value ${_importAccountModel.animationController!.value}");
//       }

//       if (_importAccountModel.animationController!.value >= 0.17 && _importAccountModel.animationController!.value <= 0.19) {
        
//         _importAccountModel.value = _importAccountModel.animationController!.value;
//         _importAccountModel.animationController!.stop();

//       } 

//       else if (_importAccountModel.animationController!.value >= 0.47 && _importAccountModel.animationController!.value <= 0.49) {
//         _importAccountModel.value = _importAccountModel.animationController!.value;
//         _importAccountModel.animationController!.stop();
//       }

//       else if (_importAccountModel.animationController!.value >= 0.77 && _importAccountModel.animationController!.value <= 0.79) {
//         _importAccountModel.value = _importAccountModel.animationController!.value;
//         _importAccountModel.animationController!.stop();
//       }

//       else if (_importAccountModel.animationController!.value >= 0.85 && _importAccountModel.animationController!.value <= 0.86) {
//         _importAccountModel.value = _importAccountModel.animationController!.value;
//         _importAccountModel.animationController!.stop();
//       }
      
//       mySetState();

//     });

//     importAcc();
//   }

//   Future<void> importAcc() async {

//     await Future.delayed(const Duration(seconds: 1));

//     changeStatus("DECRYPTING ACCOUNT", avg: "1/4");
//     _importAccountModel.animationController!.forward();    

//     // Execute JS
//     // await widget.webViewController!.callAsyncJavaScript(functionBody: "return await decrypt.decrypt(${widget.json!['user']['encrypted']}, '${widget.password}')").then((value) async {
//         if (kDebugMode) {
//           debugPrint("finish DECRYPTING ACCOUNT");
//         }

//         await Future.delayed(const Duration(seconds: 2));
//         if (kDebugMode) {
//           debugPrint("animationController ${_importAccountModel.animationController!.value}");
//         }
        
//     //   if (value!.value != null){
//         changeStatus("IMPORTING ACCOUNT", avg: "2/4");
//         _importAccountModel.animationController!.forward(from: 0.2);
        
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

//         if (kDebugMode) {
//           debugPrint("CONNECT TO SELENDRA NETWORK ${_importAccountModel.animationController!.value}");
//         }

//         changeStatus("CONNECT TO SELENDRA NETWORK", avg: "3/4");
//         _importAccountModel.animationController!.forward(from: 0.5);

//         await Future.delayed(const Duration(seconds: 2));
//         changeStatus("GETTING READ", avg: "4/4");
//         _importAccountModel.animationController!.forward(from: 0.8);

//         await Future.delayed(const Duration(seconds: 2));
        
//         _importAccountModel.animationController!.forward(from: 1);
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
      
//       await StorageServices.writeSecure(DbKey.private, res);

//       _importAccountModel.animationController!.forward(from: 0.6);
//       changeStatus("FETCHING ASSETS", avg: "3/4");

//       // Store PIN 6 Digit
//       // await StorageServices.writeSecure(DbKey.passcode, _importAccModel.pwCon.text);

//       if(!mounted) return;
//       await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

//       if(!mounted) return;
//       await _apiProvider!.queryBtcData(context, mnemonic, "123");

//       _importAccountModel.animationController!.forward(from: 0.9);
//       changeStatus("GETTING READY", avg: "4/4");

//       ContractsBalance().getAllAssetBalance();

      
//     }); 
//   }

//   void changeStatus(String? status, {String? avg}){
    
//     _importAccountModel.average = avg;
//     _importAccountModel.value = _importAccountModel.value! + 0.333;
//     _importAccountModel.loadingMgs = status;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   iconTheme: IconThemeData(
//       //     color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
//       //   ),
//       //   elevation: 0,
//       //   leading: IconButton(
//       //     onPressed: () => Navigator.pop(context),
//       //     icon: const Icon(Iconsax.arrow_left_2),
//       //   ),
//       // ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: Form(
//             key: _model.getFmKey,
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             child: Column(
//               children: [
        
//                 // Padding(
//                 //   padding: const EdgeInsets.all(paddingSize),
//                 //   child: Align(
//                 //     alignment: Alignment.centerLeft,
//                 //     child: TopText(animationS: animationS)
//                 //   ),
//                 // ),
        
//                 Container(
//                   margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
//                   alignment: Alignment.centerLeft,
//                   child: const HeaderTitle(title: "Email", subTitle: "Enter your email",),
//                 ),
                
//                 myInputWidget(
//                   context: context,
//                   controller: _model.email,
//                   hintText: "Email",
//                   validator: (value) {
//                     return Validator(
//                       validators: [
//                         RequiredValidator(),
//                         EmailValidator()
//                       ],
//                     ).validate(
//                       context: context,
//                       label: 'Email',
//                       value: value,
//                     );
//                   },
//                 ),
        
//                 Expanded(child: Container()),
//                 _loginButton("Login"),
                
//                 // Stack(
//                 //   children: [
//                 //     Column(
//                 //       mainAxisAlignment: MainAxisAlignment.center,
//                 //       crossAxisAlignment: CrossAxisAlignment.stretch,
//                 //       children: createAccountContent,
//                 //     ),
        
//                 //     Column(
//                 //       mainAxisAlignment: MainAxisAlignment.center,
//                 //       crossAxisAlignment: CrossAxisAlignment.stretch,
//                 //       children: loginContent,
//                 //     ),
//                 //   ],
//                 // ),
                
//                 // BottomText(
//                 //   animationS: animationS,
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }