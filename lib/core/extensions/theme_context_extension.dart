import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_colors.dart';

extension ThemeContextExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  TextTheme get textTheme => Theme.of(this).textTheme;
}
