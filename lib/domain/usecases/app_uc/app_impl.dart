import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/auth_screen.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class AppUsecasesImpl implements AppUsecases {

  final LocalAuthentication _localAuth = LocalAuthentication();
  
  BuildContext? _context;
  SDKProvider? sdkProvier;

  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);

  set setBuildContext(BuildContext ctx){
    _context = ctx;
    sdkProvier = Provider.of<SDKProvider>(ctx, listen: true);
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
    
    if (sdkProvier!.getSdkImpl.getKeyring.allAccounts.isNotEmpty){
      await Future.delayed(const Duration(milliseconds: 200), (){
        Navigator.pushAndRemoveUntil(
          _context!, 
          MaterialPageRoute(builder: (context) => const MainScreen()), 
          // MaterialPageRoute(builder: (context) => const AddAsset()), 
          (route) => false
        );

      });
    } else {

      await Future.delayed(const Duration(milliseconds: 200), (){
        Navigator.pushAndRemoveUntil(
          _context!, 
          MaterialPageRoute(builder: (context) => const Welcome()), 
          // MaterialPageRoute(builder: (context) => const AddAsset()), 
          (route) => false
        );

      });

    }
    
  }
  
}