// import 'package:form_validation/form_validation.dart';
// import 'package:http/http.dart';
// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/components/login_component/animations/change_screen_animation.dart';
// import 'package:wallet_apps/src/components/login_component/helper_functions.dart';
// import 'package:wallet_apps/src/models/email_m.dart';
// import 'package:wallet_apps/src/presentation/home/home/home.dart';
// import 'package:wallet_apps/src/presentation/main/email/body_email.dart';
// import 'package:wallet_apps/src/presentation/main/email/login_content.dart';
// import 'package:wallet_apps/src/presentation/main/json/import_json.dart';
// import 'package:wallet_apps/src/presentation/main/seeds_phonenumber/register/set_password/set_password.dart';

// enum Screens {
//   createAccount,
//   welcomeBack,
// }

// class Email extends StatefulWidget {
//   const Email({Key? key}) : super(key: key);

//   @override
//   State<Email> createState() => _EmailState();
// }

// class _EmailState extends State<Email>  with TickerProviderStateMixin {

//   List<Widget> loginContent = [];
//   List<Widget> createAccountContent = [];
  
//   // final EmailModel _model = EmailModel();

//   // bool _loading = false;

//   // Future<void> login() async {
//   //   // print("_model.email.text ${_model.email.text}");
//   //   // print("_model.password.text ${_model.password.text}");
//   //   // setState(() => _loading = true);
//   //   // await Future.delayed(Duration(seconds: 3));
//   //   // _loading = false;
//   //   // if (mounted == true) {
//   //   //   setState(() {});
//   //   // }
//   //   print(Form.of(context)?.validate());
//   //   if (_model.getFmKey.currentState!.validate()){
//   //     await _decryptDataLogin();
//   //   }
    
//   // }

//   // Future<void> _decryptDataLogin() async {
//   //   print("_decryptDataLogin");
//   //   try {

//   //     // Verify OTP with HTTPs
      
//   //     Response response = Response(await rootBundle.loadString('assets/json/phone.json'), 200);

//   //     final responseJson = json.decode(response.body);
//   //     print("responseJson ${responseJson.runtimeType}");
//   //     print(responseJson['user'].containsKey("encrypted"));

//   //     if (response.statusCode == 200) {

//   //       // if(!mounted) return;
//   //       if (responseJson['user'].containsKey("encrypted")){

//   //         // Navigator.pushAndRemoveUntil(
//   //         //   context, 
//   //         //   MaterialPageRoute(builder: (context) => HomePage()), 
//   //         //   (route) => false
//   //         // );
//   //         // Navigator.push(context, Transition(child: SetPassword(phoneNumber: widget.phoneNumber!, responseJson: responseJson), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
//   //         Navigator.push(context, Transition(child: ImportJson(json: responseJson, password: "123",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
//   //       }
          
//   //     } else if (response.statusCode == 401) {

//   //       if(!mounted) return;
//   //       customDialog(
//   //         context, 
//   //         "Error",
//   //         responseJson['message']
//   //       );

//   //       if(!mounted) return;
//   //       Navigator.of(context).pop();

//   //     } else if (response.statusCode >= 500 && response.statusCode < 600) {

//   //       if(!mounted) return;
//   //       customDialog(
//   //         context, 
//   //         "Error",
//   //         responseJson['message']
//   //       );

//   //       if(!mounted) return;
//   //       Navigator.of(context).pop();

//   //     }

//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }

//   // Widget _loginButton(String title) {
//   //   return MyGradientButton(
//   //     edgeMargin: const EdgeInsets.all(paddingSize),
//   //     textButton: title,
//   //     begin: Alignment.bottomLeft,
//   //     end: Alignment.topRight,
//   //     action: () {
//   //       login();
//   //     },
//   //   );
//   // }

//   // @override
//   // void initState() {
//   //   loginContent = [
//   //     myInputWidget(
//   //       context: context,
//   //       controller: _model.email,
//   //       hintText: "Email",
//   //       validator: (value) {
//   //         return Validator(
//   //           validators: [
//   //             RequiredValidator(),
//   //             EmailValidator()
//   //           ],
//   //         ).validate(
//   //           context: context,
//   //           label: 'Email',
//   //           value: value,
//   //         );
//   //       },
//   //     ),

//   //     myInputWidget(
//   //       context: context,
//   //       controller: _model.password,
//   //       hintText: "Password",
//   //       validator: (value) {
//   //         return Validator(
//   //           validators: [
//   //             RequiredValidator(),
//   //             MinLengthValidator(length: 8),
//   //           ],
//   //         ).validate(
//   //           context: context,
//   //           label: 'Password',
//   //           value: value,
//   //         );
//   //       },
//   //     ),

//   //     _loginButton("Sign in"),
//   //   ];


//   //   createAccountContent = [
//   //     myInputWidget(
//   //       context: context,
//   //       controller: _model.email,
//   //       hintText: "Email",
//   //       validator: (value) {
//   //         return Validator(
//   //           validators: [
//   //             RequiredValidator(),
//   //             EmailValidator()
//   //           ],
//   //         ).validate(
//   //           context: context,
//   //           label: 'Email',
//   //           value: value,
//   //         );
//   //       },
//   //     ),

//   //     myInputWidget(
//   //       context: context,
//   //       controller: _model.password,
//   //       hintText: "Password",
//   //       validator: (value) {
//   //         return Validator(
//   //           validators: [
//   //             RequiredValidator(),
//   //             MinLengthValidator(length: 8),
//   //           ],
//   //         ).validate(
//   //           context: context,
//   //           label: 'Password',
//   //           value: value,
//   //         );
//   //       },
//   //     ),

//   //     myInputWidget(
//   //       context: context,
//   //       controller: _model.confirmPassword,
//   //       hintText: "Confirm Password",
//   //       validator: (value) {
//   //         return Validator(
//   //           validators: [
//   //             RequiredValidator(),
//   //             MinLengthValidator(length: 8),
//   //           ],
//   //         ).validate(
//   //           context: context,
//   //           label: 'Password',
//   //           value: value,
//   //         );
//   //       },
//   //     ),

//   //     _loginButton("Sign up"),
//   //   ];

//   //   ChangeScreenAnimation.initialize(
//   //     vsync: this,
//   //     createAccountItems: createAccountContent.length,
//   //     loginItems: loginContent.length,
      
      
//   //   );

//   //   for (var i = 0; i < createAccountContent.length; i++) {
//   //     createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
//   //       animation: ChangeScreenAnimation.createAccountAnimations[i],
//   //       child: createAccountContent[i],
//   //     );
//   //   }

//   //   for (var i = 0; i < loginContent.length; i++) {
//   //     loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
//   //       animation: ChangeScreenAnimation.loginAnimations[i],
//   //       child: loginContent[i],
//   //     );
//   //   }

//   //   super.initState();
//   // }

//   // @override
//   // void dispose() {
//   //   ChangeScreenAnimation.dispose();

//   //   super.dispose();
//   // }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
//         ),
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Iconsax.arrow_left_2),
//         ),
//       ),
//       // body: EmailBody(
//       //   model: _model,
//       //   loginContent: loginContent,
//       //   createAccountContent: createAccountContent,
//       // )
//       body: const LoginContent(),
//     );
//   }
// }