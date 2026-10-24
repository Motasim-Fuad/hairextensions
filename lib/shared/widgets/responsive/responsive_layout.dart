import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/responsive/window_size_class.dart';
import 'package:hairextensions/shared/widgets/responsive/responsive_builder.dart';

/// Picks a different layout per size class. Only the chosen builder runs.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({required this.compact, super.key, this.medium, this.expanded});

  final WidgetBuilder compact;
  final WidgetBuilder? medium;
  final WidgetBuilder? expanded;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final builder = switch (info.sizeClass) {
          WindowSizeClass.compact => compact,
          WindowSizeClass.medium => medium ?? compact,
          WindowSizeClass.expanded => expanded ?? medium ?? compact,
        };
        return builder(context);
      },
    );
  }
}
