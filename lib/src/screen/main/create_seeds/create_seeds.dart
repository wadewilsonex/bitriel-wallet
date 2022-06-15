import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/createKey_m.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/screen/main/create_seeds/body_create_key.dart';

class CreateSeeds extends StatefulWidget {

  const CreateSeeds({Key? key}): super(key: key);

  @override
  _CreateWalletPagetScreenState createState() =>
      _CreateWalletPagetScreenState();
}

class _CreateWalletPagetScreenState extends State<CreateSeeds> {
  
  CreateKeyModel _model = CreateKeyModel();

  void generateKey() async {
    //"orient effort sea envelope voice lucky enforce expire tragic bring skull arrange";
    _model.seed = await Provider.of<ApiProvider>(context, listen: false).generateMnemonic();
    print(_model.seed);
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
        return Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.blue),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                SizedBox(height: 2.5.h),
                MyText(
                  text: "Please, read carefully!",
                  fontSize: 18,
                  color: AppColors.lowWhite,
                  fontWeight: FontWeight.bold,
                ),  
        
        
                SizedBox(height: 5.h),
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
                      // SvgPicture.asset('assets/icons/warning.svg'),
                      Lottie.asset(
                        "assets/animation/warning-shield.json",
                        repeat: true,
                      ),
        
                      SizedBox(width: 2.w),
                      Expanded(
                        child: MyText(
                          text: "The information below is important to guarantee your account security.",
                          color: AppColors.warningColor,
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
                  color: AppColors.lowWhite,
                ),
        
                SizedBox(height: 7.h),
                MyGradientButton(
                  textButton: "I Agree",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
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
    StorageServices().readSecure(DbKey.passcode)!.then((value) => _model.passCode = value);
    generateKey();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWarning(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CreateSeedsBody(
      createKeyModel: _model,
      generateKey: generateKey,
    );
  }
}
