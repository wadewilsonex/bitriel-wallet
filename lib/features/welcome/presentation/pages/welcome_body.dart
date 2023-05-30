import 'package:bitriel_wallet/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _textHeader(),

              const SizedBox(height: 20),
        
              _listMenuButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textHeader(){
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: "Set up\nyour Bitriel wallet",
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 25,
          color: Colors.black,
        ),

        SizedBox(
          height: 10,
        ),

        MyText(
          text: "Safe keeping digital assets, send, receive, trade, and more with Bitriel wallet.",
          textAlign: TextAlign.start,
          fontSize: 19,
          color: Colors.grey
        )
      ],
    );
  }

  Widget _menuButton({required BuildContext context, required String title, required IconData icon, required String route}) {
    return GestureDetector(
      onTap: () {
        context.push(route);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.red
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            // Icon Placeholder
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 10.0),
              child: SizedBox(
                height: 30,
                width: 30,
                child: Icon(icon, color: Colors.white),
              )
            ),

            // Image Placeholder
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Placeholder(
                  fallbackHeight: 200,
                  fallbackWidth: 200,
                ),
              ),
            ),
    
            // Title
            Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 10.0),
              child: Row(
                children: [
                  MyText(
                    text: title,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listMenuButton(BuildContext context){
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              child: _menuButton(context: context, title: "Create Wallet", icon: Iconsax.add_circle, route: "/create-wallet")
            ),

            const SizedBox(width: 10,),

            Flexible(
              flex: 1,
              child: _menuButton(context: context, title: "Import Wallet", icon: Iconsax.import , route: "/import-wallet")
            )
          ],
        )
      ],
    );
  }

}