import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/login_component/animations/change_screen_animation.dart';
import 'package:wallet_apps/src/components/login_component/helper_functions.dart';
import 'package:wallet_apps/src/screen/main/email/login_content.dart';

class TopText extends StatefulWidget {
  
  final ChangeScreenAnimation animationS;
  const TopText({Key? key, required this.animationS}) : super(key: key);

  @override
  State<TopText> createState() => _TopTextState();
}

class _TopTextState extends State<TopText> {

  @override
  void initState() {
    widget.animationS.topTextAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HelperFunctions.wrapWithAnimatedBuilder(
      animation: widget.animationS.topTextAnimation,
      child: MyText(
        text: widget.animationS.currentScreen == Screens.welcomeBack
            ? 'Create\nAccount'
            : 'Welcome\nBack',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        textAlign: TextAlign.start,
      ),
    );
  }
}