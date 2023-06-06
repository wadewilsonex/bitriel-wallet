import 'package:bitriel_wallet/presentation/widget/text_widget.dart';
import 'package:flutter/material.dart';

class ImportWalletBody extends StatelessWidget {
  const ImportWalletBody({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _textHeader(),
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
          text: "Restore with seed",
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 25,
          color: Colors.black,
        ),
        SizedBox(
          height: 10,
        ),
        MyText(
            text: "Please add your 12 words seed below to restore your wallet.",
            textAlign: TextAlign.start,
            fontSize: 19,
            color: Colors.grey)
      ],
    );
  }

}