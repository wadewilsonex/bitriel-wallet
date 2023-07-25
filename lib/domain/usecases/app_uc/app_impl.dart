import 'package:bitriel_wallet/index.dart';

class AppUsecasesImpl implements AppUsecases {
  
  BuildContext? _context;
  SDKProvider? sdkProvier;

  set setBuildContext(BuildContext ctx){
    _context = ctx;
    sdkProvier = Provider.of<SDKProvider>(ctx, listen: true);
  }
  
  @override
  Future<void> checkAccountExist() async {

    if (sdkProvier!.getSdkImpl.getKeyring.allAccounts.isNotEmpty){
      await Future.delayed(const Duration(seconds: 1), (){

        Navigator.pushAndRemoveUntil(
          _context!, 
          // MaterialPageRoute(builder: (context) => const HomeScreen()), 
          MaterialPageRoute(builder: (context) => const AddAsset()), 
          (route) => false
        );
      });
    }
    
  }
  
}