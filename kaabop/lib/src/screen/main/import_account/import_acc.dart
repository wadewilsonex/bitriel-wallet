import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/provider.dart';

class ImportAcc extends StatefulWidget {
  final String reimport;
  const ImportAcc({this.reimport});

  @override
  State<StatefulWidget> createState() {
    return ImportAccState();
  }
}

class ImportAccState extends State<ImportAcc> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  final ImportAccModel _importAccModel = ImportAccModel();

  bool status;

  int currentVersion;

  bool enable = false;

  String tempMnemonic;

  @override
  void initState() {
    AppServices.noInternetConnection(globalKey);
    // _importAccModel.mnemonicCon.text = 'donate slogan wear furnace idle canal raw senior pink frame truck beyond';
    super.initState();
  }

  String onChanged(String value) {
    validateMnemonic(value).then((value) {
      setState(() {
        enable = value;
      });
    });
    return null;
  }

  Future<bool> validateMnemonic(String mnemonic) async {
    try {
      final res = await ApiProvider.sdk.api.keyring.validateMnemonic(mnemonic);
      return res;
    } catch (e) {
      print("Error validateMnemonic $e");
    }
    return false;
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

    await validateMnemonic(_importAccModel.mnemonicCon.text).then((value) async {
      if (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImportUserInfo(
              _importAccModel.mnemonicCon.text,
            ),
          ),
        );
      }
    });
  }

  Future<void> onSubmitIm() async {
    if (_importAccModel.formKey.currentState.validate()) {
      reImport();
    }
  }

  Future<void> reImport() async {
    
    dialogLoading(context);
    final isValidSeed = await validateMnemonic(_importAccModel.mnemonicCon.text);
    final isValidPw = await checkPassword(_importAccModel.pwCon.text);

    if (isValidSeed == false) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Align(
              child: Text('Opps'),
            ),
            content: const Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text('Invalid seed phrases'),
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
      //await dialog('Invalid seed phrases', 'Opps');
    }

    if (isValidPw == false) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Align(
              child: Text('Opps'),
            ),
            content: const Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text('PIN  verification failed'),
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

      //await dialog('PIN verification failed', 'Opps');
    }

    if (isValidSeed && isValidPw) {
      Navigator.pop(context);
      setState(() {
        enable = true;
      });

      final resPk = await ApiProvider().getPrivateKey(_importAccModel.mnemonicCon.text);
      if (resPk != null) {
        await ContractProvider().extractAddress(resPk);
        final res = await ApiProvider.keyring.store.encryptPrivateKey(resPk, _importAccModel.pwCon.text);

        if (res != null) {
          await StorageServices().writeSecure('private', res);
        }
      }
      
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();
      await Provider.of<ApiProvider>(context, listen: false).getAddressIcon();
      await Provider.of<ApiProvider>(context, listen: false).getCurrentAccount();
      
      await ContractsBalance().getAllAssetBalance(context: context);

      await successDialog(context, "imported your account.");
      // This Method Is Also Request Dot Contract

      // contract.kgoTokenWallet();
      // contract.selTokenWallet();
      // contract.selv2TokenWallet();
      // contract.bnbWallet();
      // contract.ethWallet();

      // Provider.of<ContractProvider>(context, listen: false).getEtherAddr();
      // Provider.of<ApiProvider>(context, listen: false).connectPolNon();
      // Provider.of<ContractProvider>(context, listen: false).getBnbBalance();
      // Provider.of<ContractProvider>(context, listen: false).getBscBalance();
      // Provider.of<ContractProvider>(context, listen: false).getEtherBalance();

      //selV2();

      await dialogSuccess(
        context,
        const Text("You haved imported successfully"),
        const Text('Congratulation'),
        // ignore: deprecated_member_use
        action: FlatButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                context, Home.route, ModalRoute.withName('/'));
          },
          child: const Text('Continue'),
        ),
      );
      Provider.of<ApiProvider>(context, listen: false).connectPolNon(context: context);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> isDotContain() async {
    // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('DOT');
    // Provider.of<ApiProvider>(context, listen: false).isDotContain();
    await Provider.of<ApiProvider>(context, listen: false).connectPolNon(context: context);
  }

  Future<bool> checkPassword(String pin) async {
    final res = await ApiProvider.sdk.api.keyring
        .checkPassword(ApiProvider.keyring.current, pin);
    return res;
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
            onChanged: widget.reimport != null ? null : onChanged,
            onSubmit: widget.reimport != null ? onSubmitIm : submit,
            clearInput: clearInput,
            enable: enable,
            submit: widget.reimport != null ? onSubmitIm : submit,
          ),
        ));
  }
}
