import 'package:bitriel_wallet/index.dart';

class MultiAccountImpl implements MultiAccountUsecases {

  BuildContext? _context;

  SDKProvider? sdkProvier;

  set setContext(BuildContext ctx){
    _context = ctx;
    sdkProvier = Provider.of<SDKProvider>(ctx, listen: true);
  }

  KeyPairData get getAccount => sdkProvier!.getSdkImpl.getKeyring.current;

  List<KeyPairData> get getAllAccount => sdkProvier!.getSdkImpl.getKeyring.allAccounts;

  @override
  Future<void> accInfoFromLocalStorage() async {
    await SecureStorage.readData(key: DbKey.privateList).then((value) {
      print("value ${value}");
    });
  }

  @override
  Future<void> createWallet() async {

    await Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => const PincodeScreen())
    ).then((pin) async {
        
        if (pin != null){

          await Navigator.push(
            _context!,
            MaterialPageRoute(
              // builder: (context) => CreateWallet(isBackBtn: true, isAddNew: true, passCode: pinValue,)
              builder: (context) => CreateWalletScreen(pin: pin, isMultiAcc: true)
              // const ImportAcc(
              //   isBackBtn: true,
              // )
            )
          );

        }
      }
    );
    
  }

  @override
  Future<void> importWallet() async {

    await Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => const PincodeScreen())
    ).then((pin) async {
        
        if (pin != null){

          await Navigator.push(
            _context!,
            MaterialPageRoute(
              // builder: (context) => CreateWallet(isBackBtn: true, isAddNew: true, passCode: pinValue,)
              builder: (context) => ImportWalletScreen(pin: pin, isMultiAcc: true)
              // const ImportAcc(
              //   isBackBtn: true,
              // )
            )
          );
          // .then((accValue) {
          //   if (accValue != null && accValue == true){
          //     // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          //     // Provider.of<ApiProvider>(context, listen: false).notifyListeners();
          //   }
          // });
        }
      }
    );

  }

  Future<void> switchAccount(KeyPairData acc) async {
    
    sdkProvier!.getSdkImpl.getKeyring.setCurrent(acc);

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    sdkProvier!.notifyListeners();
  }
}