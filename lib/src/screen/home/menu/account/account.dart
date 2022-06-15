import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/account.m.dart';
import 'package:wallet_apps/src/screen/home/menu/account/body_acc.dart';
import '../../../../../index.dart';

class Account extends StatefulWidget {
  //static const route = '/account';
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  AccountM _accountModel = AccountM();

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
  

  Future<void> deleteAccout() async {
    await customDialog(
      context, 
      'Delete account', 
      'Are you sure to delete your account?',
      btn2: TextButton(
        onPressed: () async => await _deleteAccount(),
        child: MyText(
          text: 'Delete',
          color: AppColors.redColor,
          fontWeight: FontWeight.w700
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {

    dialogLoading(context);

    final _api = await Provider.of<ApiProvider>(context, listen: false);
    
    try {
      await _api.apiKeyring.deleteAccount(
        _api.getKeyring,
        _accountModel.currentAcc!,
      );

      final mode = await StorageServices.fetchData(DbKey.themeMode);
      // final event = await StorageServices.fetchData(DbKey.event);

      await StorageServices().clearStorage();

      // Re-Save Them Mode
      await StorageServices.storeData(mode, DbKey.themeMode);
      // await StorageServices.storeData(event, DbKey.event);

      await StorageServices().clearSecure();
      
      Provider.of<ContractProvider>(context, listen: false).resetConObject();

      await Future.delayed(Duration(seconds: 2), () {});
      
      Provider.of<WalletProvider>(context, listen: false).clearPortfolio();

      Navigator.pushAndRemoveUntil(context, RouteAnimation(enterPage: Welcome()), ModalRoute.withName('/'));
    } catch (e) {
      if (ApiProvider().isDebug == true) print("_deleteAccount ${e.toString()}");
      // await dialog(context, e.toString(), 'Opps');
    }
  }

  Future<void> getBackupKey(String pass) async {
    
    Navigator.pop(context);
    final _api = await Provider.of<ApiProvider>(context, listen: false);
    try {
      // final pairs = await KeyringPrivateStore([0, 42])// (_api.getKeyring.keyPairs[0].pubKey, pass);
      final pairs = await KeyringPrivateStore([_api.isMainnet ? AppConfig.networkList[0].ss58MN! : AppConfig.networkList[0].ss58!]).getDecryptedSeed(_api.getKeyring.keyPairs[0].pubKey, pass);
      if (pairs!['seed'] != null) {
        await customDialog(context, 'Backup Key', pairs['seed'].toString());
      } else {
        await customDialog(context, 'Backup Key', 'Incorrect Pin');
      }
    } catch (e) {
      //await dialog(context, e.toString(), 'Opps');
      if (ApiProvider().isDebug == true) print("Error getBackupKey $e");
    }
    _accountModel.pinController.text = '';
  }

  Future<void> _changeName() async {
    dialogLoading(context);
    if (_accountModel.editNameController.text.isNotEmpty){
      dialogLoading(context);
      final api = await Provider.of<ApiProvider>(context, listen: false);
      final changePass = await api.apiKeyring.changeName(api.getKeyring, _accountModel.editNameController.text);
      String funcName = "account";
      await api.getAddressIcon();
      while(true){
        print("funcName $funcName");
        await api.getCurrentAccount(context: context, funcName: funcName);
        if (api.accountM.address != null) break;
        else funcName = 'keyring';
      }

      Navigator.pop(context);
      if (changePass != null) {
        await customDialog(context, 'Change Name', 'You name has changed!!!');
      } else {
        await customDialog(context, 'Oops', 'Change Failed!!!');
      }

      _accountModel.editNameController.text = '';
      // Close Dialog
      Navigator.pop(context);
    }
  }

  void copyToClipBoard(String text, BuildContext context) {
    Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    ).then(
      (value) => {
        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to Clipboard'),
            duration: Duration(seconds: 3),
          ),
        ),
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

    // setState(() {
    //   _accountModel.loading = true;
    // });
    dialogLoading(context);
    final res = await Provider.of<ApiProvider>(context, listen: false);
    await res.apiKeyring.checkPassword(res.getKeyring.keyPairs[0], _accountModel.oldPinController.text).then((value) {
      print("checkPassword $value");
    });
    final changePass = await res.apiKeyring.changePassword(res.getKeyring, _accountModel.oldPinController.text, _accountModel.newPinController.text);
    if (changePass != null) {
      await customDialog(context, 'Change Pin', 'You pin has changed!!!');
    } else {

      await customDialog(context, 'Opps', 'Change Failed!!!');
    }

    // Close Dialog
    Navigator.pop(context);
    // _accountModel.oldPassController.text = '';
    // _accountModel.newPassController.text = '';
    // _accountModel.oldNode.requestFocus();
  }

  @override
  void initState() {

    _accountModel.currentAcc = Provider.of<ApiProvider>(context, listen: false).getKeyring.keyPairs[0];
    _accountModel.editNameController.text = Provider.of<ApiProvider>(context, listen: false).accountM.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AccountBody(
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
      deleteAccout: deleteAccout
    );
  }
}
