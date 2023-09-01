import 'package:bitriel_wallet/index.dart';

class MultiAccountImpl implements MultiAccountUsecases {

  BuildContext? _context;

  SDKProvider? sdkProvider;

  WalletProvider? walletProvider;

  TextEditingController walletNameConroller = TextEditingController();

  int? accIndex;

  void initTxtController(int index) {
    accIndex = index;
    walletNameConroller.text = sdkProvider!.getSdkImpl.getKeyring.allAccounts[accIndex!].name!;
  }

  void setContext(BuildContext ctx, {bool listen = true}){
    _context = ctx;
    sdkProvider = Provider.of<SDKProvider>(ctx, listen: listen);
    walletProvider = Provider.of<WalletProvider>(ctx, listen: listen);
  }

  KeyPairData get getAccount => sdkProvider!.getSdkImpl.getKeyring.current;

  List<KeyPairData> get getAllAccount => sdkProvider!.getSdkImpl.getKeyring.allAccounts;

  @override
  Future<void> createWallet() async {

    await Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => const PincodeScreen(title: "Create a PIN",))
    ).then((pin) async {
        
        if (pin != null){

          await Navigator.push(
            _context!,
            MaterialPageRoute(
              builder: (context) => CreateWalletScreen(pin: pin, isMultiAcc: true)
            )
          ).then((value) async {

            // // Refetch asset balance
            await walletProvider!.getAsset();
          });

        }
      }
    );
    
  }

  @override
  Future<void> importWallet() async {

    await Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => const PincodeScreen(title: "Create a PIN",))
    ).then((pin) async {
        
        if (pin != null){

          await Navigator.push(
            _context!,
            MaterialPageRoute(
              builder: (context) => ImportWalletScreen(pin: pin, isMultiAcc: true)
            )
          ).then((value) async {

            // // Refetch asset balance
            await walletProvider!.getAsset();
          });
        }
      }
    );

  }

  @override
  Future<void> switchAccount(KeyPairData acc, int index) async {
    
    dialogLoading(_context!);
      
    sdkProvider!.getSdkImpl.getKeyring.setCurrent(acc);
    
    await sdkProvider!.fetchAllAccount();

    // // Refetch asset balance
    await walletProvider!.getAsset();

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    sdkProvider!.notifyListeners();
    
    await SecureStorage.writeData(key: DbKey.private, encodeValue: sdkProvider!.getUnverifyAcc[index].pubKey);

    Navigator.pop(_context!);
  }

  @override
  Future<void> changeWalletName(String newName) async {

    if(newName.isNotEmpty) {
     
      await sdkProvider!.getSdkImpl.getWalletSdk.api.keyring.changeName(
        sdkProvider!.getSdkImpl.getKeyring, 
        sdkProvider!.getSdkImpl.getKeyring.allAccounts[accIndex!], 
        newName
      ).then((value) async{
          await QuickAlert.show(
          context: _context!,
          type: QuickAlertType.success,
          text: 'Wallet Name has been changed.',
        );
      });

      sdkProvider!.updateWalletNameData();

    }
    else{
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.error,
        text: 'Wallet Name cannot empty field.',
      );
    }
  }

  @override
  Future<void> getMnemonic() async {
    
    try {
      
      await Navigator.push(
        _context!,
        MaterialPageRoute(builder: (context) => const PincodeScreen(title: "PIN", label: PinCodeLabel.fromBackUp,))
      ).then((pin) async {

        if (pin != null){

           try {

            await sdkProvider!.getSdkImpl.decryptPrivateKey(
              privateKey: sdkProvider!.getUnverifyAcc[accIndex!].pubKey, 
              pin: pin
            );

          } catch (e) {
            throw "You entered incorrect PIN";
          }

          final getSeed = await sdkProvider!.getSdkImpl.getWalletSdk.api.keyring.getDecryptedSeed(
            sdkProvider!.getSdkImpl.getKeyring, 
            sdkProvider!.getSdkImpl.getKeyring.allAccounts[accIndex!],
            pin
          );

          await Navigator.push(
            _context!,
            MaterialPageRoute(
              builder: (context) => BackUpWalletScreen(mnemonicKey: getSeed!.seed!)
            )
          );

        }
        
      });

    } catch (e) {

      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.error,
        text: "$e",
        barrierDismissible: false
      );

    }

  }

}