import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/headless_webview_p.dart';

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

  //var snackBar;

  @override
  void initState() {

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
    //   // print("signInWithGoogle ${value}");

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
    //     print(e);
    //   }

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: OnboardignBody(tabGoogle: tabGoogle, selected: selected,)
        ),
      ),
    );
  }
}
