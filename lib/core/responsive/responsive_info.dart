import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/responsive/window_size_class.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';

/// Layout facts for a given available size. Built from LayoutBuilder
/// constraints or MediaQuery.sizeOf, never from the full MediaQuery.
@immutable
class ResponsiveInfo {
  const ResponsiveInfo._({required this.size, required this.sizeClass});

  factory ResponsiveInfo.fromSize(Size size) {
    return ResponsiveInfo._(
      size: size,
      sizeClass: WindowSizeClass.fromWidth(size.width),
    );
  }

  static const double _mediumSpacingScale = 1.15;
  static const double _expandedSpacingScale = 1.25;
  static const double _mediumMaxContent = 720;
  static const double _expandedMaxContent = 1040;

  final Size size;
  final WindowSizeClass sizeClass;

  bool get isCompact => sizeClass == WindowSizeClass.compact;
  bool get isMedium => sizeClass == WindowSizeClass.medium;
  bool get isExpanded => sizeClass == WindowSizeClass.expanded;
  bool get isLandscape => size.width > size.height;

  /// Two-pane layouts are used on tablets and on wide landscape phones.
  bool get useTwoPane => !isCompact;

  double get spacingScale => value(
    compact: 1,
    medium: _mediumSpacingScale,
    expanded: _expandedSpacingScale,
  );

  double get horizontalPadding => value(
    compact: AppSpacing.xl,
    medium: AppSpacing.xxxl,
    expanded: AppSpacing.huge,
  );

  double get maxContentWidth => value(
    compact: double.infinity,
    medium: _mediumMaxContent,
    expanded: _expandedMaxContent,
  );

  int get gridColumns => value(compact: 1, medium: 2, expanded: 3);

  double space(double base) => base * spacingScale;

  T value<T>({required T compact, T? medium, T? expanded}) {
    return switch (sizeClass) {
      WindowSizeClass.compact => compact,
      WindowSizeClass.medium => medium ?? compact,
      WindowSizeClass.expanded => expanded ?? medium ?? compact,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is ResponsiveInfo && other.size == size && other.sizeClass == sizeClass;
  }

  @override
  int get hashCode => Object.hash(size, sizeClass);
}
