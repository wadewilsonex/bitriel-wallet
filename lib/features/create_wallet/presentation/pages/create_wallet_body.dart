import 'package:bitriel_wallet/utils/app_utils/global.dart';
import 'package:bitriel_wallet/widget/button_widget.dart';
import 'package:bitriel_wallet/widget/seed_widget.dart';
import 'package:bitriel_wallet/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CreateSeedBody extends StatelessWidget {
  const CreateSeedBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () async {
                  
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
          text: "Seed",
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 25,
          color: Colors.black,
        ),
        SizedBox(
          height: 10,
        ),
        MyText(
          text: 
            "Write down or copy these words in the order and save them somewhere safe.\n\nAfter writing and securing your 12 words, click continue to proceed.",
          textAlign: TextAlign.start,
          fontSize: 19,
          color: Colors.grey
        )
      ],
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
                text: "Change Seed",
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                color: Colors.black,
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
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                color: Colors.black,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _seedDisplay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: hexaCodeToColor("#E8E8E8"),
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

}