import 'package:flutter/cupertino.dart';

class UIHelper {
  static Widget verticalSpace([double height = 8]) {
    return SizedBox(height: height);
  }

  static Widget horizontalSpace([double width = 8]) {
    return SizedBox(width: width);
  }
}

class Constants{
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}