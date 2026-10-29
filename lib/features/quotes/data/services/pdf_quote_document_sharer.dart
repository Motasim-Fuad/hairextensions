import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/network/mappers/dio_error_mapper.dart';
import 'package:hairextensions/core/network/mappers/api_failure_mapper.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_document.dart';
import 'package:hairextensions/features/quotes/domain/services/quote_document_sharer.dart';
import 'package:injectable/injectable.dart';
import 'package:printing/printing.dart';

/// PDFs are rendered by the backend; never generate a local substitute.
@LazySingleton(as: QuoteDocumentSharer)
class PdfQuoteDocumentSharer implements QuoteDocumentSharer {
  PdfQuoteDocumentSharer(this._dio);
  final Dio _dio;

  @override
  Future<Either<Failure, Unit>> share(QuoteDocument document) async {
    final path = document.apiPath;
    if (path == null)
      return const Left(
        ValidationFailure(message: 'Save the quote before sharing.'),
      );
    try {
      final response = await _dio.get<List<int>>(
        path,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Accept': 'application/pdf'},
        ),
      );
      final bytes = Uint8List.fromList(response.data ?? []);
      if (bytes.length < 5 || String.fromCharCodes(bytes.take(5)) != '%PDF-') {
        return const Left(
          ValidationFailure(
            message: 'The server did not return a PDF. Please retry.',
          ),
        );
      }
      await Printing.sharePdf(bytes: bytes, filename: document.fileName);
      return const Right(unit);
    } on DioException catch (error) {
      return Left(
        ApiFailureMapper.toFailure(DioErrorMapper.toResponse<void>(error)),
      );
    } on Object {
      return const Left(UnknownFailure());
    }
  }
}
