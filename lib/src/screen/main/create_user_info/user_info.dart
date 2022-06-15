// import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:defichaindart/defichaindart.dart';
import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/service/authen_s.dart';

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

  LocalAuthentication? _localAuth = LocalAuthentication();

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
      if (ApiProvider().isDebug == true) print("Error enableScreenshot $e");
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
      // Avaible To
      if (available) {
        await BioAuth().authenticateBiometric(_localAuth!).then((values) async {
          
          _menuModel.authenticated = values;
          if (_menuModel.authenticated!) {
            _menuModel.switchBio = switchValue;
            await StorageServices.saveBio(_menuModel.switchBio);
          } else if (_menuModel.authenticated!) {
            _menuModel.switchBio = switchValue;
            await StorageServices.removeKey(DbKey.bio);
          }
          setState(() { });
        });
      } else {
        snackBar(context, "Your device doesn't have finger print! Set up to enable this feature");
      }
    } catch (e) {
      await customDialog(context, 'Oops', e.toString());
    }
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
      dynamic _json = await _api.apiKeyring.importAccount(
        _api.getKeyring,
        keyType: KeyType.mnemonic,
        key: widget.passPhrase,
        name: _userInfoM.userNameCon.text,
        password: _userInfoM.confirmPasswordCon.text,
      );
      
      // For encryptSeed
      // await _api.addAccount(
      //   _api.getKeyring,
      //   keyType: KeyType.mnemonic,
      //   acc: _json!,
      //   password: _userInfoM.confirmPasswordCon.text,
      // );

      await _api.apiKeyring.addAccount(// _api.getSdk.api.keyring.addAccount(
        _api.getKeyring,
        keyType: KeyType.mnemonic,
        acc: _json,
        password: _userInfoM.confirmPasswordCon.text,
      ).then((value) async {

        final _resPk = await _api.getPrivateKey(widget.passPhrase);

        /// Cannot connect Both Network On the Same time
        /// 
        /// It will be wrong data of that each connection. 
        /// 
        /// This Function Connect Polkadot Network And then Connect Selendra Network
        await _api.connectSELNode(context: context).then((value) async {

          await _api.getAddressIcon();
          // Get From Account js
          await _api.getCurrentAccount(context: context);

          await ContractProvider().extractAddress(_resPk);

          final _res = await _api.encryptPrivateKey(_resPk, _userInfoM.confirmPasswordCon.text);
          
          await StorageServices().writeSecure(DbKey.private, _res);

          await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();
          
          await _api.queryBtcData(context, widget.passPhrase, _userInfoM.confirmPasswordCon.text);

          await ContractsBalance().getAllAssetBalance(context: context);
          await successDialog(context, "Account is created.");
        }); 

      });
    } catch (e) {
      await customDialog(context, 'Oops', e.toString());
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
          popScreen: (){
            Navigator.pop(context);
          },
          switchBio: switchBiometric,
          item: item,
          model: _menuModel,
        ),
      ),
    );
  }
}
