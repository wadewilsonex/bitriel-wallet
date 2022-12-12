import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/screen/main/social_login/otp_verification.dart';
import 'package:wallet_apps/src/screen/main/social_login/phonenumber/register/body_create_phonenumber.dart';

class CreateSeedPhoneNumber extends StatefulWidget {
  const CreateSeedPhoneNumber({Key? key}) : super(key: key);

  @override
  State<CreateSeedPhoneNumber> createState() => _CreateSeedPhoneNumberState();
}

class _CreateSeedPhoneNumberState extends State<CreateSeedPhoneNumber> {

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _register(String? getPhoneNumber) async {
    try {
      final response = await PostRequest().registerPhoneNumber(getPhoneNumber);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {

        if(!mounted) return;
        Navigator.push(context, Transition(child: OPTVerification(phoneNumber: getPhoneNumber), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          
      } else {
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
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CreateSeedPhoneNumberBody(
      phoneNumber: phoneNumberController,
      password: passwordController,
      confirmPassword: confirmPasswordController,
      register: _register,
    );
  }
}