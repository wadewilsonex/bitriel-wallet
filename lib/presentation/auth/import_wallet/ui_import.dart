import 'package:bitriel_wallet/presentation/widget/text_widget.dart';
import 'package:bitriel_wallet/standalone/components/button_widget.dart';
import 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';
import 'package:bitriel_wallet/standalone/utils/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class ImportWalletBody extends StatelessWidget {
  const ImportWalletBody({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexaCodeToColor(AppColors.background),
        centerTitle: true,
        leading: Icon(
          Iconsax.arrow_left_2,
          color: hexaCodeToColor(AppColors.midNightBlue),
          size: 25,
        ),
        title: MyTextConstant(
          text: "Import Mnemonic",
          fontSize: 26,
          color2: hexaCodeToColor(AppColors.midNightBlue),
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _textHeader(),

              const SizedBox(
                height: 10,
              ),

              _seedTextField(),

              Expanded(child: Container()),
              MyGradientButton(
                textButton: "Continue",
                action: () async {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textHeader() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: "Please add your 12 words seed below to restore your wallet.",
          textAlign: TextAlign.start, 
          color: AppColors.darkGrey
        ),
      ],
    );
  }

  Widget _seedTextField() {
    return TextFormField(
      key: key,
      enabled: true,
      keyboardType: TextInputType.text,
      onTap: () {

      },
      textInputAction: TextInputAction.next,
      style: TextStyle(
        color: hexaCodeToColor(AppColors.midNightBlue),
        fontSize: 16.0
      ),
      validator: (String? value) {
        return null;
      },
      textAlignVertical: TextAlignVertical.top,
      maxLines: 7,
      decoration: InputDecoration(
        hintText: "Add your 12 keywords",
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w600
        ),
        prefixStyle: TextStyle(color: hexaCodeToColor(AppColors.midNightBlue), fontSize: 16.0),
        /* Prefix Text */
        filled: true,
        fillColor: hexaCodeToColor(AppColors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0.0,
          ),
        ),

        // enabledBorder: mySeedFieldBorder(controller!.text != ""
        //     ? isDarkMode
        //         ? hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.3)
        //         : hexaCodeToColor(AppColors.textColor).withOpacity(0.3)
        //     : hexaCodeToColor(AppColors.darkSecondaryText)),
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
        // focusedBorder: mySeedFieldBorder(isDarkMode
        //     ? hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.3)
        //     : hexaCodeToColor(AppColors.secondary)),
        /* Default Focuse Border Color*/
        focusColor: hexaCodeToColor(AppColors.midNightBlue),
        /* Border Color When Focusing */
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 1),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(
          TextField.noMaxLength,
        )
      ],
      /* Limit Length Of Text Input */
      onChanged: (String? value) {
        
      },
      onFieldSubmitted: (value) {
        
      },
    );
  }

}