import 'package:bitriel_wallet/presentation/auth/create_wallet/ui_create.dart';
import 'package:bitriel_wallet/presentation/auth/verify_wallet/ui_verify.dart';
import 'package:bitriel_wallet/presentation/widget/text_widget.dart';
import 'package:bitriel_wallet/standalone/components/button_widget.dart';
import 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';
import 'package:bitriel_wallet/standalone/utils/themes/colors.dart';
import 'package:flutter/material.dart';

class VerifySeed extends StatefulWidget {
  const VerifySeed({super.key});

  @override
  State<VerifySeed> createState() => _VerifySeedState();
}

class _VerifySeedState extends State<VerifySeed> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

Future<void> _seedVerifyLaterDialog(BuildContext context) async {

  bool isCheck = false;
  
  showModalBottomSheet(
    context: context,
    backgroundColor: hexaCodeToColor(AppColors.white),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20), topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateWidget) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Placeholder()
                ),
          
                const MyText(
                  text: 'Verify you Seed Phrase later?',
                  color: AppColors.midNightBlue,
                  fontSize: 20,
                  top: 10,
                  bottom: 10,
                  fontWeight: FontWeight.bold,
                ),
          
                CheckboxListTile(
                  title: const MyText(
                    text: "I understand that if I lose my Secret Seed Phrase I will not be able to access my wallet",
                    textAlign: TextAlign.start,
                    color: AppColors.midNightBlue,
                  ),
                  activeColor: hexaCodeToColor(AppColors.primary),
                  value: isCheck,
                  onChanged: (newValue) {
                    setStateWidget(() {
                      isCheck = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                const SizedBox(height: 10,),

                MyGradientButton(
                  textButton: "Yes, Verify Later",
                  buttonColor: AppColors.white,
                  opacity: 0,
                  textColor: isCheck == false ? AppColors.lightGrey : AppColors.primary,
                  action: (){

                  }
                ),
          
                const SizedBox(height: 10,),
          
                MyGradientButton(
                  textButton: "No, Verify Now",
                  action: (){
                    Navigator.pop(context);
                  }
                ),

                const SizedBox(height: 10,),
          
              ],
            ),
          );
        }
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return VerifySeedBody(
      seedVerifyLaterDialog: _seedVerifyLaterDialog
    );
  }
}