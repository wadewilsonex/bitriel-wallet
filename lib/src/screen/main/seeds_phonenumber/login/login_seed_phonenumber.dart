import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/main/seeds_phonenumber/login/body_login_seed_phonenumber.dart';

class LoginSeedPhoneNumber extends StatefulWidget {
  const LoginSeedPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginSeedPhoneNumber> createState() => _LoginSeedPhoneNumberState();
}

class _LoginSeedPhoneNumberState extends State<LoginSeedPhoneNumber> {

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
    );
  }
}