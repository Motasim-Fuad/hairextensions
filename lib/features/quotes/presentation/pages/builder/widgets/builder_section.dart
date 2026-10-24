import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/motion_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_shadows.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Collapsible builder card: icon, title, running amount and a chevron.
class BuilderSection extends StatefulWidget {
  const BuilderSection({
    required this.icon,
    required this.title,
    required this.child,
    super.key,
    this.amount,
    this.initiallyExpanded = true,
  });

  final AppIcon icon;
  final String title;
  final String? amount;
  final bool initiallyExpanded;
  final Widget child;

  @override
  State<BuilderSection> createState() => _BuilderSectionState();
}

class _BuilderSectionState extends State<BuilderSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final amount = widget.amount;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surface, borderRadius: AppRadius.lgAll, boxShadow: AppShadows.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: _expanded,
            child: InkWell(
              borderRadius: AppRadius.lgAll,
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  spacing: AppSpacing.md,
                  children: [
                    IconBadge(
                      icon: widget.icon,
                      size: AppSizes.iconBadgeSmall,
                      isCircle: false,
                      background: colors.primarySurface,
                      foreground: colors.primary,
                    ),
                    Expanded(
                      child: Text(widget.title, style: AppTextStyles.planTitle.copyWith(color: colors.textPrimary)),
                    ),
                    if (amount != null) Text(amount, style: AppTextStyles.rowValue.copyWith(color: colors.textPrimary)),
                    AppSvgIcon(
                      _expanded ? AppIcon.chevronUp : AppIcon.chevronDown,
                      size: AppSizes.iconSm,
                      color: colors.textTertiary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: context.motion(AppMotion.fast),
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                    child: widget.child,
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
