
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
    // mass: 50,
    // stiffness: 100,
    // damping: 0.8,
    mass: 80,
    stiffness: 100,
    damping: 1,
  );
}