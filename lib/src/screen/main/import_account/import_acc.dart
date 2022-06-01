import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:wallet_apps/src/screen/home/home/home.dart';

class ImportAcc extends StatefulWidget {
  final String? reimport;
  const ImportAcc({this.reimport});

  @override
  State<StatefulWidget> createState() {
    return ImportAccState();
  }
}

class ImportAccState extends State<ImportAcc> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  ImportAccModel _importAccModel = ImportAccModel();

  bool? status;
  int? currentVersion;
  bool? enable = false;
  String? tempMnemonic;

  @override
  void initState() {
    AppServices.noInternetConnection(globalKey);
    StorageServices().readSecure(DbKey.passcode)!.then((value) => _importAccModel.pwCon.text = value );
    // _importAccModel.mnemonicCon.text = 'donate slogan wear furnace idle canal raw senior pink frame truck beyond';
    super.initState();
  }

  String? onChanged(String value) {
    validateMnemonic(value);
    return value;
  }

  Future<bool>? validateMnemonic(String mnemonic) async {
    dynamic res;
    try {
      res = await Provider.of<ApiProvider>(context, listen: false).validateMnemonic(mnemonic);
      enable = res;
      
      setState((){});
    } catch (e) {
      if (ApiProvider().isDebug == false) print("Error validateMnemonic $e");
    }
    return res;
  }

  Future<bool>? validateJson(String mnemonic) async {
    dynamic res;
    try {
      res = await Provider.of<ApiProvider>(context, listen: false).apiKeyring;
      enable = res;
      
      setState((){});
    } catch (e) {
      if (ApiProvider().isDebug == false) print("Error validateMnemonic $e");
    }
    return res;
  }

  void clearInput() {
    _importAccModel.mnemonicCon.clear();
    setState(() {
      enable = false;
    });
  }

  Future<void> onSubmit() async => submit();

  // Submit Mnemonic
  Future<void> submit() async {
    // try {
    //   if (_importAccModel.mnemonicCon.text.isNotEmpty){
    //     await validateMnemonic(_importAccModel.mnemonicCon.text)!.then((value) async {
    //       if (value) {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => ImportUserInfo(
    //               _importAccModel.mnemonicCon.text,
    //             ),
    //           ),
    //         );
    //       } else {

    //         await customDialog(context, 'Opps', 'Invalid seed phrases or mnemonic');
    //       }
    //     });
    //   } else {

    //   }
    // } catch (e) {
    //   if (ApiProvider().isDebug == false) print("Error submit $e");
    // }
  }

  Future<void> onSubmitIm() async {
    if (_importAccModel.formKey.currentState!.validate()) {
      reImport();
    }
  }

  Future<void> reImport() async {
    
    // dialogLoading(context);
    // final isValidSeed = await validateMnemonic(_importAccModel.mnemonicCon.text);
    // final isValidPw = await checkPassword(_importAccModel.pwCon.text);

    // final _api = Provider.of<ApiProvider>(context, listen: false);

    // if (isValidSeed == false) {
    //   await showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0)),
    //         title: const Align(
    //           child: Text('Opps'),
    //         ),
    //         content: const Padding(
    //           padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
    //           child: Text('Invalid seed phrases'),
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () => Navigator.pop(context),
    //             child: const Text('Close'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   //await dialog('Invalid seed phrases', 'Opps');
    // }

    // if (isValidPw == false) {
    //   await showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0)),
    //         title: const Align(
    //           child: Text('Opps'),
    //         ),
    //         content: const Padding(
    //           padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
    //           child: Text('PIN  verification failed'),
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () => Navigator.pop(context),
    //             child: const Text('Close'),
    //           ),
    //         ],
    //       );
    //     },
    //   );

    //   //await dialog('PIN verification failed', 'Opps');
    // }

    // if (isValidSeed! && isValidPw) {
    //   Navigator.pop(context);
    //   setState(() {
    //     enable = true;
    //   });

    //   final String? resPk = await _api.getPrivateKey(_importAccModel.mnemonicCon.text);
    //   if (resPk != null) {
    //     await ContractProvider().extractAddress(resPk);
    //     final String? res = await _api.encryptPrivateKey(resPk, _importAccModel.pwCon.text);

    //     if (res != null) {
    //       await StorageServices().writeSecure(DbKey.private, res);
    //     }
    //   }
      
    //   await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();
    //   await Provider.of<ApiProvider>(context, listen: false).getAddressIcon();
    //   await Provider.of<ApiProvider>(context, listen: false).getCurrentAccount();
      
    //   await ContractsBalance().getAllAssetBalance(context: context);

    //   await successDialog(context, "imported your account.");
    //   // This Method Is Also Request Dot Contract

    //   // contract.kgoTokenWallet();
    //   // contract.selTokenWallet();
    //   // contract.selv2TokenWallet();
    //   // contract.bnbWallet();
    //   // contract.ethWallet();

    //   // Provider.of<ContractProvider>(context, listen: false).getEtherAddr();
    //   // Provider.of<ApiProvider>(context, listen: false).connectPolNon();
    //   // Provider.of<ContractProvider>(context, listen: false).getBnbBalance();
    //   // Provider.of<ContractProvider>(context, listen: false).getBscBalance();
    //   // Provider.of<ContractProvider>(context, listen: false).getEtherBalance();

    //   //selV2();

    //   await dialogSuccess(
    //     context,
    //     const Text("You haved imported successfully"),
    //     const Text('Congratulation'),
    //     // ignore: deprecated_member_use
    //     action: FlatButton(
    //       onPressed: () {
    //         Navigator.pop(context);
    //         Navigator.pushNamedAndRemoveUntil(
    //             context, Home.route, ModalRoute.withName('/'));
    //       },
    //       child: const Text('Continue'),
    //     ),
    //   );
    //   Provider.of<ApiProvider>(context, listen: false).connectPolNon(context: context);
    // } else {
    //   Navigator.pop(context);
    // }
  }

  Future<void> isDotContain() async {
    // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('DOT');
    // Provider.of<ApiProvider>(context, listen: false).isDotContain();
    await Provider.of<ApiProvider>(context, listen: false).connectPolNon(context: context);
  }

  Future<bool> checkPassword(String pin) async {
    final res = await Provider.of<ApiProvider>(context, listen: false);
    bool checkPass = await res.apiKeyring.checkPassword(res.getKeyring.current, pin);
    return checkPass;
  }


  
  Future<void> verifySeeds() async {
    print("verifySeeds");
    dynamic res;
    ApiProvider api = await Provider.of<ApiProvider>(context, listen: false);
    try {
      res = await api.validateMnemonic(_importAccModel.mnemonicCon.text);
      print("res $res");
      if (res == true){

        dialogLoading(context);

        dynamic _json = await api.apiKeyring.importAccount(
          api.getKeyring,
          keyType: KeyType.mnemonic,
          key: _importAccModel.mnemonicCon.text,
          name: "User",
          password: _importAccModel.pwCon.text, 
        );
        
        await api.apiKeyring.addAccount(
          api.getKeyring,
          keyType: KeyType.mnemonic,
          acc: _json,
          password: _importAccModel.pwCon.text,
        );

        await importAccountNAsset(api);

        await DialogComponents().dialogCustom(
          context: context,
          contents: "You have successfully create your account.",
          textButton: "Complete",
          image: Image.asset("assets/icons/success.png")
        );
        Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
          ModalRoute.withName('/')
        );
      }
    } catch (e) {
      if (ApiProvider().isDebug == false) print("Error validateMnemonic $e");
    }
    return res;
  }
  
  Future<void> importAccountNAsset(ApiProvider _api) async {

    final _resPk = await _api.getPrivateKey(_importAccModel.mnemonicCon.text);

    /// Cannot connect Both Network On the Same time
    /// 
    /// It will be wrong data of that each connection. 
    /// 
    /// This Function Connect Polkadot Network And then Connect Selendra Network
    await _api.connectPolNon(context: context).then((value) async {

      await _api.getAddressIcon();
      // Get From Account js
      await _api.getCurrentAccount();

      await ContractProvider().extractAddress(_resPk);

      final _res = await _api.encryptPrivateKey(_resPk, _importAccModel.pwCon.text);
      
      await StorageServices().writeSecure(DbKey.private, _res);

      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      await _api.queryBtcData(context, _importAccModel.mnemonicCon.text, _importAccModel.pwCon.text);

      await ContractsBalance().getAllAssetBalance(context: context);
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ImportAccBody(
          reImport: widget.reimport,
          importAccModel: _importAccModel,
          onChanged: onChanged,
          onSubmit: widget.reimport != null ? onSubmitIm : submit,
          clearInput: clearInput,
          enable: enable,
          submit: widget.reimport != null ? onSubmitIm : verifySeeds,
        ),
      )
    );
  }
}
