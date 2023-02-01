import 'package:flutter/material.dart';
import 'package:wallet_apps/src/screen/main/social_login/email/login_content.dart';

class ChangeScreenAnimation {
  
  late final AnimationController topTextController;
  late final Animation<Offset> topTextAnimation;

  late final AnimationController bottomTextController;
  late final Animation<Offset> bottomTextAnimation;

  final List<AnimationController> createAccountControllers = [];
  final List<Animation<Offset>> createAccountAnimations = [];

  final List<AnimationController> loginControllers = [];
  final List<Animation<Offset>> loginAnimations = [];

  var isPlaying = false;
  var currentScreen = Screens.createAccount;

  Animation<Offset> _createAnimation({
    required Offset begin,
    required Offset end,
    required AnimationController parent,
  }) {
    return Tween(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: parent,
        curve: Curves.easeInOut,
      ),
    );
  }

  void initialize({
    required TickerProvider vsync,
    required int createAccountItems,
    required int loginItems,
  }) {
    topTextController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 100),
    );

    topTextAnimation = _createAnimation(
      begin: Offset.zero,
      end: const Offset(-1.2, 0),
      parent: topTextController,
    );

    bottomTextController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 100),
    );

    bottomTextAnimation = _createAnimation(
      begin: Offset.zero,
      end: const Offset(0, 0),
      parent: bottomTextController,
    );

    for (var i = 0; i < loginItems; i++) {
      loginControllers.add(
        AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 100),
        ),
      );

      loginAnimations.add(
        _createAnimation(
          begin: const Offset(1, 0),
          end: Offset.zero,
          parent: loginControllers[i],
        ),
      );
    }

    for (var i = 0; i < createAccountItems; i++) {
      createAccountControllers.add(
        AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 100),
        ),
      );

      createAccountAnimations.add(
        _createAnimation(
          begin: Offset.zero,
          end: const Offset(-1, 0),
          parent: createAccountControllers[i],
        ),
      );
    }
  }

  void dispose() {
    for (final controller in [
      topTextController,
      bottomTextController,
      ...createAccountControllers,
      ...loginControllers,
    ]) {
      controller.dispose();
    }
  }

  Future<void> forward() async {
    isPlaying = true;

    topTextController.forward();
    await bottomTextController.forward();

    for (final controller in [
      ...createAccountControllers,
      ...loginControllers,
    ]) {
      controller.forward();
      await Future.delayed(const Duration(milliseconds: 50));
    }

    bottomTextController.reverse();
    await topTextController.reverse();

    isPlaying = false;
  }

  Future<void> reverse() async {
    isPlaying = true;

    topTextController.forward();
    await bottomTextController.forward();

    for (final controller in [
      ...loginControllers.reversed,
      ...createAccountControllers.reversed,
    ]) {
      controller.reverse();
      await Future.delayed(const Duration(milliseconds: 50));
    }

    bottomTextController.reverse();
    await topTextController.reverse();

    isPlaying = false;
  }
}