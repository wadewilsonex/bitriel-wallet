// import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/index.dart';
// import 'package:bip32/bip32.dart' as bip32;
// import 'package:dart_ecpair/dart_ecpair.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/main/import_user_info/import_user_info_body.dart';
import 'package:wallet_apps/src/service/authen_s.dart';
import 'package:web3dart/credentials.dart';

class ImportUserInfo extends StatefulWidget {
  final String passPhrase;

  static const route = '/importUserInfo';

  const ImportUserInfo(this.passPhrase);

  @override
  State<StatefulWidget> createState() {
    return ImportUserInfoState();
  }
}

class ImportUserInfoState extends State<ImportUserInfo> {
  final ModelUserInfo _userInfoM = ModelUserInfo();

  LocalAuthentication _localAuth = LocalAuthentication();

  MenuModel? _menuModel;

  // KeyringStorage _keyringStorage = KeyringStorage();

  @override
  void initState() {
    _menuModel = MenuModel();
    AppServices.noInternetConnection(_userInfoM.globalKey);
    super.initState();
  }

  @override
  void dispose() {
    _userInfoM.userNameCon.clear();
    _userInfoM.passwordCon.clear();
    _userInfoM.confirmPasswordCon.clear();
    _userInfoM.enable = false;
    super.dispose();
  }

  Future<void> _importFromMnemonic() async {
    
    final _api = Provider.of<ApiProvider>(context, listen: false);
    try {

      dynamic json = await _api.apiKeyring.importAccount(
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
      //   acc: json!,
      //   password: _userInfoM.confirmPasswordCon.text,
      // );

      await _api.apiKeyring.addAccount(// _api.getSdk.api.keyring.addAccount(
        _api.getKeyring,
        keyType: KeyType.mnemonic,
        acc: json,
        password: _userInfoM.confirmPasswordCon.text,
      );

      /// Cannot connect Both Network On the Same time
      /// 
      /// It will be wrong data of that each connection. 
      /// 
      /// This Function Connect Polkadot Network And then Connect Selendra Network
      await _api.connectSELNode(context: context).then((value) async {

        await _api.connectSELNode(context: context);

        await _api.getAddressIcon();
          // Get From Account js
        await _api.getCurrentAccount(context: context);

        final _resPk = await _api.getPrivateKey(widget.passPhrase);
        
        await ContractProvider().extractAddress(_resPk);

        final _res = await _api.encryptPrivateKey(_resPk, _userInfoM.confirmPasswordCon.text);
        
        await StorageServices().writeSecure(DbKey.private, _res);

        await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

        // This Query Might Freeze for a second if User await keyword
        // await queryBtcData();

        await ContractsBalance().getAllAssetBalance(context: context);

      //     //////

      //     await StorageServices().clearStorage();

      //     await StorageServices().clearSecure();
          
      //     Provider.of<ContractProvider>(context, listen: false).resetConObject();

      //     await Future.delayed(Duration(seconds: 2), () {});
          
      //     Provider.of<WalletProvider>(context, listen: false).clearPortfolio();

      //     Navigator.pushAndRemoveUntil(context, RouteAnimation(enterPage: Welcome()), ModalRoute.withName('/'));
      // /////
      });
      await successDialog(context, "imported your account.");
    } catch (e) {

      Navigator.pop(context);
      await customDialog(context, 'Oops', e.toString());
    }
  }

  Future<void> getSavedContractToken() async {
    final contractProvider = Provider.of<ContractProvider>(context, listen: false);
    final res = await StorageServices.fetchData(DbKey.contactList);

    if (res != null) {
      for (final i in res) {
        final symbol = await contractProvider.query(i.toString(), 'symbol', []);
        final decimal = await contractProvider.query(i.toString(), 'decimals', []);
        final balance = await contractProvider.query(i.toString(), 'balanceOf',[EthereumAddress.fromHex(contractProvider.ethAdd)]);

        contractProvider.addContractToken(TokenModel(
          contractAddr: i.toString(),
          decimal: decimal[0].toString(),
          symbol: symbol[0].toString(),
          balance: balance[0].toString(),
          org: 'BEP-20',
        ));
        Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('${symbol[0]} (BEP-20)');
      }
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

  // Future<void> encryptSeedAndSave(String? pubKey, seed, KeyType seedType, password) async {
  //   try {

  //     final String key = Encryptt.passwordToEncryptKey(password);
  //     String? encrypted = await FlutterAesEcbPkcs5.encryptString(seed, key);

  //     // read old data from storage-old
  //     final Map stored = await (StorageServices.getSeeds(seedType.name) as Future<Map<dynamic, dynamic>>);
  //     stored[pubKey] = encrypted;
  //     // and save to new storage
  //     if (seedType == KeyType.mnemonic.toString().split('.')[1]) {
  //       final mnemonics = Map.from(_keyringStorage.encryptedMnemonics.val);
  //       mnemonics.addAll(stored);
  //       _keyringStorage.encryptedMnemonics.val = mnemonics;
  //       return;
  //     }
  //     if (seedType == KeyType.rawSeed.toString().split('.')[1]) {
  //       final seeds = Map.from(_keyringStorage.encryptedRawSeeds.val);
  //       seeds.addAll(stored);
  //       _keyringStorage.encryptedRawSeeds.val = seeds;
  //     }
  //   } catch (e) {
  //     print("Error $e");
  //   }
  // }

  // ignore: avoid_void_async
  void switchBiometric(bool switchValue) async {
    bool available = await AppServices().checkBiometrics(context);

    try {
      // Avaible To
      if (available) {
        await BioAuth().authenticateBiometric(_localAuth).then((values) async {
           
          _menuModel!.authenticated = values;
          if (_menuModel!.authenticated!) {
            _menuModel!.switchBio = switchValue;
            await StorageServices.saveBio(_menuModel!.switchBio);
          } else if (_menuModel!.authenticated!) {
            _menuModel!.switchBio = switchValue;
            await StorageServices.removeKey(DbKey.bio);
          }
          setState(() { });
        });
      } else {
        snackBar(context, "Your device doesn't have finger print! Set up to enable this feature");
      }
    } catch (e) {
      await customDialog(context, 'Oops', 'e.toString()');
    }
  }

  void popScreen() {
    Navigator.pop(context);
  }

  Future<void> onSubmit() async {
    if (_userInfoM.nodeFirstName.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.passwordNode);
    } else if (_userInfoM.passwordNode.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.confirmPasswordNode);
    } else {
      FocusScope.of(context).unfocus();
      validateAll();
      if (_userInfoM.enable) await submitProfile();
    }
  }

  String onChanged(String value) {
    // _userInfoM.formStateAddUserInfo.currentState!.validate();
    validateAll();
    return value;
  }

  String? validateFirstName(String value) {
    if (_userInfoM.nodeFirstName.hasFocus) {
      if (value.isEmpty) {
        return 'Please fill in username';
      } else if (_userInfoM.confirmPasswordCon.text !=
          _userInfoM.passwordCon.text) {
        return 'Password does not matched';
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
        return 'Please fill in 4-digits confirm pin';
      } else if (_userInfoM.confirmPasswordCon.text !=
          _userInfoM.passwordCon.text) {
        return 'Pin does not matched';
      }
    }

    return null;
  }

  void validateAll() {
    if (_userInfoM.userNameCon.text.isNotEmpty &&
        _userInfoM.passwordCon.text.isNotEmpty &&
        _userInfoM.confirmPasswordCon.text.isNotEmpty) {
      if (_userInfoM.passwordCon.text == _userInfoM.confirmPasswordCon.text) {
        // setState(() {
        // });
          enableButton(true);
      }
    } else if (_userInfoM.enable) {
        enableButton(false);
      // setState(() {
      // });
    }
  }

  // Submit Profile User
  Future<void> submitProfile() async {
    // Show Loading Process
    dialogLoading(context, content: "This processing may take a bit longer\nPlease wait a moment");

    await _importFromMnemonic();
  }

  PopupMenuItem item(Map<String, dynamic> list) {
    return PopupMenuItem(
      value: list['gender'],
      child: Text("${list['gender']}"),
    );
  }

  // ignore: use_setters_to_change_properties
  // ignore: avoid_positional_boolean_parameters
  void enableButton(bool value) => _userInfoM.enable = value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _userInfoM.globalKey,
      body: ImportUserInfoBody(
        modelUserInfo: _userInfoM,
        onSubmit: onSubmit,
        onChanged: onChanged,
        validateFirstName: validateFirstName,
        validatepassword: validatePassword,
        validateConfirmPassword: validateConfirmPassword,
        submitProfile: submitProfile,
        popScreen: popScreen,
        switchBio: switchBiometric,
        menuModel: _menuModel,
        item: item,
      ),
    );
  }
}
