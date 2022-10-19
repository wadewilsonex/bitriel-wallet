import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/screen/main/opt_seed/opt_seed.dart';
import 'package:wallet_apps/src/screen/main/seeds_phonenumber/login/body_login_phonenumber.dart';

class LoginSeedPhoneNumber extends StatefulWidget {
  const LoginSeedPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginSeedPhoneNumber> createState() => _LoginSeedPhoneNumberState();
}

class _LoginSeedPhoneNumberState extends State<LoginSeedPhoneNumber> {

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(String getPhoneNumber) async {
    try {
      final response = await PostRequest().loginPhoneNumber(phoneNumberController.text);

      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {

        if(!mounted) return;
        Navigator.push(context, Transition(child: OPTVerification(phoneNumber: getPhoneNumber), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          
      } 
      else {
        if(!mounted) return;
        await customDialog(
          context, 
          "Error",
          responseJson['message']
        );
      }

    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginSeedPhoneNumberBody(
      phoneNumber: phoneNumberController,
      password: passwordController,
      login: _login,
    );
  }
}