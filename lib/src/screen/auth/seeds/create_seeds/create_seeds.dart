import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/models/createkey_m.dart';
import 'package:wallet_apps/src/provider/verify_seed_p.dart';
import 'package:wallet_apps/src/screen/auth/seeds/create_seeds/body_create_key.dart';

class CreateSeeds extends StatefulWidget {

  final NewAccount? newAcc;
  final String? passCode;

  const CreateSeeds({Key? key, @required this.newAcc, @required this.passCode}): super(key: key);

  @override
  CreateWalletPagetScreenState createState() => CreateWalletPagetScreenState();
}

class CreateWalletPagetScreenState extends State<CreateSeeds> {

  VerifySeedsProvider? _verify;
  
  final CreateKeyModel _model = CreateKeyModel();

  void _generateKey() async {

    if(_verify!.mnemonic == null) {
      _model.seed = await Provider.of<ApiProvider>(context, listen: false).generateMnemonic();
    }
    else{
      _model.seed = _verify!.mnemonic;
    }
      
      // Split Seed to list
      _model.lsSeeds = _model.seed!.split(" ");
      setState(() { });
  }

  void _showWarning(BuildContext context) {
    
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 2.5.h),
              MyText(
                text: "Please, read carefully!",
                fontSize: 18,
                hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),


              SizedBox(height: 2.5.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size8),
                  color: hexaCodeToColor("#FFF5F5"),
                ),
                height: 10.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(width: 1.w),
                    Lottie.asset(
                      "assets/animation/warning-shield.json",
                      repeat: true,
                    ),

                    SizedBox(width: 2.w),
                    const Expanded(
                      child: MyText(
                        text: "The information below is important to guarantee your account security.",
                        hexaColor: AppColors.warningColor,
                        textAlign: TextAlign.start,
                      ),
                    )
                  ]
                ),
              ),

              SizedBox(height: 5.h),
              MyText(
                text: "Please write down your wallet's mnemonic seed and keep it in a safe place. The mnemonic can be used to restore your wallet. If you lose it, all your assets that link to it will be lost.",
                textAlign: TextAlign.start,
                hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.textColor,
              ),

              SizedBox(height: 5.h),
              MyGradientButton(
                textButton: "I Agree",
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () {
                  Navigator.pop(context);
                },
              ),

              SizedBox(height: 5.h),
            ],
          ),
        );
      }
    );
  }

  @override
  void didChangeDependencies() async {
    if (_model.initial == true) {

      setState(() {
        _model.initial = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _model.initial = true;

    _verify = Provider.of<VerifySeedsProvider>(context, listen: false);

    // Wiget.passCode is from add new account
    if (widget.passCode == null) {
      StorageServices.readSecure(DbKey.pin)!.then((value) => _model.passCode = value);
    } else {
      _model.passCode = widget.passCode!;
    }
    _generateKey();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWarning(context);
    });
    AppServices.noInternetConnection(context: context);
    super.initState();
  }

  @override
  void dispose() {
    _verify!.mnemonic = null;

    _verify!.isVerifying = false;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CreateSeedsBody(
      createKeyModel: _model,
      newAcc: widget.newAcc,
      generateKey: _generateKey
    );
  }
}
