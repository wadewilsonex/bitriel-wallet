import 'package:bitriel_wallet/index.dart';

class MultiAccountImpl implements MultiAccountUsecases {

  BuildContext? _context;

  SDKProvider? sdkProvier;

  WalletProvider? walletProvider;

  void setContext(BuildContext ctx, {bool listen = true}){
    _context = ctx;
    sdkProvier = Provider.of<SDKProvider>(ctx, listen: listen);
    walletProvider = Provider.of<WalletProvider>(ctx, listen: listen);
  }

  KeyPairData get getAccount => sdkProvier!.getSdkImpl.getKeyring.current;

  List<KeyPairData> get getAllAccount => sdkProvier!.getSdkImpl.getKeyring.allAccounts;

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
    
    dialogLoading(_context!);
      
    await sdkProvier!.fetchAllAccount();

    // reset wallet state
    walletProvider!.initState();

    // Refetch asset balance
    await walletProvider!.getAsset();

    sdkProvier!.getSdkImpl.getKeyring.setCurrent(acc);

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    sdkProvier!.notifyListeners();
    Navigator.pop(_context!);
  }
}