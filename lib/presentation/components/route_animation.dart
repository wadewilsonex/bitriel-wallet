import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class RouteAnimation extends PageRouteBuilder {
  final Widget? enterPage;
  final Widget? exitPage;
  final String? routeName;
  RouteAnimation({this.enterPage, this.exitPage, this.routeName}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => exitPage!,
    transitionDuration: const Duration(milliseconds: 50),
    settings: RouteSettings(name: routeName),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: enterPage,
    ),
  );
}
