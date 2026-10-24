import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/shared/widgets/media/brand_wordmark.dart';
import 'package:hairextensions/shared/widgets/responsive/max_width_box.dart';

/// Shared frame of the account screens: a Baby Pink wash fading into the page,
/// the brand wordmark, a serif title with its subtitle, then the screen's own
/// content. Scrolls so the keyboard never hides the fields.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({required this.title, required this.subtitle, required this.children, super.key, this.leading});

  static const double _washFade = 0.4;
  static const double _wordmarkSize = 44;

  final String title;
  final String subtitle;
  final List<Widget> children;

  /// Back button for screens reached by push; null on the root screens.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.primarySoft, colors.background],
            stops: [0, _washFade],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xxxl),
            child: MaxWidthBox(
              maxWidth: AppSizes.maxFormWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: AppSizes.minTapTarget,
                    child: Align(alignment: AlignmentDirectional.centerStart, child: leading),
                  ),
                  const Center(child: BrandWordmark(size: _wordmarkSize)),
                  const SizedBox(height: AppSpacing.xxl),
                  Semantics(
                    header: true,
                    child: Text(title, textAlign: TextAlign.center, style: context.textTheme.headlineLarge),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: AppSpacing.lg, children: children),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
