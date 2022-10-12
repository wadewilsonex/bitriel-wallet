import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/main/create_seeds_phonenumber/body_create_seed_phonenumber.dart';

class CreateSeedPhoneNumber extends StatefulWidget {
  const CreateSeedPhoneNumber({Key? key}) : super(key: key);

  @override
  State<CreateSeedPhoneNumber> createState() => _CreateSeedPhoneNumberState();
}

class _CreateSeedPhoneNumberState extends State<CreateSeedPhoneNumber> {

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CreateSeedPhoneNumberBody(
      phoneNumber: phoneNumberController,
      password: passwordController,
    );
  }
}