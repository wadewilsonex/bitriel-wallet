import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/main/seeds_phonenumber/register/body_create_seed_phonenumber.dart';

class CreateSeedPhoneNumber extends StatefulWidget {
  const CreateSeedPhoneNumber({Key? key}) : super(key: key);

  @override
  State<CreateSeedPhoneNumber> createState() => _CreateSeedPhoneNumberState();
}

class _CreateSeedPhoneNumberState extends State<CreateSeedPhoneNumber> {

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
    return CreateSeedPhoneNumberBody(
      phoneNumber: phoneNumberController,
      password: passwordController,
    );
  }
}