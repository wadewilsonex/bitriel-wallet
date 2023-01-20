import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/data_loading.dart';

class FingerPrint extends StatefulWidget {

  final String localAuth = "/localAuth";
  final bool? isEnable;

  final ImportAccountModel? importAccountModel;

  final Function? initStateData;

  const FingerPrint({Key? key, this.importAccountModel, this.initStateData, this.isEnable = false}) : super(key: key);
  
  @override
  FingerPrintState createState() => FingerPrintState();
}

class FingerPrintState extends State<FingerPrint> {
  
  final localAuth = LocalAuthentication();

  bool enableText = false;

  String authorNot = 'Not Authenticate';

  GlobalKey<ScaffoldState>? globalkey;

  @override
  void initState() {
    AppServices.noInternetConnection(context: context);
    if (widget.isEnable!) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        await authenticate();
      });
    }
    globalkey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  Future<void> authenticate() async {
    bool authenticate = false;
    try {

      authenticate = await localAuth.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
        options: const AuthenticationOptions(biometricOnly: true)
      );
      if (authenticate) {
        if(!mounted) return;
        dialogLoading(context);
        await Future.delayed(const Duration(seconds: 1), (){});
        
        // Add Account From Verify Seed Before Navigate To Home Page
        if(widget.initStateData != null) {
          await StorageServices.saveBio(true);
          // Close Dialog
          if(!mounted) return;
          Navigator.pop(context);
          
          Navigator.push(
            context,
            Transition(
              child: FingerPrint(initStateData: widget.initStateData!,),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            )
          );
        }

        if(!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImportJson(initStateData: widget.initStateData, importAccountModel: widget.importAccountModel,))
        );
        // Navigator.pushAndRemoveUntil(
        //   context, 
        //   Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
        //   ModalRoute.withName('/')
        // );
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
            backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: Text('Message', style: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)),),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: MyText(
                text: "Your device doesn't have finger print! Set up to enable this feature",
                hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.darkGrey
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: MyText(text: 'Close', hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor),
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
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              hexaColor: isDarkMode
                ? AppColors.whiteColorHexa
                : AppColors.textColor,
            ),
            const SizedBox(
              height: 20.0,
            ),

            MyText(
              top: 20.0,
              width: 80.w,
              text: widget.isEnable == true ? '' : 'Activate biometrics for your wallet to make it even more secure.',
              hexaColor: isDarkMode
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
                  textColor: isDarkMode ? AppColors.whiteHexaColor : AppColors.textColor,
                  edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  textButton: "Skip",
                  action: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImportJson(initStateData: widget.initStateData, importAccountModel: widget.importAccountModel,))
                    );
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
