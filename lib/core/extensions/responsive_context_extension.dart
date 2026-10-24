import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/responsive/responsive_info.dart';

extension ResponsiveContextExtension on BuildContext {
  /// Depends only on the window size, so text scale or inset changes do not
  /// rebuild callers.
  ResponsiveInfo get responsive => ResponsiveInfo.fromSize(MediaQuery.sizeOf(this));
}
