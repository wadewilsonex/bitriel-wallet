import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';

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

    // print("getCurrentAccount");
      // await Future.delayed(const Duration(seconds: 2), () async {
      //     Navigator.pushReplacement(context, RouteAnimation(enterPage: Account())); 
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
                  child: const MyText(text: 'Continue', color: AppColors.secondarytext),
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
      print("Error Splash screen $e");
    }
  }
  
  Future<void> checkBio() async {
    
    final bio = await StorageServices.readSaveBio();

    final passCode = await StorageServices().readSecure(DbKey.passcode);

    if (bio == false && passCode != '') {
      Navigator.pushReplacement(
        context,
        RouteAnimation(
          enterPage: const Passcode(isHome: 'home'),
        ),
      );
    } else {
      if (bio) {
        Navigator.pushReplacement(
          context,
          RouteAnimation(
            enterPage: FingerPrint(),
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
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Passcode()));
        Navigator.pushReplacementNamed(context, Home.route);
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
        Navigator.pushReplacementNamed(context, Home.route);
      }
    });
  }

  @override
  void initState() {
    readTheme();
    getCurrentAccount();

    // final window = WidgetsBinding.instance.window;
    // window.onPlatformBrightnessChanged = () {
    //   readTheme();
    // };

    super.initState();
  }

  void readTheme() async {
    final res = await StorageServices.fetchData(DbKey.themeMode);
    // final sysTheme = _checkIfDarkModeEnabled();

    if (res != null) {
      await Provider.of<ThemeProvider>(context, listen: false).changeMode();
    } else {
      Provider.of<ThemeProvider>(context, listen: false).setTheme = false;
    }
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
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
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
      body: Container(),
    );
  }
}
