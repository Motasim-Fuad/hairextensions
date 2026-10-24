import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration page = Duration(milliseconds: 280);
  static const Duration staggerStep = Duration(milliseconds: 40);
  static const Duration shimmerCycle = Duration(milliseconds: 1400);
  static const Duration toastVisible = Duration(seconds: 3);
  static const Duration splashHold = Duration(milliseconds: 1200);
  static const int staggerMaxItems = 8;
  static const double pageSlideOffset = 0.06;
  static const double entranceSlideOffset = 0.08;
  static const double switcherSlideOffset = 0.02;
  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;
}
