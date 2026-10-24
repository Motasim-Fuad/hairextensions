import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/responsive/responsive_info.dart';

/// Builds from the space actually available to this widget, so a pane inside
/// a two-pane tablet layout adapts to its own width, not the screen width.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({required this.builder, super.key});

  final Widget Function(BuildContext context, ResponsiveInfo info) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.hasBoundedHeight ? constraints.maxHeight : MediaQuery.sizeOf(context).height;
        return builder(context, ResponsiveInfo.fromSize(Size(constraints.maxWidth, height)));
      },
    );
  }
}
