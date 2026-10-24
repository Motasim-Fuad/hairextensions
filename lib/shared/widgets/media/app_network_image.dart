import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/images/app_image_cache_manager.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_box.dart';

/// Decodes at the displayed size (not the source size) and rounds corners
/// with a decoration instead of a clip, so it is cheap inside lists.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    required this.width,
    required this.height,
    super.key,
    this.borderRadius = BorderRadius.zero,
    this.fit = BoxFit.cover,
    this.semanticLabel,
  });

  final String url;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final colors = context.colors;
    return Semantics(
      image: true,
      label: semanticLabel,
      child: SizedBox(
        width: width,
        height: height,
        child: CachedNetworkImage(
          imageUrl: url,
          cacheManager: AppImageCacheManager(),
          memCacheWidth: (width * pixelRatio).round(),
          memCacheHeight: (height * pixelRatio).round(),
          fadeInDuration: AppMotion.fast,
          fadeOutDuration: Duration.zero,
          imageBuilder: (context, provider) => DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              image: DecorationImage(image: provider, fit: fit),
            ),
          ),
          placeholder: (context, _) => SkeletonBox(width: width, height: height, radius: borderRadius.topLeft.x),
          errorWidget: (context, _, _) => DecoratedBox(
            decoration: BoxDecoration(color: colors.surfaceMuted, borderRadius: borderRadius),
            child: AppSvgIcon(AppIcon.alert, size: AppSizes.iconMd, color: colors.textTertiary),
          ),
        ),
      ),
    );
  }
}
