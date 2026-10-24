import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';

class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(color: context.colors.shimmerBase, shape: BoxShape.circle),
      ),
    );
  }
}
