import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/registration/head_title_c.dart';

class LoginSeedPhoneNumberBody extends StatelessWidget {
  final TextEditingController? phoneNumber;
  final TextEditingController? password;
  final Function login;

  const LoginSeedPhoneNumberBody({
    Key? key,
    this.phoneNumber,
    this.password,
    required this.login,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const HeaderTitle(title: "Phone", subTitle: "Enter your phone number",),
      
            _inputField(context),

            Expanded(child: Container(),),

            MyGradientButton(
              textButton: "Login",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: () {
                login(phoneNumber!.text);
                // Navigator.push(context, Transition(child: OPTVerification(phoneNumber: getPhoneNumber), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _inputField(BuildContext context){
    return Column(
      children: [

        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
            color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor  : "#FFFFFF"),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [

              Theme(
                data: ThemeData(
                  canvasColor: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : "#FFFFFF"),
                  textTheme: TextTheme(
                    titleMedium: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)),
                    bodySmall: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.lowWhite : AppColors.textColor))
                  )
                ),
                child: InternationalPhoneNumberInput(
                  // initialValue: number,
                  onInputChanged: (PhoneNumber number) {
                    number.phoneNumber;
                  },
                  onInputValidated: (bool value) {
                    // print(value);
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  searchBoxDecoration: InputDecoration(
                    hintText: 'Search by country name or dial code',
                    hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 2.2.vmax),
                    // alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  textStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 2.2.vmax),
                  textFieldController: phoneNumber,
                  formatInput: false,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  // cursorColor: isDarkMode ? Colors.white : Colors.black,
                  inputDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 15, left: 0),
                    border: InputBorder.none,
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 2.4.vmax),
                  ),
                  onSaved: (PhoneNumber number) {
                    phoneNumber!.text = number.toString();
                  },
                ),
              ),
              
              Positioned(
                left: 90,
                top: 8,
                bottom: 8,
                child: Container(
                  height: 10,
                  width: 1,
                  color: isDarkMode ? Colors.white.withOpacity(0.13) : Colors.black.withOpacity(0.13),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}