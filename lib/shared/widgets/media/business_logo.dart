import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/shared/widgets/media/monogram_avatar.dart';

/// Shows the locally stored logo decoded at display size, or the monogram.
class BusinessLogo extends StatelessWidget {
  const BusinessLogo({required this.businessName, super.key, this.logoPath, this.size = AppSizes.logo});

  final String businessName;
  final String? logoPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = logoPath;
    if (path == null || path.isEmpty) {
      return MonogramAvatar(name: businessName, size: size);
    }
    final cacheSize = (size * MediaQuery.devicePixelRatioOf(context)).round();
    return Semantics(
      image: true,
      label: businessName,
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdAll,
            image: DecorationImage(
              image: ResizeImage(FileImage(File(path)), width: cacheSize, height: cacheSize),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
