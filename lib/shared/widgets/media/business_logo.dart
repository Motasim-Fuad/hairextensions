import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/shared/widgets/media/monogram_avatar.dart';

/// Local picker preview or authenticated backend image. No tokens in image URLs.
class BusinessLogo extends StatefulWidget {
  const BusinessLogo({
    required this.businessName,
    super.key,
    this.logoPath,
    this.size = AppSizes.logo,
  });
  final String businessName;
  final String? logoPath;
  final double size;
  @override
  State<BusinessLogo> createState() => _BusinessLogoState();
}

class _BusinessLogoState extends State<BusinessLogo> {
  Future<Uint8List?>? _bytes;
  bool get _remote =>
      widget.logoPath != null &&
      (widget.logoPath!.startsWith('/v1/') ||
          widget.logoPath!.startsWith('http'));
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(BusinessLogo old) {
    super.didUpdateWidget(old);
    if (old.logoPath != widget.logoPath) _load();
  }

  void _load() {
    _bytes = _remote ? _fetch() : null;
  }

  Future<Uint8List?> _fetch() async {
    try {
      final response = await getIt<Dio>().get<List<int>>(
        '/v1/business/logo',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Accept': 'image/*'},
        ),
      );
      return Uint8List.fromList(response.data ?? []);
    } on Object {
      return null;
    }
  }

  Widget _fallback() =>
      MonogramAvatar(name: widget.businessName, size: widget.size);
  @override
  Widget build(BuildContext context) {
    final path = widget.logoPath;
    Widget content;
    if (_remote) {
      content = FutureBuilder<Uint8List?>(
        future: _bytes,
        builder: (_, snapshot) {
          final bytes = snapshot.data;
          return bytes == null
              ? _fallback()
              : Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallback(),
                );
        },
      );
    } else if (path != null && path.isNotEmpty && File(path).existsSync()) {
      content = Image.file(
        File(path),
        fit: BoxFit.cover,
        cacheWidth: (widget.size * MediaQuery.devicePixelRatioOf(context))
            .round(),
        errorBuilder: (_, __, ___) => _fallback(),
      );
    } else {
      content = _fallback();
    }
    return Semantics(
      image: true,
      label: widget.businessName,
      child: SizedBox.square(
        dimension: widget.size,
        child: ClipRRect(borderRadius: AppRadius.mdAll, child: content),
      ),
    );
  }
}
