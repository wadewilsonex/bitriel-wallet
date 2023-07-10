import 'package:bitriel_wallet/index.dart';

class ImportWalletImpl implements ImportWalletUsecases {

  BuildContext? context;

  TextEditingController seedController = TextEditingController();
  
  /// For Import Wallet
  ValueNotifier<bool> isSeedValid = ValueNotifier(false);

  SDKProvier? sdkProvider;
  
  final AccountManagementImpl _accountManagementImpl = AccountManagementImpl();

  set setContext(BuildContext ctx) {
    context = ctx;
    sdkProvider = Provider.of<SDKProvier>(ctx, listen: false);
  }
  
  /* ----------Import Account Functional---------- */
  
  @override
  void changeState(String seed){
    if (seed.split(" ").toList().length == 12 && seed.split(" ").toList().last != ""){
      isSeedValid.value = true;
    } else if (isSeedValid.value) {
      isSeedValid.value = false;
    }
  }

  @override
  void resetState(){
    isSeedValid.value = false;
  }

  @override
  Future<void> addAndImport(String pin) async {

    dialogLoading(context!);
    await _accountManagementImpl.addAndImport(sdkProvider!, context!, seedController.text, pin);

    // Close Dialog
    Navigator.pop(context!);
  }

}