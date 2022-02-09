// import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:defichaindart/defichaindart.dart';
import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/account.m.dart';
// import 'package:bip39/bip39.dart' as bip39;
import 'package:wallet_apps/src/provider/provider.dart';

class MyUserInfo extends StatefulWidget {
  final String passPhrase;
  const MyUserInfo(this.passPhrase);

  @override
  State<StatefulWidget> createState() {
    return MyUserInfoState();
  }
}

class MyUserInfoState extends State<MyUserInfo> {

  final ModelUserInfo _userInfoM = ModelUserInfo();

  final MenuModel _menuModel = MenuModel();

  LocalAuthentication? _localAuth;

  @override
  void initState() {
    AppServices.noInternetConnection(_userInfoM.globalKey);
    /* If Registering Account */
    // if (widget.passwords != null) getToken();
    super.initState();
  }

  Future<void> enableScreenshot() async {
    try {

    await FlutterScreenshotSwitcher.enableScreenshots();
    } catch (e){
      print(e);
    }
  }

  @override
  void dispose() {
    /* Clear Everything When Pop Screen */
    _userInfoM.userNameCon.clear();
    _userInfoM.passwordCon.clear();
    _userInfoM.confirmPasswordCon.clear();
    _userInfoM.enable = false;
    super.dispose();
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> switchBiometric(bool switchValue) async {
    
    bool available = await AppServices().checkBiometrics(context);

    try {
      // Avaible To
      if (available) {
        // Switch Enable
        if (switchValue) {
          await authenticateBiometric(_localAuth!).then((values) async {
            if (_menuModel.authenticated!) {
              setState(() {
                _menuModel.switchBio = switchValue;
              });
              await StorageServices.saveBio(_menuModel.switchBio);
            }
          });
        }
        // Switch Disable
        else {
          await authenticateBiometric(_localAuth!).then((values) async {
            if (_menuModel.authenticated!) {
              setState(() {
                _menuModel.switchBio = switchValue;
              });
              await StorageServices.removeKey(DbKey.bio);
            }
          });
        }
      } else {
        snackBar(context, "Your device doesn't have finger print! Set up to enable this feature");
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: MyText(
                text: "Oops",
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text(e.toString(), textAlign: TextAlign.center),
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
    }
  }

  Future<bool> authenticateBiometric(LocalAuthentication _localAuth) async {
    // try {
    //   // Trigger Authentication By Finger Print
    //   _menuModel.authenticated =
    //       await _localAuth.authenticate(localizedReason: '', stickyAuth: true);
    //   // ignore: empty_catches
    // } on PlatformException {}
    // return _menuModel.authenticated!;
    return false;
  }

  void popScreen() {
    Navigator.pop(context);
  }

  void onSubmit() {
    if (_userInfoM.nodeFirstName.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.passwordNode);
    } else if (_userInfoM.passwordNode.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.confirmPasswordNode);
    } else {
      FocusScope.of(context).unfocus();
      if (_userInfoM.enable) submitAcc();
    }
  }

  String? onChanged(String value) {
    validateAll();
    return null;
  }

  String? validateFirstName(String value) {
    if (_userInfoM.nodeFirstName.hasFocus) {
      if (value.isEmpty) {
        return 'Please fill in username';
      }
    }
    return null;
  }

  String? validatePassword(String value) {
    if (_userInfoM.passwordNode.hasFocus) {
      if (value.isEmpty || value.length < 4) {
        return 'Please fill in 4-digits password';
      }
    }
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (_userInfoM.confirmPasswordNode.hasFocus) {
      if (value.isEmpty || value.length < 4) {
        return 'Please fill in 4-digits confirm password';
      } else if (_userInfoM.confirmPasswordCon.text !=
          _userInfoM.passwordCon.text) {
        return 'Password does not matched';
      }
    }
    return null;
  }

  void validateAll() {
    if (_userInfoM.userNameCon.text.isNotEmpty &&
        _userInfoM.passwordCon.text.isNotEmpty &&
        _userInfoM.confirmPasswordCon.text.isNotEmpty) {
      if (_userInfoM.passwordCon.text == _userInfoM.confirmPasswordCon.text) {
        setState(() {
          enableButton(true);
        });
      } else {
        setState(() {
          enableButton(false);
        });
        validateConfirmPassword('not match');
      }
    } else if (_userInfoM.enable) {
      setState(() {
        enableButton(false);
      });
    }
  }

  // Submit Profile User
  Future<void> submitAcc() async {
    // Show Loading Process
    dialogLoading(context, content: "This processing may take a bit longer\nPlease wait a moment");
    final _api = await Provider.of<ApiProvider>(context, listen: false);

    try {
      await addBtcWallet();
      final json = await _api.getSdk.api.keyring.importAccount(
        _api.getKeyring,
        keyType: KeyType.mnemonic,
        key: widget.passPhrase,
        name: _userInfoM.userNameCon.text,
        password: _userInfoM.confirmPasswordCon.text,
      );

      await _api.getSdk.api.keyring.addAccount(
        _api.getKeyring,
        keyType: KeyType.mnemonic,
        acc: json!,
        password: _userInfoM.confirmPasswordCon.text,
      ).then((value) async {
        _setAcc(_api);
        final _resPk = await _api.getPrivateKey(widget.passPhrase);

      // if (resPk != null) {
      // }
      await ContractProvider().extractAddress(_resPk);

      final res = await _api.encryptPrivateKey(_resPk, _userInfoM.confirmPasswordCon.text);
      await StorageServices().writeSecure(DbKey.private, res);
//1
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();
      await Provider.of<ApiProvider>(context, listen: false).getAddressIcon();
      await Provider.of<ApiProvider>(context, listen: false).getCurrentAccount();
      await queryBtcData();
      
      await ContractsBalance().getAllAssetBalance(context: context);

        // await Provider.of<ContractProvider>(context, listen: false)
        //     .getEtherAddr();

        // final contract =
        //     Provider.of<ContractProvider>(context, listen: false);

        // await contract.kgoTokenWallet();
        // await contract.selTokenWallet();
        // await contract.selv2TokenWallet();
        // await contract.bnbWallet();
        // await contract.ethWallet();

        // Provider.of<ApiProvider>(context, listen: false).connectPolNon();

        // await addBtcWallet();
        // await Provider.of<ContractProvider>(context, listen: false).sortAsset();

        // contract.setReady();

        // print("After contractProvider.sortListContract.length ${contractProvider.sortListContract.length}");
        await enableScreenshot();
        await successDialog(context, "Account is created.");
      });
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: Text('Opps'),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text(e.toString()),
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
    }
  }

  void _setAcc(ApiProvider api){

    AccountM accM = AccountM();
    accM.address = api.getKeyring.allAccounts[0].address;
    accM.addressIcon = api.getKeyring.allAccounts[0].icon;
    accM.name = api.getKeyring.allAccounts[0].name;
    accM.pubKey = api.getKeyring.allAccounts[0].pubKey;
    api.setAccount(accM);
    Provider.of<ContractProvider>(context, listen: false).setSELNativeAddr(accM.address!);
  }

  Future<void> queryBtcData() async {

    final contractPro = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);
    
    try {
      final seed = bip39.mnemonicToSeed(widget.passPhrase);
      final hdWallet = HDWallet.fromSeed(seed);
      
      contractPro.listContract[api.btcIndex].address = hdWallet.address!;
      
      final keyPair = ECPair.fromWIF(hdWallet.wif!);

      final bech32Address = new P2WPKH(data: new PaymentData(pubkey: keyPair.publicKey), network: bitcoin).data!.address;
      await StorageServices.storeData(bech32Address, DbKey.bech32);
      await StorageServices.storeData(hdWallet.address, DbKey.hdWallet);

      final res = await api.encryptPrivateKey(hdWallet.wif!, _userInfoM.confirmPasswordCon.text);

      await StorageServices().writeSecure(DbKey.btcwif, res);

      // Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain', context: context);

      // Provider.of<ApiProvider>(context, listen: false).setBtcAddr(bech32Address!);
      // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
      // await Provider.of<ApiProvider>(context, listen: false).getBtcBalance(hdWallet.address!, context: context);

    } catch (e) {
      print("Error queryBtcData $e");
    }
  }
  // Future<void> isDotContain() async {
  //   // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('DOT');
  //   // Provider.of<ApiProvider>(context, listen: false).isDotContain();
  //   Provider.of<ApiProvider>(context, listen: false).connectPolNon();
  //   // await StorageServices.readBool('DOT').then((value) {
  //   //   if (value) {
  //   //     Provider.of<WalletProvider>(context, listen: false)
  //   //         .addTokenSymbol('DOT');
  //   //     Provider.of<ApiProvider>(context, listen: false).isDotContain();
  //   //     Provider.of<ApiProvider>(context, listen: false).connectPolNon();
  //   //   }
  //   // });
  // }

  // Future<void> isBnbContain() async {
  //   Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BNB');
  //   Provider.of<ContractProvider>(context, listen: false).getBnbBalance();
  //   // await StorageServices.readBool('BNB').then((value) {
  //   //   if (value) {

  //   //   }
  //   // });
  // }

  // Future<void> isBscContain() async {
  //   Provider.of<WalletProvider>(context, listen: false)
  //       .addTokenSymbol('SEL (BEP-20)');
  //   Provider.of<ContractProvider>(context, listen: false).getSymbol();
  //   Provider.of<ContractProvider>(context, listen: false)
  //       .getBscDecimal()
  //       .then((value) {
  //     Provider.of<ContractProvider>(context, listen: false).getBscBalance();
  //   });

  //   // await StorageServices.readBool('SEL').then((value) {
  //   //   if (value) {

  //   //   }
  //   // });
  // }

  Future<void> addBtcWallet() async {
    // final seed = bip39.mnemonicToSeed(widget.passPhrase);
    // final hdWallet = HDWallet.fromSeed(seed);

    // final keyPair = ECPair.fromWIF(hdWallet.wif);
    // final bech32Address = new P2WPKH(data: new PaymentData(pubkey: keyPair.publicKey), network: bitcoin)
    //     .data
    //     .address;

    // await StorageServices.storeData(bech32Address, 'bech32');

    // final res = await _api.encryptPrivateKey(hdWallet.wif, _userInfoM.confirmPasswordCon.text);

    // if (res != null) {
    //   await StorageServices().writeSecure('btcwif', res);
    // }

    // Provider.of<ApiProvider>(context, listen: false).getBtcBalance(hdWallet.address, context: context);
    // Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain', context: context);

    // Provider.of<ApiProvider>(context, listen: false).setBtcAddr(bech32Address);
    // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
  }

  // Future<void> isKgoContain() async {
  //   Provider.of<ContractProvider>(context, listen: false)
  //       .getKgoDecimal()
  //       .then((value) {
  //     Provider.of<ContractProvider>(context, listen: false).getKgoBalance();
  //   });
  // }

  PopupMenuItem item(Map<String, dynamic> list) {
    return PopupMenuItem(
      value: list['gender'],
      child: Text("${list['gender']}"),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  // ignore: use_setters_to_change_properties
  void enableButton(bool value) => _userInfoM.enable = value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _userInfoM.globalKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: MyUserInfoBody(
          modelUserInfo: _userInfoM,
          onSubmit: onSubmit,
          onChanged: onChanged,
          validateFirstName: validateFirstName,
          validateMidName: validatePassword,
          validateLastName: validateConfirmPassword,
          submitProfile: submitAcc,
          popScreen: popScreen,
          switchBio: switchBiometric,
          item: item,
          model: _menuModel,
        ),
      ),
    );
  }
}
