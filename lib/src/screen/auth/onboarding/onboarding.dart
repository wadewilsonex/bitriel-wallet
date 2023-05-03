import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/headless_webview_p.dart';
import 'package:wallet_apps/src/provider/provider.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OnboardingState();
  }
}

class OnboardingState extends State<Onboarding> {

  bool? status;
  int? currentVersion;
  bool? selected = false;

  AppProvider? _appPro;

  //var snackBar;

  @override
  void initState() {
    
    _appPro = Provider.of<AppProvider>(context, listen: false);

    // downloadAndSaveAsset();

    checkRemainFailImport();

    Provider.of<HeadlessWebView>(context, listen: false).initHeadlessWebview();
    
    // inAppUpdate();
    AppServices.noInternetConnection(context: context);
    super.initState();
  }
  
  // Future<void> inAppUpdate() async {
  //   AppUpdate appUpdate = AppUpdate();
  //   final result = await appUpdate.checkUpdate();
  //   if (result.availableVersionCode == 1){
  //     await appUpdate.performImmediateUpdate();
  //     await InAppUpdate.completeFlexibleUpdate();
  //   }
  // }

  // Seed Import Failed Checker And Clear
  void checkRemainFailImport() async {
    if (Provider.of<ApiProvider>(context, listen: false).netWorkConnected!){

      await Provider.of<ApiProvider>(context, listen: false).getSdk.api.keyring.deleteAccount(Provider.of<ApiProvider>(context, listen: false).getKeyring, Provider.of<ApiProvider>(context, listen: false).getKeyring.current);
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
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      body: SafeArea(
        child: UpgradeAlert(
          upgrader: Upgrader(
            dialogStyle: UpgradeDialogStyle.material,
            durationUntilAlertAgain: const Duration(minutes: 30)
          ),
          child: OnboardignBody(tabGoogle: tabGoogle, selected: selected,)
          // SizedBox(
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   child: SingleChildScrollView(
          //     physics: const BouncingScrollPhysics(),
          //     child: 
          //   ),
          // ),
        ),
      ),
    );
  }
}
