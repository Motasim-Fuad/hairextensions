import 'package:hairextensions/core/contracts/business_profile_reader.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/library/presentation/bloc/library/library_cubit.dart';
import 'package:hairextensions/features/library/presentation/pages/library/library_view.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LibraryCubit>()..start(),
      child: FutureBuilder<BusinessProfile?>(
        future: getIt<BusinessProfileReader>().read(),
        builder: (_, snapshot) => LibraryView(
          currencyCode: snapshot.data?.currencyCode ?? LibraryView.currency,
        ),
      ),
    );
  }
}
