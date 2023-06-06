import 'package:bitriel_wallet/presentation/create_wallet/ui_create.dart';
import 'package:bitriel_wallet/presentation/widget/text_widget.dart';
import 'package:flutter/material.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({super.key});

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {

  @override
  void initState() {
    super.initState();
    // _showWarning(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showWarning(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), 
          topRight: Radius.circular(20)
        ),
      ),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              SizedBox(height: 15),

              MyText(
                text: "Please, read carefully!",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: 15),

              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(size8),
              //     color: hexaCodeToColor("#FFF5F5"),
              //   ),
              //   child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              //     const SizedBox(width: 10),
              //     Lottie.asset(
              //       "assets/animation/warning-shield.json",
              //       repeat: true,
              //     ),

              //     const SizedBox(width: 20),

              //     const Expanded(
              //       child: MyText(
              //         text: "The information below is important to guarantee your account security.",
              //         textAlign: TextAlign.start,
              //       ),
              //     )
              //   ]),
              // ),

              SizedBox(height: 25),

              MyText(
                text:
                    "Please write down your wallet's mnemonic seed and keep it in a safe place. The mnemonic can be used to restore your wallet. If you lose it, all your assets that link to it will be lost.",
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10),
              
              SizedBox(height: 10),
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