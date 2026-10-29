import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:printing/printing.dart';

class BackendPdfPreview extends StatefulWidget {
  const BackendPdfPreview({required this.path, super.key});
  final String path;
  @override
  State<BackendPdfPreview> createState() => _BackendPdfPreviewState();
}

class _BackendPdfPreviewState extends State<BackendPdfPreview> {
  late Future<Uint8List> _pdf = _load();
  Future<Uint8List> _load() async {
    final response = await getIt<Dio>().get<List<int>>(
      widget.path,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'Accept': 'application/pdf'},
      ),
    );
    final bytes = Uint8List.fromList(response.data ?? []);
    if (bytes.length < 5 || String.fromCharCodes(bytes.take(5)) != '%PDF-') {
      throw const FormatException('Invalid PDF response');
    }
    return bytes;
  }

  @override
  void didUpdateWidget(BackendPdfPreview old) {
    super.didUpdateWidget(old);
    if (old.path != widget.path) _pdf = _load();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: MediaQuery.sizeOf(context).height * .65,
    child: FutureBuilder<Uint8List>(
      future: _pdf,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Unable to load the PDF from the server.',
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () => setState(() => _pdf = _load()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        return PdfPreview(
          build: (_) async => snapshot.data!,
          allowPrinting: false,
          allowSharing: false,
          canChangePageFormat: false,
          canChangeOrientation: false,
          canDebug: false,
        );
      },
    ),
  );
}
