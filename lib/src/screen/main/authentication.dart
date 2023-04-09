import 'package:flutter/gestures.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/data_loading.dart';

/// User For Finger Print And Password
class Authentication extends StatefulWidget {

  final String localAuth = "/localAuth";
  final bool? isEnable;

  final ImportAccAnimationModel? importAccountModel;

  final Function? initStateData;

  const Authentication({Key? key, this.importAccountModel, this.initStateData, this.isEnable = false}) : super(key: key);
  
  @override
  AuthenticationState createState() => AuthenticationState();
}

class AuthenticationState extends State<Authentication> {
  
  final localAuth = LocalAuthentication();

  bool enableText = false;

  String authorNot = 'Not Authenticate';

  GlobalKey<ScaffoldState>? globalkey;

  TextEditingController _pwdController = TextEditingController();

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


  Future<void> _deleteAccoutDialog({BuildContext? context}) async {
    await customDialog(
      context!, 
      'Are you sure to delete all wallets?', 
      'Your current wallets, and assets will be removed from this app permanently\n\n You can Only recover all wallets with all your Secret Recovery Seed Phrases',
      txtButton: "Cancel",
      btn2: MyFlatButton(
        edgeMargin: const EdgeInsets.symmetric(horizontal: paddingSize),
        isTransparent: false,
        buttonColor: AppColors.whiteHexaColor,
        textColor: AppColors.redColor,
        textButton: "Confirm",
        isBorder: true,
        action: () async => await _deleteAccount(context: context),
      )
    );
  }
  
  Future<void> _deleteAccount({BuildContext? context}) async {

    dialogLoading(context!);

    final api = Provider.of<ApiProvider>(context, listen: false);
    
    try {

      for( KeyPairData e in api.getKeyring.allAccounts){
        await api.getSdk.api.keyring.deleteAccount(
          api.getKeyring,
          e,
        );
      }

      final mode = await StorageServices.fetchData(DbKey.themeMode);
      final sldNW = await StorageServices.fetchData(DbKey.sldNetwork);

      await StorageServices.clearStorage();

      // Re-Save Them Mode
      await StorageServices.storeData(mode, DbKey.themeMode);
      await StorageServices.storeData(sldNW, DbKey.sldNetwork);

      await StorageServices.clearSecure();
      
      Provider.of<ContractProvider>(context, listen: false).resetConObject();
      
      await Future.delayed(const Duration(seconds: 2), () {});
      
      Provider.of<WalletProvider>(context, listen: false).clearPortfolio();

      Navigator.pushAndRemoveUntil(context, RouteAnimation(enterPage: const Onboarding()), ModalRoute.withName('/'));
    } catch (e) {

      if (kDebugMode) {
        print("_deleteAccount ${e.toString()}");
      }
      // await dialog(context, e.toString(), 'Opps');
    }
  }

  Future<void> checkPassword() async {
    print("checkPassword");
    await StorageServices.readSecure(DbKey.password)!.then((value) {
      print("value $value");
      print("_pwdController.text ${_pwdController.text}");
      print(value == _pwdController.text);
      if (value == _pwdController.text){
        Navigator.pushNamedAndRemoveUntil(
          context, 
          AppString.homeView,
          (route) => false
        );
      }
    });
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
              child: Authentication(initStateData: widget.initStateData!,),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT
            )
          );
        }

        if(!mounted) return;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => DataLoading(initStateData: widget.initStateData, importAnimationAccModel: widget.importAccountModel,))
        // );
        Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
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
      
    }
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      key: globalkey,
      body: _bodyPasscodeWidget(context)
    );
  }


  Widget _bodyPasscodeWidget(BuildContext context) {
    return BodyScaffold(
      isSafeArea: true,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          const SizedBox(
            height: 75.0,
          ),
          SizedBox(
            height: 100,
            width: 100,
            child: Image.asset("assets/logo/bitriel-splash.png",)
          ),
          const SizedBox(
            height: 20.0,
          ),
          
          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: tfPasswordWidget(_pwdController, "Enter Password"),
          ),

          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: MyGradientButton(
              textButton: "Continue",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: () {
                checkPassword();
              }
            ),
          ),

          Expanded(
            child: Container(),
          ),

          Container(
            padding: const EdgeInsets.all(paddingSize),
            child: Center(
              child: RichText(
                text: TextSpan(
                    text: 'Forgot your password?',
                    style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                    children: <TextSpan>[
                      TextSpan(text: 'Logout all Wallets',
                          style: TextStyle(
                              color: hexaCodeToColor(AppColors.primaryColor), fontSize: 18, fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _deleteAccoutDialog(context: context);
                              // navigate to desired screen
                            }
                      )
                    ]
                ),
              ),
            ),
          ),
        ], 
      ),
    );
  }

  // ignore: unused_element
  Widget _bodyFingerPrintWidget(BuildContext context) {
    return BodyScaffold(
      isSafeArea: true,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          const SizedBox(
            height: 100.0,
          ),
          Image.asset("assets/logo/fingerprint.png",),
          const SizedBox(
            height: 20.0,
          ),
          
          MyText(
            top: 20.0,
            text: widget.isEnable == true ? 'Finger Print Authentication' : 'Increase your \nsecurity!',
            fontSize: 25,
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
            width: 80,
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
                textButton: widget.isEnable == true ? "Unlock with biometry" : "Enable biometry now",
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
                    MaterialPageRoute(builder: (context) => DataLoading(initStateData: widget.initStateData, importAnimationAccModel: widget.importAccountModel,))
                  );
                },
              )
            ],
          ),
        ], 
      ),
    );
  }
}