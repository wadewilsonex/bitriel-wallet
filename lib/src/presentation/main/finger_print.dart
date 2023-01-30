import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:wallet_apps/src/presentation/home/home/home.dart';
import 'package:wallet_apps/src/presentation/main/data_loading.dart';

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

        else {
          if(!mounted) return;
          Navigator.pushAndRemoveUntil(
            context, 
            Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
            ModalRoute.withName('/')
          );
        }
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        
            Expanded(
              child: Column(
                children: [
      
                  SizedBox(
                    height: 10.0.sp,
                  ),
                  Image.asset("assets/logo/fingerprint.png", width: 12.sp, fit: BoxFit.cover,),
                  SizedBox(
                    height: 2.9.sp,
                  ),
                  
                  MyText(
                    width: 60.sp,
                    // top: 19.sp,
                    text: widget.isEnable == true ? 'Finger Print authentication' : 'Increase your \nsecurity!',
                    fontSize: 2.5,
                    fontWeight: FontWeight.bold,
                    hexaColor: isDarkMode
                      ? AppColors.whiteColorHexa
                      : AppColors.textColor,
                  ),
                  SizedBox(
                    height: 2.9.sp,
                  ),
            
                  MyText(
                    top: 2.9.sp,
                    width: 80.sp,
                    text: widget.isEnable == true ? '' : 'Activate biometrics for your wallet to make it even more secure.',
                    hexaColor: isDarkMode
                      ? AppColors.whiteColorHexa
                      : AppColors.textColor,
                  ),
                ],
              ),
            ),
        
            // Expanded(
            //   child: Container(),
            // ),
        
            MyGradientButton(
              edgeMargin: EdgeInsets.only(left: 2.9.sp, right: 2.9.sp, bottom: 2.4.sp),
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
              textColor: isDarkMode ? AppColors.whiteHexaColor : AppColors.secondary,
              edgeMargin: EdgeInsets.only(left: 2.9.sp, right: 2.9.sp, bottom: 2.4.sp),
              textButton: "Skip",
              action: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImportJson(initStateData: widget.initStateData, importAccountModel: widget.importAccountModel,))
                );
              },
            ),
          ], 
        ),
      ),
    );
  }
}
