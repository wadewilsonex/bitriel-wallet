import 'package:wallet_apps/index.dart';

class BioAuth {
  
  Future<bool> authenticateBiometric(LocalAuthentication localAuth) async {
    // Trigger Authentication By Finger Print
    // ignore: join_return_with_assignment
    return await localAuth.authenticate(
      localizedReason: 'Please complete the biometrics to proceed.'
      // stickyAuth: true,
    );

  }
}