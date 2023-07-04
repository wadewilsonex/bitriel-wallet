import 'package:bitriel_wallet/index.dart';

bool isDarkMode = false;

class MySeedField extends StatelessWidget {
  final String? hintText;
  final String? prefixText;
  final String? textColor;
  final int? maxLine;
  final double? pLeft, pTop, pRight, pBottom;
  final bool? obcureText;
  final bool? enableInput;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final TextEditingController? controller;
  final Function? onTap;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Widget? suffix;
  final bool? autoFocus;
  final String? Function(String?)? validateField;
  final Function? onChanged;
  final Function? onSubmit;

  const MySeedField({
    Key? key,
    this.hintText,
    this.prefixText,
    this.pLeft = 16.0,
    this.pTop = 5.0,
    this.pRight = 16.0,
    this.pBottom = 0,
    this.obcureText = false,
    this.enableInput = true,
    this.textInputFormatter,
    this.inputType = TextInputType.text,
    this.inputAction,
    this.maxLine = 1,
    this.onTap,
    this.controller,
    this.focusNode,
    this.suffixIcon,
    this.textColor = "#FFFFFF",
    this.autoFocus,
    this.suffix,
    this.validateField,
    this.onChanged,
    @required this.onSubmit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.fromLTRB(pLeft!, pTop!, pRight!, pBottom!),
      child: TextFormField(
        enabled: enableInput,
        focusNode: focusNode,
        autofocus: autoFocus ?? false,
        keyboardType: inputType,
        obscureText: obcureText!,
        controller: controller,
        onTap: onTap != null ? (){
          onTap!();
        } : null,
        textInputAction:
          // ignore: prefer_if_null_operators
          inputAction == null ? TextInputAction.next : inputAction,
        style: TextStyle(
          color: isDarkMode
            ? hexaCodeToColor(AppColors.whiteColorHexa)
            : hexaCodeToColor(AppColors.textColor),
          fontSize: 15
        ),
        validator: validateField,
        textAlignVertical: TextAlignVertical.top,
        maxLines: maxLine,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            color: hexaCodeToColor(isDarkMode ? AppColors.shadowBlueColor : AppColors.greyColor),
            // fontSize: 16.0,
            fontWeight: FontWeight.w600
          ),
          prefixText: prefixText,
          prefixStyle: TextStyle(color: Color(int.parse("0xFF${AppColors.textColor.replaceAll("#", '')}")), fontSize: 18.0),
          /* Prefix Text */
          filled: true,
          fillColor: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.06) : hexaCodeToColor(AppColors.blackColor).withOpacity(0.06),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
          /* Enable Border But Not Show Error */
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
          /* Show Error And Red Border */
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
          /* Default Focuse Border Color*/
          focusColor: Color(int.parse("0xFF${AppColors.textColor.replaceAll("#", '')}")),
          // isDarkMode
          //     ? hexaCodeToColor("#ffffff")
          //     : hexaCodeToColor(AppColors.textColor),
          /* Border Color When Focusing */
          contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 1),
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffix: suffix,
        ),
        inputFormatters: textInputFormatter,
        /* Limit Length Of Text Input */
        onChanged: (String? value){
          if (onChanged != null) onChanged!(value);
        },
        onFieldSubmitted: (value) {
          onSubmit!();
        },
      )
    );
  }
}