import 'package:flutter/scheduler.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  //static const route = '/';
  @override
  State<StatefulWidget> createState() {
    return MySplashScreenState();
  }
}

class MySplashScreenState extends State<MySplashScreen> with SingleTickerProviderStateMixin {

  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    
    readTheme();
    // checkBio();
    getCurrentAccount();

    // final window = WidgetsBinding.instance.window;
    // window.onPlatformBrightnessChanged = () {
    //   readTheme();
    // };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // First Check
  Future<void> getCurrentAccount() async {
    
    try {
      await Future.delayed(const Duration(seconds: 1), () async {

        await StorageServices.readSecure(DbKey.private)!.then((String value) async {
          if (value.isEmpty) {
            Navigator.pushReplacement(context, RouteAnimation(enterPage: const Onboarding()));
          } else {
            
            final ethAddr = await StorageServices.readSecure(DbKey.ethAddr);

            if (ethAddr == '') {
              if(!mounted) return;
              await dialogSuccess(
                context,
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Please reimport your seed phrases to add support to new update.',
                    textAlign: TextAlign.center,
                  )
                ),
                const Text('New Update!'),
                action: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      RouteAnimation(
                        enterPage: const ImportAcc(
                          reimport: 'reimport',
                        ),
                      ),
                    );
                  },
                  child: const MyText(text: 'Continue', hexaColor: AppColors.secondarytext),
                ),
              );
            } else {
              await checkBio();
              // checkBio();
            }
          }
        });
      });
    } catch (e) {
      
        if (kDebugMode) {
          debugPrint("Error Splash screen $e");
        }
      
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Onboarding() ), (route) => false);
    }
  }
  
  Future<void> checkBio() async {

    final bio = await StorageServices.readSaveBio();

    debugPrint("bio $bio");

    final password = await StorageServices.readSecure(DbKey.password);

    debugPrint("passCode $password");

    if (bio || password!.isNotEmpty) {
      if(!mounted) return;
      Navigator.pushReplacement(
        context,
        Transition(
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
          child: Authentication(
            isEnable: bio,
          ),
        ),
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

  Future<void> checkBiometric() async {
    await StorageServices.readSaveBio().then((value) {
      if (value) {
        Navigator.pushReplacement(
          context,
          RouteAnimation(
            enterPage: const Authentication(),
          ),
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
          ModalRoute.withName('/')
        );
      }
    });
  }

  void readTheme() async {
    try {
      final res = await StorageServices.fetchData(DbKey.themeMode);

      if (res != null) {
        if(!mounted) return;
        await Provider.of<ThemeProvider>(context, listen: false).changeMode();
      } else {
        if(!mounted) return;
        Provider.of<ThemeProvider>(context, listen: false).setTheme = false;
      }

    } catch (e) {
        if (kDebugMode) {
          debugPrint("Error readTheme $e");
        }
    }
  }

  void systemThemeChange() async {
    final res = await StorageServices.fetchData(DbKey.themeMode);
    final sysTheme = _checkIfDarkModeEnabled();

    if (res == null) {
      if (sysTheme) {
        if(!mounted) return;
        Provider.of<ThemeProvider>(context, listen: false).changeMode();
      } else {
        if(!mounted) return;
        Provider.of<ThemeProvider>(context, listen: false).changeMode();
      }
    }
  }

  bool _checkIfDarkModeEnabled() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return darkModeOn;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, widget) {
        return Scaffold(
          backgroundColor: hexaCodeToColor(AppColors.darkBgd),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    );
  }
}
