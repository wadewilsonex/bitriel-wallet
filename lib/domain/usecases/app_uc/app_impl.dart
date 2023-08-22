import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/auth_screen.dart';

class AppUsecasesImpl implements AppUsecases {

  final LocalAuthentication _localAuth = LocalAuthentication();
  
  BuildContext? _context;
  SDKProvider? sdkProvier;

  final ValueNotifier<bool> isEnableBiometric = ValueNotifier(false);

  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);

  final ValueNotifier<bool> canCheckBiometrics = ValueNotifier(false);

  set setBuildContext(BuildContext ctx){
    _context = ctx;
    sdkProvier = Provider.of<SDKProvider>(ctx, listen: true);
  }

  @override
  Future<bool> checkBiometrics() async {
    try {
      // Check For Support Device
      bool support = await LocalAuthentication().isDeviceSupported();
      if (support) {
        canCheckBiometrics.value = await LocalAuthentication().canCheckBiometrics;
      }
      

    } on PlatformException catch (e) {
        if (kDebugMode) {
          debugPrint("Error checkBiometrics $e");
        }
    }

    return canCheckBiometrics.value;
  }

  @override
  Future<bool> authenticateBiometric() async {
    // Trigger Authentication By Finger Print
    return await _localAuth.authenticate(
      localizedReason: 'Please complete the biometrics to proceed.'
    );

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

      isEnableBiometric.value = bool.parse(readBioVal!);

      // If False Means Navigation Occure Only For Splash Screen
      if (isPrivacy == false && isEnableBiometric.value == false) {
        Navigator.pushAndRemoveUntil(
          _context!,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false 
        );

      } else if (isEnableBiometric.value == true){

        Navigator.pushAndRemoveUntil(
          _context!,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false 
        );
      }

      return;
    } else {
      await checkAccountExist();
    }

  }

  @override
  Future<void> enableBiometric(bool switchValue) async {

    await authenticateBiometric().then((values) async {
        isAuthenticated.value = values;
        if (isAuthenticated.value) {

          isEnableBiometric.value = switchValue;

          // Save local storage key
          SecureStorage.writeBio(key: DbKey.bio, encodeValue: isEnableBiometric.value);
          

        } else if (isAuthenticated.value) {

          isEnableBiometric.value = switchValue;

          // Remove local storage key
          SecureStorage.deleteKey(DbKey.bio);

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