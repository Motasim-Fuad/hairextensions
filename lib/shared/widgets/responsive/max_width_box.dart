import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/extensions/responsive_context_extension.dart';

/// Centers content with a readable maximum width and adaptive side padding.
class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({required this.child, super.key, this.maxWidth, this.applyPadding = true});

  final Widget child;
  final double? maxWidth;
  final bool applyPadding;

  @override
  Widget build(BuildContext context) {
    final info = context.responsive;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? info.maxContentWidth),
        child: applyPadding
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: info.horizontalPadding),
                child: child,
              )
            : child,
      ),
    );
  }
}
