import 'package:wallet_apps/data/models/account.m.dart';
import 'package:wallet_apps/src/screen/home/menu/account/body_acc.dart';
import '../../../../../index.dart';

class Account extends StatefulWidget {

  static const route = '/account';
  final dynamic argument;
  final String? walletName;

  const Account({Key? key, this.argument, this.walletName}) : super(key: key);
  @override
  AccountState createState() => AccountState();
}

class AccountState extends State<Account> {

  final AccountM _accountModel = AccountM();

  ApiProvider? _apiProvider;

  String onChanged(String value) {
    _accountModel.backupKey.currentState!.validate();
    return value;
  }

  String onChangedChangePin(String value) {
    _accountModel.changePinKey.currentState!.validate();
    return value;
  }

  String onChangedBackup(String value) {
    _accountModel.backupKey.currentState!.validate();
    return value;
  }

  Future<void> onSubmit() async {
    if (_accountModel.backupKey.currentState!.validate()) {
      await getBackupKey(_accountModel.pinController.text);
    }
  }

  Future<void> submitBackUpKey() async {
    if (_accountModel.pinController.text.isNotEmpty) {
      await getBackupKey(_accountModel.pinController.text);
    }
  }

  Future<void> getBackupKey(String pass) async {
    
    Navigator.pop(context);
    try {
      // final pairs = await KeyringPrivateStore([0, 42])// (_api.getKeyring.keyPairs[0].pubKey, pass);
      final pairs = await _apiProvider!.getSdk.api.keyring.getDecryptedSeed(_apiProvider!.getKeyring, _apiProvider!.getKeyring.allAccounts[_accountModel.accIndex!], pass);
      // ['seed']
      if (pairs!.seed != null) {
        if(!mounted) return;
        await DialogComponents().customDialog(context, 'Backup Key', pairs.seed.toString(), txtButton: "Close",);
      } else {
        if(!mounted) return;
        await DialogComponents().customDialog(context, 'Backup Key', 'Incorrect Pin', txtButton: "Close",);
      }
    } catch (e) {
      
      if (kDebugMode) {
        
      }
    }
    _accountModel.pinController.text = '';
  }

  Future<void> _changeName() async {

    // dialogLoading(context);
    if (_accountModel.editNameController.text.isNotEmpty){
      
      final changePass = await _apiProvider!.getSdk.api.keyring.changeName(_apiProvider!.getKeyring, _apiProvider!.getKeyring.allAccounts[_accountModel.accIndex!], _accountModel.editNameController.text);
      // String funcName = "account";
      await _apiProvider!.getAddressIcon(accIndex: _accountModel.accIndex!);

      if(!mounted) return;
      // Navigator.pop(context);
      if (changePass.name!.isNotEmpty) {
        Navigator.pop(context);
        await DialogComponents().customDialog(context, 'Change Name', 'You name has changed!!!', txtButton: "Close",);
      } else {
        Navigator.pop(context);
        await DialogComponents().customDialog(context, 'Oops', 'Change Failed!!!', txtButton: "Close",);
      }
      
    }
  }

  void copyToClipBoard(String text, BuildContext context) {
    Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    ).then(
      (value) => {
        snackBar(context, "Copied to Clipboard")
      },
    );
  }

  void onSubmitName() {

  }

  void onChangeName() {
    
  }

  Future<void> submitChangePin() async {
    // if (_accountModel.oldPassController.text.isNotEmpty && _accountModel.newPassController.text.isNotEmpty) {
    //   await _changePin(_accountModel.oldPassController.text, _accountModel.newPassController.text);
    // }
  }

  Future<void> _changePin() async {

    dialogLoading(context);
    await _apiProvider!.getSdk.api.keyring.checkPassword(_apiProvider!.getKeyring.allAccounts[_accountModel.accIndex!], _accountModel.oldPinController.text);
    final changePass = await _apiProvider!.getSdk.api.keyring.changePassword(_apiProvider!.getKeyring, _apiProvider!.getKeyring.allAccounts[_accountModel.accIndex!], _accountModel.oldPinController.text, _accountModel.newPinController.text);
    if (changePass != null) {
      if(!mounted) return;
      await DialogComponents().customDialog(context, 'Change Pin', 'You pin has changed!!!', txtButton: "Close",);
    } else {
      if(!mounted) return;
      await DialogComponents().customDialog(context, 'Opps', 'Change Failed!!!', txtButton: "Close",);
    }

    // Close Dialog
    if(!mounted) return;
    Navigator.pop(context);
    
  }

  @override
  void initState() {

    _apiProvider = Provider.of<ApiProvider>(context, listen: false);

    _accountModel.currentAcc = _apiProvider!.getKeyring.current;
    _accountModel.editNameController.text = _apiProvider!.getKeyring.current.name!;
    
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AccountBody(
      walletName: widget.walletName,
      accountModel: _accountModel,
      onSubmitName: onSubmitName,
      onChangeName: onChangeName,
      onChangedBackup: onChangedBackup,
      onSubmit: onSubmit,
      onChangedChangePin: onChangedChangePin,
      onSubmitChangePin: submitChangePin,
      submitChangePin: _changePin,
      submitBackUpKey: submitBackUpKey,
      changeName: _changeName,
      // deleteAccout: deleteAccout
    );
  }
}