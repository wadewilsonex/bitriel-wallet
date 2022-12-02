import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/login_component/animations/change_screen_animation.dart';
import 'package:wallet_apps/src/components/login_component/helper_functions.dart';
import 'package:wallet_apps/src/screen/main/email/login_content.dart';


class BottomText extends StatefulWidget {

  final ChangeScreenAnimation animationS;
  
  const BottomText({Key? key, required this.animationS}) : super(key: key);

  @override
  State<BottomText> createState() => _BottomTextState();
}

class _BottomTextState extends State<BottomText> {


  @override
  void initState() {
    
    widget.animationS.bottomTextAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HelperFunctions.wrapWithAnimatedBuilder(
      animation: widget.animationS.bottomTextAnimation,
      child: GestureDetector(
        onTap: () {
          if (!widget.animationS.isPlaying) {
            widget.animationS.currentScreen == Screens.createAccount
                ? widget.animationS.forward()
                : widget.animationS.reverse();

            widget.animationS.currentScreen =
                Screens.values[1 - widget.animationS.currentScreen.index];
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
              ),
              children: [
                TextSpan(
                  text: widget.animationS.currentScreen ==
                          Screens.welcomeBack
                      ? 'Already have an account? '
                      : 'Don\'t have an account? ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: hexaCodeToColor(AppColors.darkGrey)
                  ),
                ),
                TextSpan(
                  text: widget.animationS.currentScreen ==
                          Screens.welcomeBack
                      ? 'Log In'
                      : 'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: hexaCodeToColor(AppColors.secondary)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}