import 'package:bitriel_wallet/presentation/auth/verify_wallet/bloc_verify.dart';
import 'package:bitriel_wallet/presentation/widget/appbar_widget.dart';
import 'package:bitriel_wallet/presentation/widget/text_widget.dart';
import 'package:bitriel_wallet/standalone/components/button_widget.dart';
import 'package:bitriel_wallet/standalone/components/seed_widget.dart';
import 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';
import 'package:bitriel_wallet/standalone/utils/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CreateSeedBody extends StatelessWidget {
  const CreateSeedBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: "Create Mnemonic"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _textHeader(),

              const SizedBox(height: 20),

              _seedDisplay(context),

              const SizedBox(height: 20),

              _optionButton(),

              Expanded(child: Container()),
              MyGradientButton(
                textButton: "Continue",
                action: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VerifySeed())
                  );
                },
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
          text: 
            "Write down or copy these words in the order and save them somewhere safe.\n\nAfter writing and securing your 12 words, click continue to proceed.",
          textAlign: TextAlign.start,
          fontSize: 19,
          color: AppColors.darkGrey
        )
      ],
    );
  }


  Widget _seedDisplay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: hexaCodeToColor(AppColors.white),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: SeedsCompoent().getColumn(
                    context, "opera shed region term total sad open subway cricket absent smoke chapter", 0,
                    moreSize: 10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: SeedsCompoent().getColumn(
                    context, "opera shed region term total sad open subway cricket absent smoke chapter", 1,
                    moreSize: 10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: SeedsCompoent().getColumn(
                    context, "opera shed region term total sad open subway cricket absent smoke chapter", 2,
                    moreSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

 Widget _optionButton() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 0,
          child: Row(
            children: [
              Icon(Iconsax.repeat),

              SizedBox(width: 5),

              MyText(
                text: "New Mnemonic",
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.start,
                color: AppColors.midNightBlue,
              ),
            ],
          ),
        ),
        
        SizedBox(width: 20),

        Flexible(
          flex: 0,
          child: Row(
            children: [
              Icon(Iconsax.copy),

              SizedBox(width: 5),

              MyText(
                text: "Copy",
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.start,
                color: AppColors.midNightBlue,
              ),
            ],
          ),
        )
      ],
    );
  }
  
}