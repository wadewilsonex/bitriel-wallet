import 'package:bitriel_wallet/presentation/auth/create_wallet/ui_create.dart';
import 'package:bitriel_wallet/presentation/widget/text_widget.dart';
import 'package:bitriel_wallet/standalone/components/button_widget.dart';
import 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';
import 'package:bitriel_wallet/standalone/utils/themes/colors.dart';
import 'package:flutter/material.dart';

class CreateSeed extends StatefulWidget {
  const CreateSeed({super.key});

  @override
  State<CreateSeed> createState() => _CreateSeedState();
}

class _CreateSeedState extends State<CreateSeed> {

  @override
  void initState() {
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWarning(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showWarning(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: MyText(
                  text: "Please, read carefully!",
                  fontSize: 18,
                  color: AppColors.midNightBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: hexaCodeToColor(AppColors.red).withOpacity(0.25),
                ),
                height: 50,
                child: const Row(
                  mainAxisSize: MainAxisSize.min, 
                  children: <Widget>[

                    SizedBox(width: 5),

                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Placeholder()
                    ),

                    SizedBox(width: 5),

                    Expanded(
                      child: MyText(
                        text: "The information below is important to guarantee your account security.",
                        color: AppColors.red,
                        textAlign: TextAlign.start,
                      ),
                    )
                  ]
                ),
              ),

              const SizedBox(height: 5),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: MyText(
                  text:
                    "Please write down your wallet's mnemonic seed and keep it in a safe place. The mnemonic can be used to restore your wallet. If you lose it, all your assets that link to it will be lost.",
                  textAlign: TextAlign.start,
                  color: AppColors.midNightBlue,
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                child: MyGradientButton(
                  textButton: "I Agree",
                  action: () {
                    Navigator.pop(context);
                  },
                ),
              ),

            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CreateSeedBody();
  }
}