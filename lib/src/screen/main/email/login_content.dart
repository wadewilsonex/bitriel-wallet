import 'package:http/http.dart';
import 'package:form_validation/form_validation.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/login_component/animations/change_screen_animation.dart';
import 'package:wallet_apps/src/components/login_component/components/bottom_text.dart';
import 'package:wallet_apps/src/components/login_component/components/top_text.dart';
import 'package:wallet_apps/src/components/login_component/helper_functions.dart';
import 'package:wallet_apps/src/models/email_m.dart';
import 'package:wallet_apps/src/screen/main/json/import_json.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> with TickerProviderStateMixin {
  
  late final List<Widget> loginContent;
  late final List<Widget> createAccountContent;
  
  final EmailModel _model = EmailModel();
  ChangeScreenAnimation animationS = ChangeScreenAnimation();

  Future<void> login() async {
    // print("_model.email.text ${_model.email.text}");
    // print("_model.password.text ${_model.password.text}");
    // setState(() => _loading = true);
    // await Future.delayed(Duration(seconds: 3));
    // _loading = false;
    // if (mounted == true) {
    //   setState(() {});
    // }
    print(Form.of(context)?.validate());
    if (_model.getFmKey.currentState!.validate()){
      await _decryptDataLogin();
    }
    
  }

  Future<void> _decryptDataLogin() async {
    print("_decryptDataLogin");
    try {

      // Verify OTP with HTTPs
      
      Response response = Response(await rootBundle.loadString('assets/json/phone.json'), 200);

      final responseJson = json.decode(response.body);
      print("responseJson ${responseJson.runtimeType}");
      print(responseJson['user'].containsKey("encrypted"));

      if (response.statusCode == 200) {

        // if(!mounted) return;
        if (responseJson['user'].containsKey("encrypted")){

          // Navigator.pushAndRemoveUntil(
          //   context, 
          //   MaterialPageRoute(builder: (context) => HomePage()), 
          //   (route) => false
          // );
          // Navigator.push(context, Transition(child: SetPassword(phoneNumber: widget.phoneNumber!, responseJson: responseJson), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          Navigator.push(context, Transition(child: ImportJson(json: responseJson, password: "123",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        }
          
      } else if (response.statusCode == 401) {

        if(!mounted) return;
        customDialog(
          context, 
          "Error",
          responseJson['message']
        );

        if(!mounted) return;
        Navigator.of(context).pop();

      } else if (response.statusCode >= 500 && response.statusCode < 600) {

        if(!mounted) return;
        customDialog(
          context, 
          "Error",
          responseJson['message']
        );

        if(!mounted) return;
        Navigator.of(context).pop();

      }

    } catch (e) {
      print(e);
    }
  }


  Widget _loginButton(String title) {
    return MyGradientButton(
      edgeMargin: const EdgeInsets.all(paddingSize),
      textButton: title,
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      action: () {
        login();
      },
    );
  }

  @override
  void initState() {
    
    loginContent = [
      myInputWidget(
        context: context,
        controller: _model.email,
        hintText: "Email",
        validator: (value) {
          return Validator(
            validators: [
              RequiredValidator(),
              EmailValidator()
            ],
          ).validate(
            context: context,
            label: 'Email',
            value: value,
          );
        },
      ),

      myInputWidget(
        context: context,
        controller: _model.password,
        hintText: "Password",
        validator: (value) {
          return Validator(
            validators: [
              RequiredValidator(),
              MinLengthValidator(length: 8),
            ],
          ).validate(
            context: context,
            label: 'Password',
            value: value,
          );
        },
      ),

      myInputWidget(
        context: context,
        controller: _model.confirmPassword,
        hintText: "Confirm Password",
        validator: (value) {
          return Validator(
            validators: [
              RequiredValidator(),
              MinLengthValidator(length: 8),
            ],
          ).validate(
            context: context,
            label: 'Password',
            value: value,
          );
        },
      ),

      _loginButton("Sign Up"),
    ];


    createAccountContent = [

      myInputWidget(
        context: context,
        controller: _model.email,
        hintText: "Email",
        validator: (value) {
          return Validator(
            validators: [
              RequiredValidator(),
              EmailValidator()
            ],
          ).validate(
            context: context,
            label: 'Email',
            value: value,
          );
        },
      ),

      myInputWidget(
        context: context,
        controller: _model.password,
        hintText: "Password",
        validator: (value) {
          return Validator(
            validators: [
              RequiredValidator(),
              MinLengthValidator(length: 8),
            ],
          ).validate(
            context: context,
            label: 'Password',
            value: value,
          );
        },
      ),



      _loginButton("Log In"),
    ];

    animationS.initialize(
      vsync: this,
      loginItems: loginContent.length,
      createAccountItems: createAccountContent.length,
    );
    
    
    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: animationS.loginAnimations[i],
        child: loginContent[i],
      );
    }
    

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: animationS.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    animationS.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _model.getFmKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TopText(animationS: animationS)
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: createAccountContent,
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: loginContent,
                    ),
                  ],
                ),
              ),
              
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomText(
                  animationS: animationS,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}