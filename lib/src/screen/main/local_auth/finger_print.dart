import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';

class FingerPrint extends StatefulWidget {

  final String localAuth = "/localAuth";
  final bool isEnable = false;

  final Function? importAccount;

  FingerPrint({this.importAccount});
  
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
    globalkey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  Future<void> authenticate() async {
    bool authenticate = false;

    try {

      authenticate = await localAuth.authenticate( localizedReason: 'Please complete the biometrics to proceed.', stickyAuth: true);
      dialogLoading(context);
      await Future.delayed(Duration(seconds: 1), (){});
      if (authenticate) {

        // Add Account From Verify Seed Before Navigate To Home Page
        await widget.importAccount!();
        Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
          ModalRoute.withName('/')
        );
      }
    } on SocketException catch (e) {

      await Future.delayed(const Duration(milliseconds: 300), () {});
      AppServices.openSnackBar(globalkey!, e.message);
    } catch (e) {

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: const Align(
              child: Text('Message'),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: MyText(text: e.toString()),
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
              text: 'Increase your \nsecurity!',
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
              text: 'Activate biometrics for your wallet to make it even more secure.',
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
                  textButton: "Enable biometry now",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {
                    authenticate();
                  },
                ),
                MyFlatButton(
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
