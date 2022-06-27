import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/assets/assets.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/home/swap/select_token/select_token.dart';
import 'package:wallet_apps/src/screen/home/swap/swap.dart';
import 'package:wallet_apps/src/screen/main/create_seeds/create_seeds.dart';

class MySplashScreen extends StatefulWidget {
  //static const route = '/';
  @override
  State<StatefulWidget> createState() {
    return MySplashScreenState();
  }
}

class MySplashScreenState extends State<MySplashScreen> with SingleTickerProviderStateMixin {

  AnimationController? controller;
  Animation<double>? animation;

  // First Check
  Future<void> getCurrentAccount() async {

    // await Future.delayed(const Duration(seconds: 1), () async {
    //   Navigator.pushReplacement(context, Transition(child: Passcode(label: 'fromImport',), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

    // });
    
    try {
      await Future.delayed(const Duration(seconds: 1), () async {

        await StorageServices().readSecure(DbKey.private)!.then((String value) async {
          if (value.isEmpty) {
            Navigator.pushReplacement(context, RouteAnimation(enterPage: Welcome()));
          } else {
            
            final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);

            if (ethAddr == '') {
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
                  child: MyText(text: 'Continue', color: AppColors.secondarytext),
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
      if (ApiProvider().isDebug == true) print("Error Splash screen $e");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Welcome() ), (route) => false);
    }
  }
  
  Future<void> checkBio() async {
    print("checkBio");
    final bio = await StorageServices.readSaveBio();

    final passCode = await StorageServices().readSecure(DbKey.passcode);

    if (bio == true) {
      
      Navigator.pushReplacement(
        context,
        Transition(
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
          child: FingerPrint(
            isEnable: true,
          ),
        ),
      );

      // Navigator.pushReplacement(
      //   context,
      //   RouteAnimation(
      //     enterPage: const Passcode(label: 'fromSplash'),
      //   ),
      // );
    } else {
      if (bio) {
        Navigator.pushReplacement(
          context,
          Transition(
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
            child: FingerPrint(
              isEnable: true,
            ),
          ),
        );
      } 
      // else if (passCode != null) {
      //   Navigator.pushReplacement(
      //     context,
      //     RouteAnimation(
      //       enterPage: const Passcode(isHome: 'home'),
      //     ),
      //   );
      // } 
      else {

        Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
          ModalRoute.withName('/')
        );
      }
    }
  }

  Future<void> checkBiometric() async {
    await StorageServices.readSaveBio().then((value) {
      if (value) {
        Navigator.pushReplacement(
          context,
          RouteAnimation(
            enterPage: FingerPrint(),
          ),
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
          ModalRoute.withName('/')
        );
      }
    });
  }

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

  void readTheme() async {

    print("readTheme");
    
    // Remove below link when we want light mode
    await StorageServices.storeData('dark', DbKey.themeMode);
    await Provider.of<ThemeProvider>(context, listen: false).changeMode();
    print("Provider.of<ThemeProvider>(context, listen: false).isDark ${Provider.of<ThemeProvider>(context, listen: false).isDark}");
    // final res = await StorageServices.fetchData(DbKey.themeMode);

    // if (res != null) {
    //   await Provider.of<ThemeProvider>(context, listen: false).changeMode();
    // } else {
    //   Provider.of<ThemeProvider>(context, listen: false).setTheme = false;
    // }
    //  else {
    //   Provider.of<ThemeProvider>(context, listen: false).changeMode();
    //   // if (sysTheme) {
    //   //   Provider.of<ThemeProvider>(context, listen: false).changeMode();
    //   // } else {
    //   //   Provider.of<ThemeProvider>(context, listen: false).changeMode();
    //   // }
    // }
  }

  void systemThemeChange() async {
    final res = await StorageServices.fetchData(DbKey.themeMode);
    final sysTheme = _checkIfDarkModeEnabled();

    if (res == null) {
      if (sysTheme) {
        Provider.of<ThemeProvider>(context, listen: false).changeMode();
      } else {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.darkBgd),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
