import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';

/// White rounded surface. Borderless and shadowless by default because a
/// flat card is the cheapest to paint inside scrolling lists.
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.color,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final border = borderColor;
    final shape = RoundedRectangleBorder(
      borderRadius: AppRadius.lgAll,
      side: border == null ? BorderSide.none : BorderSide(color: border),
    );
    final content = Padding(padding: padding, child: child);
    return Material(
      color: color ?? context.colors.surface,
      shape: shape,
      child: onTap == null ? content : InkWell(onTap: onTap, customBorder: shape, child: content),
    );
  }
}
