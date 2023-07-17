import 'package:bitriel_wallet/index.dart';

class AppUsecasesImpl implements AppUsecases {
  
  BuildContext? _context;
  SDKProvier? sdkProvier;

  set setBuildContext(BuildContext ctx){
    _context = ctx;
    sdkProvier = Provider.of<SDKProvier>(ctx, listen: true);
  }
  
  @override
  Future<void> checkAccountExist() async {

    print("sdkProvier!.getSdkProvider.getKeyring.allAccounts.isNotEmpty ${sdkProvier!.getSdkImpl.getKeyring.allAccounts.isNotEmpty}");
    if (sdkProvier!.getSdkImpl.getKeyring.allAccounts.isNotEmpty){
      await Future.delayed(const Duration(seconds: 1), (){

        Navigator.pushAndRemoveUntil(
          _context!, 
          MaterialPageRoute(builder: (context) => const HomeScreen()), 
          (route) => false
        );
      });
    }
    
  }
  
}