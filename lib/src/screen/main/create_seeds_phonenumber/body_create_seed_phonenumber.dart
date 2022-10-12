
import 'package:animate_do/animate_do.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/main/opt_seed/opt_seed.dart';

class CreateSeedPhoneNumberBody extends StatelessWidget {
  final TextEditingController? phoneNumber;
  final TextEditingController? password;

  const CreateSeedPhoneNumberBody({
    Key? key,
    this.phoneNumber,
    this.password
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BodyScaffold(
          child: Container(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerTitle(),
        
                SizedBox(height: 10.h),
                _inputField(context),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerTitle(){
    return const MyText(
      text: "Set up wallet \nwith phnone number",
      fontSize: 20,
      fontWeight: FontWeight.bold,
      textAlign: TextAlign.start,
      top: 80,
    );
  }

  Widget _inputField(BuildContext context){
    PhoneNumber number = PhoneNumber(isoCode: 'KH');
    String? getPhoneNumber;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
            color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.lightColorBg),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black.withOpacity(0.13)),
          ),
          child: Stack(
            children: [
              InternationalPhoneNumberInput(
                initialValue: number,
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                  getPhoneNumber = number.phoneNumber;
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                textStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                textFieldController: phoneNumber,
                formatInput: false,
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                cursorColor: Colors.black,
                inputDecoration: InputDecoration(
                  // contentPadding: const EdgeInsets.only(bottom: 15, left: 0),
                  border: InputBorder.none,
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                ),
                onSaved: (PhoneNumber number) {
                  print('On Saved: $number');
                  getPhoneNumber = number.toString();
                },
              ),
              Positioned(
                left: 90,
                top: 8,
                bottom: 8,
                child: Container(
                  height: 40,
                  width: 1,
                  color: Colors.black.withOpacity(0.13),
                ),
              )
            ],
          ),
        ),

        SizedBox(height: 1.h),

        TextFormField(
          obscureText: true,
          controller: password,
          style: TextStyle(
            color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,),
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor),),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor),),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor),),
            ),
            hintText: "Password",
            hintStyle: TextStyle(
              fontSize: 14,
              color: hexaCodeToColor("#AAAAAA"),
            ),
            prefixStyle: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.orangeColor), fontSize: 18.0),
            /* Prefix Text */
            filled: true,
            fillColor: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.lightColorBg),
          ),
        ),

        SizedBox(height: 10.h),
        MyGradientButton(
          textButton: "Register",
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          action: () {
            Navigator.push(context, Transition(child: OPTVerification(phoneNumber: getPhoneNumber), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          },
        ),
      ],
    );
  }
}