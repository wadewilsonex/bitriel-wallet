import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/discover/discover.dart';
import 'package:wallet_apps/src/screen/home/transaction/send.dart';
import 'package:wallet_apps/src/screen/home/wallet/wallet.dart';

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
<<<<<<< HEAD

    // print("getCurrentAccount");
      // await Future.delayed(const Duration(seconds: 1), () async {
      //     Navigator.pushReplacement(context, RouteAnimation(enterPage: ClaimAirDrop())); 
      // });
=======
>>>>>>> dev
    
    // Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitTrx('', false, Provider.of<ContractProvider>(context, listen: false).sortListContract, asset: "SEL",)));
    try {
      await Future.delayed(const Duration(seconds: 1), () async {
<<<<<<< HEAD
        await StorageServices().readSecure('private')!.then((String? value) async {
          if (value == null || value.isEmpty) {
=======

        await StorageServices().readSecure(DbKey.private)!.then((String value) async {
          if (value.isEmpty) {
>>>>>>> dev
            Navigator.pushReplacement(context, RouteAnimation(enterPage: Welcome()));
          } else {
            final ethAddr = await StorageServices().readSecure(DbKey.ethAddr);

<<<<<<< HEAD
            if (ethAddr == null) {
=======
            if (ethAddr == '') {
>>>>>>> dev
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
      if (ApiProvider().isDebug == false) print("Error Splash screen $e");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Welcome() ), (route) => false);
    }
  }
  
  Future<void> checkBio() async {
    
    final bio = await StorageServices.readSaveBio();

    final passCode = await StorageServices().readSecure(DbKey.passcode);

<<<<<<< HEAD
    await StorageServices().readSecure('private')!.then((value) {});

    if (bio && passCode != '') {
=======
    if (bio == false && passCode != '') {
>>>>>>> dev
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
<<<<<<< HEAD
        Navigator.push(context, MaterialPageRoute(builder: (context) => Wallet() ));
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitTrx('', true, [], asset: "SEL",)
        // ConfirmationTx(
        //   trxInfo: TransactionInfo(),
        //   sendTrx: (){},
        //   gasFeetoEther: "0.0",
        // )
        // ));
        // Navigator.pushReplacementNamed(context, Home.route);
=======
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Passcode()));
        Navigator.pushReplacementNamed(context, Home.route);
>>>>>>> dev
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

<<<<<<< HEAD
    // print("sysTheme $sysTheme");
    // print("res $res");

=======
>>>>>>> dev
    if (res != null) {
      await Provider.of<ThemeProvider>(context, listen: false).changeMode();
    } else {
      Provider.of<ThemeProvider>(context, listen: false).setTheme = true;
    }

    // await StorageServices.removeKey(DbKey.themeMode);


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
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
