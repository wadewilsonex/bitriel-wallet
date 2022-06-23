import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class FingerPrint extends StatefulWidget {

  final String localAuth = "/localAuth";
  final bool? isEnable;

  final Function? importAccount;

  FingerPrint({this.importAccount, this.isEnable = false});
  
  @override
  _FingerPrintState createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  
  final localAuth = LocalAuthentication();

  bool enableText = false;

  String authorNot = 'Not Authenticate';

  GlobalKey<ScaffoldState>? globalkey;

  @override
  void initState() {
    if (widget.isEnable!) authenticate();
    globalkey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  Future<void> authenticate() async {
    bool authenticate = false;

    try {

      dialogLoading(context);
      authenticate = await localAuth.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
        options: const AuthenticationOptions(biometricOnly: true)
      );
      if (authenticate) {
        await Future.delayed(Duration(seconds: 1), (){});

        // Add Account From Verify Seed Before Navigate To Home Page
        if(widget.importAccount != null) {
          await StorageServices.saveBio(true);
          // Close Dialog
          Navigator.pop(context);
          await widget.importAccount!();
        }
        Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
          ModalRoute.withName('/')
        );
      }
    } on SocketException catch (e) {

      // Close Dialog
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 300), () {});
      AppServices.openSnackBar(globalkey!, e.message);
    } catch (e) {

      // Close Dialog
      Navigator.pop(context);
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: hexaCodeToColor(AppColors.darkBgd),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: Text('Message', style: TextStyle(color: hexaCodeToColor(AppColors.whiteColorHexa)),),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: MyText(
                text: "Your device doesn't have finger print! Set up to enable this feature",
                color: AppColors.lowWhite
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      //await dialog(e.message.toString(), "Message");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      key: globalkey,
      body: BodyScaffold(
        isSafeArea: true,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(
              height: 10.0.h,
            ),
            Image.asset("assets/logo/fingerprint.png", width: 30.w,),
            const SizedBox(
              height: 20.0,
            ),
            
            MyText(
              width: 275,
              top: 19.0,
              text: widget.isEnable == true ? 'Finger Print authentication' : 'Increase your \nsecurity!',
              fontSize: 21.sp,
              fontWeight: FontWeight.bold,
              color: isDarkTheme
                ? AppColors.whiteColorHexa
                : AppColors.textColor,
            ),
            const SizedBox(
              height: 20.0,
            ),

            MyText(
              top: 20.0,
              width: 80.w,
              text: widget.isEnable == true ? 'Validating Finger Print' : 'Activate biometrics for your wallet to make it even more secure.',
              color: isDarkTheme
                ? AppColors.whiteColorHexa
                : AppColors.textColor,
            ),

            Expanded(
              child: Container(),
            ),

            Column(
              children: [
                MyGradientButton(
                  edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  textButton: widget.isEnable == true ? "Process biometry now" : "Enable biometry now",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {
                    authenticate();
                  },
                ),
                widget.isEnable == true
                ? Container() 
                : MyFlatButton(
                  isTransparent: true,
                  buttonColor: AppColors.whiteHexaColor,
                  edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  textButton: "Skip",
                  action: () async {

                    await widget.importAccount!();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
