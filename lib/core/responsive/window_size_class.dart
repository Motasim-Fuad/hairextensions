import 'package:hairextensions/core/responsive/breakpoints.dart';

enum WindowSizeClass {
  compact,
  medium,
  expanded;

  static WindowSizeClass fromWidth(double width) {
    if (width >= Breakpoints.expanded) {
      return WindowSizeClass.expanded;
    }
    if (width >= Breakpoints.medium) {
      return WindowSizeClass.medium;
    }
    return WindowSizeClass.compact;
  }
}
