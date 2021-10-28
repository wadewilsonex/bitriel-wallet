import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/main/import_user_info/import_user_info_body.dart';
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

  MenuModel _menuModel;

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
    final contractProvider =
        Provider.of<ContractProvider>(context, listen: false);
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);

    try {
      final json = await ApiProvider.sdk.api.keyring.importAccount(
        ApiProvider.keyring,
        keyType: KeyType.mnemonic,
        key: widget.passPhrase,
        name: _userInfoM.userNameCon.text,
        password: _userInfoM.confirmPasswordCon.text,
      );

      final acc = await ApiProvider.sdk.api.keyring.addAccount(
        ApiProvider.keyring,
        keyType: KeyType.mnemonic,
        acc: json,
        password: _userInfoM.confirmPasswordCon.text,
      );

      if (acc != null) {
        await addBtcWallet();
        final resPk = await ApiProvider().getPrivateKey(widget.passPhrase);
        if (resPk != null) {
          await ContractProvider().extractAddress(resPk);

          final res = await ApiProvider.keyring.store
              .encryptPrivateKey(resPk, _userInfoM.confirmPasswordCon.text);

          if (res != null) {
            await StorageServices().writeSecure('private', res);
          }
        }
        await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

        // await Provider.of<ContractProvider>(context, listen: false).getBscBalance();
        // await Provider.of<ContractProvider>(context, listen: false).getBscV2Balance();
        // await isKgoContain();
        // await Provider.of<ContractProvider>(context, listen: false).getEtherBalance();
        // await Provider.of<ContractProvider>(context, listen: false).getBnbBalance();

        // // This Method Is Also Request Dot Contract
        // await Provider.of<ApiProvider>(context, listen: false).connectPolNon();
//1
        await Provider.of<ApiProvider>(context, listen: false).getAddressIcon();
        await Provider.of<ApiProvider>(context, listen: false).getCurrentAccount();
        
        await ContractsBalance().getAllAssetBalance(context: context);
//2
        // // // Sort Contract Asset
        // await Provider.of<ContractProvider>(context, listen: false).sortAsset();
        
        // // // Ready To Display Asset Portfolio
        // Provider.of<ContractProvider>(context, listen: false).setReady();
        
        // await Provider.of<ApiProvider>(context, listen: false).getChainDecimal();

        await successDialog(context, "imported your account.");
        // This Method Is Also Request Dot Contract
        await Provider.of<ApiProvider>(context, listen: false).connectPolNon();
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: const Align(
              child: Text('Oops'),
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

      Navigator.pop(context);
    }
  }

  Future<void> getSavedContractToken() async {
    final contractProvider =
        Provider.of<ContractProvider>(context, listen: false);
    final res = await StorageServices.fetchData('contractList');

    if (res != null) {
      for (final i in res) {
        final symbol = await contractProvider.query(i.toString(), 'symbol', []);
        final decimal =
            await contractProvider.query(i.toString(), 'decimals', []);
        final balance = await contractProvider.query(i.toString(), 'balanceOf',
            [EthereumAddress.fromHex(contractProvider.ethAdd)]);

        contractProvider.addContractToken(TokenModel(
          contractAddr: i.toString(),
          decimal: decimal[0].toString(),
          symbol: symbol[0].toString(),
          balance: balance[0].toString(),
          org: 'BEP-20',
        ));
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('${symbol[0]} (BEP-20)');
      }
    }
  }

  Future<void> getEtherSavedContractToken() async {
    final contractProvider =
        Provider.of<ContractProvider>(context, listen: false);
    final res = await StorageServices.fetchData('ethContractList');

    if (res != null) {
      for (final i in res) {
        final symbol =
            await contractProvider.queryEther(i.toString(), 'symbol', []);
        final decimal =
            await contractProvider.queryEther(i.toString(), 'decimals', []);
        final balance = await contractProvider.queryEther(i.toString(),
            'balanceOf', [EthereumAddress.fromHex(contractProvider.ethAdd)]);

        contractProvider.addContractToken(TokenModel(
          contractAddr: i.toString(),
          decimal: decimal[0].toString(),
          symbol: symbol[0].toString(),
          balance: balance[0].toString(),
          org: 'ERC-20',
        ));
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('${symbol[0]} (ERC-20)');
      }
    }
  }

  Future<void> addBtcWallet() async {
    final seed = bip39.mnemonicToSeed(widget.passPhrase);
    final hdWallet = HDWallet.fromSeed(seed);
    final keyPair = ECPair.fromWIF(hdWallet.wif);

    final bech32Address = new P2WPKH(
            data: new PaymentData(pubkey: keyPair.publicKey), network: bitcoin)
        .data
        .address;

    await StorageServices.storeData(bech32Address, 'bech32');

    final res = await ApiProvider.keyring.store
        .encryptPrivateKey(hdWallet.wif, _userInfoM.confirmPasswordCon.text);

    if (res != null) {
      await StorageServices().writeSecure('btcwif', res);
    }

    Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain');

    Provider.of<ApiProvider>(context, listen: false).setBtcAddr(bech32Address);
    Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
    await Provider.of<ApiProvider>(context, listen: false).getBtcBalance(hdWallet.address, context: context);
  }

  // ignore: avoid_void_async
  void switchBiometric(bool switchValue) async {
    bool available = await AppServices().checkBiometrics(context);

    try {
      // Avaible To
      if (available) {
        // Switch Enable
        if (switchValue) {
          await authenticateBiometric(_localAuth).then((values) async {
            if (_menuModel.authenticated) {
              setState(() {
                _menuModel.switchBio = switchValue;
              });
              await StorageServices.saveBio(_menuModel.switchBio);
            }
          });
        }
        // Switch Disable
        else {
          await authenticateBiometric(_localAuth).then((values) async {
            if (_menuModel.authenticated) {
              setState(() {
                _menuModel.switchBio = switchValue;
              });
              await StorageServices.removeKey('bio');
            }
          });
        }
      } else {
        snackBar(context,
            "Your device doesn't have finger print! Set up to enable this feature");
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
    // Trigger Authentication By Finger Print
    // ignore: join_return_with_assignment
    _menuModel.authenticated = await _localAuth.authenticate(
      localizedReason: 'Please complete the biometrics to proceed.',
      stickyAuth: true,
    );

    return _menuModel.authenticated;
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
    _userInfoM.formStateAddUserInfo.currentState.validate();
    validateAll();
    return null;
  }

  String validateFirstName(String value) {
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

  String validatePassword(String value) {
    if (_userInfoM.passwordNode.hasFocus) {
      if (value.isEmpty || value.length < 4) {
        return 'Please fill in 4-digits password';
      }
    }
    return null;
  }

  String validateConfirmPassword(String value) {
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
        setState(() {
          enableButton(true);
        });
      }
    } else if (_userInfoM.enable) {
      setState(() {
        enableButton(false);
      });
    }
  }

  // Submit Profile User
  Future<void> submitProfile() async {
    // Show Loading Process
    dialogLoading(context,
        content: "This processing may take a bit longer\nPlease wait a moment");

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