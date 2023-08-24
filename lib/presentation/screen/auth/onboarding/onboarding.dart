import 'package:flutter/scheduler.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/constants/db_key_con.dart';
import 'package:wallet_apps/data/provider/headless_webview_p.dart';
import 'package:wallet_apps/data/provider/provider.dart';

class Onboarding extends StatefulWidget {
  
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OnboardingState();
  }
}

class OnboardingState extends State<Onboarding>{

  bool? status;
  int? currentVersion;
  bool? selected = false;
  bool? bio = false;
  String? _secure;
  String? password;

  ValueNotifier<bool> isReady = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    
    // ignore: use_build_context_synchronously
    // Provider.of<AppProvider>(context, listen: false).downloadFirstAsset();

    // bio ??= await StorageServices.readSaveBio();
    // password ??= await StorageServices.readSecure(DbKey.password);
    StorageServices.readSecure(DbKey.private)!.then((value) {
      _secure ??= value;
    
      getCurrentAccount();
    });
  }
  
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  didChangeDependencies() async {

    super.didChangeDependencies();

    // await Future.delayed(const Duration(seconds: 2), () async {
      
    // });
    // ignore: use_build_context_synchronously
  //   // await checkRemainFailImport();

  //   // // ignore: use_build_context_synchronously
  //   // await Provider.of<HeadlessWebView>(context, listen: false).initHeadlessWebview();
    
  //   // // ignore: use_build_context_synchronously
  //   // AppServices.noInternetConnection(context: context);
  }

  // Seed Import Failed Checker And Clear
  Future<void> checkRemainFailImport() async {
    if (Provider.of<ApiProvider>(context, listen: false).netWorkConnected!){

      await Provider.of<ApiProvider>(context, listen: false).getSdk.api.keyring.deleteAccount(Provider.of<ApiProvider>(context, listen: false).getKeyring, Provider.of<ApiProvider>(context, listen: false).getKeyring.current);
    }
  }
  
  Future<void> getCurrentAccount() async {

    try {
      
      // await StorageServices.readSecure(DbKey.private)!.then((String value) async {
      //   print("value.isNotEmpty ${value.isNotEmpty}");
        if (_secure!.isNotEmpty){
          
          // final ethAddr = await StorageServices.readSecure(DbKey.ethAddr);

          // if (ethAddr == '') {
          //   if(!mounted) return;
          //   await dialogSuccess(
          //     context,
          //     const Padding(
          //       padding: EdgeInsets.only(left: 20, right: 20),
          //       child: Text(
          //         'Please reimport your seed phrases to add support to new update.',
          //         textAlign: TextAlign.center,
          //       )
          //     ),
          //     const Text('New Update!'),
          //     action: TextButton(
          //       onPressed: () {
          //         Navigator.pushReplacement(
          //           context,
          //           RouteAnimation(
          //             enterPage: const ImportAcc(
          //               reimport: 'reimport',
          //             ),
          //           ),
          //         );
          //       },
          //       child: const MyText(text: 'Continue', hexaColor: AppColors.secondarytext),
          //     ),
          //   );
          // } else {
          //   // checkBio();
          // }
          await checkBio();
        } else {
          // isReady.value = true;
        }
      // });
    } catch (e) {
      
      if (kDebugMode) {

      }
      
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Onboarding() ), (route) => false);
    }
  }

  Future<void> checkBio() async {

    if (bio! || password!.isNotEmpty) {
      if(!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (builder) => Authentication(
            isEnable: bio,
          ))
        // Transition(
        //   transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
        //   child: ,
        // ),
      );
    } 
    else {
      if(!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context, 
        AppString.homeView, 
        ModalRoute.withName('/')
      );
    }

  }

  void tabGoogle(){
    
    // await GoogleAuthService().signOut();
    // await GoogleAuthService().signInWithGoogle().then((value) async {
    //   if (value != null){
    //     // Navigator.pushAndRemoveUntil(
    //     //   context, 
    //     //   MaterialPageRoute(builder: (context) => HomePage()), 
    //     //   (route) => false
    //     // );
        
    //   }
    //   // debugPrint("signInWithGoogle ${value}");

    //   try {

    //     // Verify OTP with HTTPs
        
    //     Response response = Response(await rootBundle.loadString('assets/json/phone.json'), 200);

    //     final responseJson = json.decode(response.body);

    //     if (response.statusCode == 200) {

    //       // if(!mounted) return;
    //       if (responseJson['user'].containsKey("encrypted")){

    //         Navigator.push(context, Transition(child: SetPassword(phoneNumber: "+85511725228", responseJson: responseJson), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
    //       }
            
    //     } else if (response.statusCode == 401) {

    //       customDialog(
    //         context, 
    //         "Error",
    //         responseJson['message']
    //       );

    //       Navigator.of(context).pop();

    //     } else if (response.statusCode >= 500 && response.statusCode < 600) {

    //       customDialog(
    //         context, 
    //         "Error",
    //         responseJson['message']
    //       );

    //       Navigator.of(context).pop();

    //     }

    //   } catch (e) {
    //     debugPrint(e);
    //   }

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //Color(AppUtils.convertHexaColor(AppColors.lightColorBg)),
      body: SafeArea(child: OnboardingBody(isReady: isReady, inputController: InputController() , tabGoogle: tabGoogle, selected: selected,)),
    );
  }
}
