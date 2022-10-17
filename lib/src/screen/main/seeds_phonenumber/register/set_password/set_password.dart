import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';

class SetPassword extends StatefulWidget {
  final String phoneNumber;
  const SetPassword({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

    Future<void> _registerWallet() async {
    try {
      final response = await PostRequest().registerSetPassword(widget.phoneNumber, password.text, confirmPassword.text);

      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {

        if(!mounted) return;
        // Navigator.push(context, Transition(child: OPTVerification(phoneNumber: getPhoneNumber), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        child: Container(
          padding: const EdgeInsets.all(paddingSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MyText(
                text: "Set the password \nto encryption your wallet",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
                top: 25,
              ),

              SizedBox(height: 10.h),

              tfPasswordWidget(password, "Password"),
              
              SizedBox(height: 1.h),

              tfPasswordWidget(confirmPassword, "Confirm Password"),

              SizedBox(height: 10.h),

              MyGradientButton(
                textButton: "Finish",
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () {
                  _registerWallet();
                  // Navigator.push(context, Transition(child: OPTVerification(phoneNumber: getPhoneNumber), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}