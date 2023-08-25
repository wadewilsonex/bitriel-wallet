import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/auth_screen.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class AppUsecasesImpl implements AppUsecases {

  final LocalAuthentication _localAuth = LocalAuthentication();
  
  BuildContext? _context;
  SDKProvider? sdkProvider;

  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);

  int? accIndex;

  String? oldPass;
  String? newPass;

  final SecureStorageImpl _secureStorageImpl = SecureStorageImpl();

  set setBuildContext(BuildContext ctx){
    _context = ctx;
    sdkProvider = Provider.of<SDKProvider>(ctx, listen: true);
  }
    
  @override
  Future<bool> authenticateBiometric() async {
    // Trigger Authentication By Finger Print or PIN
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
        options: const AuthenticationOptions(useErrorDialogs: false),
      );
      return didAuthenticate;  // Return the authentication result
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Add handling of no hardware here.
        await QuickAlert.show(
          context: _context!,
          type: QuickAlertType.error,
          text: "Authentication not available",
        );
      } else if (e.code == auth_error.notEnrolled) {
        await QuickAlert.show(
          context: _context!,
          type: QuickAlertType.error,
          text: "Authentication not yet enrolled",
        );
      } else {
        // ...
      }
      return false;  // Return false in case of any exception
    }
  }

  @override
  Future<void> authPopup() async {
    
    await authenticateBiometric().then((value) {
      if(value == true) {
        Navigator.pushAndRemoveUntil(
          _context!,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false 
        );
      }
    });
  }

  // Called in privacy and splash screen
  @override
  Future<void> readBio({bool isPrivacy = false}) async{
    if (await SecureStorage.isContain(DbKey.bio)){
      
      final readBioVal = await SecureStorage.readData(key: DbKey.bio);

      isAuthenticated.value = bool.parse(readBioVal!);

      // If False Means Navigation Occure Only For Splash Screen

      // Splash Screen
      if (isPrivacy == false) {
        Navigator.pushAndRemoveUntil(
          _context!,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false 
        );
      }

      // return;

    } else if (isPrivacy == false) {
      await checkAccountExist();
    }

  }

  @override
  Future<void> enableBiometric(bool switchValue) async {

    await authenticateBiometric().then((values) async {
      
      isAuthenticated.value = switchValue;

      if (isAuthenticated.value) {
          // Save local storage key
          await SecureStorage.writeBio(key: DbKey.bio, encodeValue: isAuthenticated.value); 

        } else {
          // Remove local storage key
          await SecureStorage.deleteKey(DbKey.bio);

        }
      }
    );

  }
  
  @override
  Future<void> checkAccountExist() async {
    
    if (sdkProvider!.getSdkImpl.getKeyring.allAccounts.isNotEmpty){
      await Future.delayed(const Duration(milliseconds: 200), (){
        Navigator.pushAndRemoveUntil(
          _context!, 
          MaterialPageRoute(builder: (context) => const MainScreen()), 
          (route) => false
        );

      });
    } else {

      await Future.delayed(const Duration(milliseconds: 200), (){
        Navigator.pushAndRemoveUntil(
          _context!, 
          MaterialPageRoute(builder: (context) => const Welcome()), 
          (route) => false
        );

      });

    }
    
  }


  @override
  Future<void> changePin() async {
    
    try {
      await Navigator.push(
        _context!,
        MaterialPageRoute(builder: (context) => const PincodeScreen(title: "Current PIN", label: PinCodeLabel.fromChangePin,))
      ).then((oldPin) async {

        oldPass = oldPin;

        print("oldPass $oldPass");

        dialogLoading(_context!);

        await sdkProvider!.getSdkImpl.getWalletSdk.api.keyring.checkPassword(
          sdkProvider!.getSdkImpl.getKeyring.current, 
          oldPin
        ).then((value) async {
          
          print("check password $value");

          if(value == true) {
            // Close dialogLoading
            Navigator.pop(_context!);

            Navigator.push(
              _context!,
              MaterialPageRoute(builder: (context) => const PincodeScreen(title: "New PIN", label: PinCodeLabel.fromChangePin,))
            ).then((newPin) async {

              dialogLoading(_context!);

              newPass = newPin;

              print("new password $newPass");

              await sdkProvider!.getSdkImpl.getWalletSdk.api.keyring.changePassword(
                sdkProvider!.getSdkImpl.getKeyring, 
                sdkProvider!.getSdkImpl.getKeyring.current, 
                oldPass!, 
                newPass!
              );

              await updatePkWithNewPass();


              // Close dialogLoading
              Navigator.pop(_context!);

              await QuickAlert.show(
                context: _context!,
                type: QuickAlertType.success,
                text: "Your PIN has been changed.",
                barrierDismissible: false
              );

            });
          }
          else {
            Navigator.pop(_context!);

            await QuickAlert.show(
              context: _context!,
              type: QuickAlertType.error,
              text: "You entered incorrect PIN",
              barrierDismissible: false
            );
          }
        });

      });
    } catch (e) {

      Navigator.pop(_context!);
      
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.error,
        text: "$e",
        barrierDismissible: false
      );
    }

  }

  Future<void> updatePkWithNewPass() async {
    try {

      // Get Seeds From Decrypt
      final seeds = await KeyringPrivateStore(
        [sdkProvider!.getSdkImpl.sdkRepoImpl.nodes[0].ss58!]
      ).getDecryptedSeed(
        sdkProvider!.getSdkImpl.getKeyring.current.pubKey, 
        oldPass
      );



      print("res seed ${seeds!["seed"]}");

      // Get Private Key _resPk
      final resPk = sdkProvider!.getSdkImpl.getPrivateKey(seeds['seed']);

      print("resPk $resPk");

      // Re-Encrypt Private Key
      final res = await sdkProvider!.getSdkImpl.encryptPrivateKey(resPk.toString(), newPass!);

      print("resPk new pass $resPk");
      
      await _secureStorageImpl.writeSecure(DbKey.private, res!);

      await _secureStorageImpl.writeSecure(DbKey.pin, newPass!);


    } catch (e){
      
      if (kDebugMode) {
        debugPrint("Error updatePkWithNewPass $e");
      }
    } 
  }
  
}