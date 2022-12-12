import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';

class GoogleAuthService extends ChangeNotifier {

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email'
    ],
  );

  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          return HomePage();
        }
        else{
          return Onboarding();
        }
      },
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      print("signInWithGoogle");
      // Trigger the authentication flow
      return await _googleSignIn.signIn().then((ggUser) async {
        
        print("googleUser $ggUser");

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await ggUser!.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithCredential(credential);
      });
    } catch (e) {
      print("Error signInWithGoogle $e");
    }

    return null;
  }

  Future<void> signOut() async {

    try {

      print("FirebaseAuth.instance ${FirebaseAuth.instance.currentUser}");
      await _googleSignIn.signOut();

      print("FirebaseAuth.instance ${FirebaseAuth.instance.currentUser}");
    } catch (e) {
      print("Err signOut $e");
    }
  }

}