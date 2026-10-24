import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/features/library/presentation/bloc/product_form/product_form_cubit.dart';
import 'package:hairextensions/features/library/presentation/pages/product_form/product_form_view.dart';

class ProductFormPage extends StatelessWidget {
  const ProductFormPage({super.key, this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductFormCubit>(param1: product),
      child: const ProductFormView(),
    );
  }
}
