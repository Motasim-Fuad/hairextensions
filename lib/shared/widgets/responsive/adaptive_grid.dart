import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';

/// Lays out a small, fixed set of tiles in as many equal columns as fit
/// [minItemWidth]. For long lists use a SliverGrid instead.
class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    required this.children,
    required this.minItemWidth,
    super.key,
    this.spacing = AppSpacing.md,
    this.maxColumns,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;
  final int? maxColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        var columns = max(1, ((width + spacing) / (minItemWidth + spacing)).floor());
        final limit = maxColumns;
        if (limit != null) {
          columns = min(columns, limit);
        }
        final itemWidth = (width - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children) SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}
