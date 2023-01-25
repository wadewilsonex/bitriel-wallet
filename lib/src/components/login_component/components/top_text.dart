import 'package:wallet_apps/index.dart';

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
            : 'Login with email',
        fontSize: 3.3,
        fontWeight: FontWeight.w600,
        textAlign: TextAlign.start,
      ),
    );
  }
}