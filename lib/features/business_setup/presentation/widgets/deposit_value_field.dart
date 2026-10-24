import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/features/business_setup/domain/enums/setup_field.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/setup_text_field.dart';

/// Shows a percent suffix or a currency prefix depending on the deposit type.
class DepositValueField extends StatelessWidget {
  const DepositValueField({super.key});

  static const int _decimals = 2;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BusinessSetupBloc, BusinessSetupState, ({DepositType type, String currency})>(
      selector: (state) => (type: state.draft.depositType, currency: state.draft.currencyCode),
      builder: (context, deposit) {
        final isPercent = deposit.type == DepositType.percent;
        return SetupTextField(
          field: SetupField.depositValue,
          decimals: _decimals,
          prefixText: isPercent ? null : deposit.currency,
          suffixText: isPercent ? context.l10n.unitPercent : null,
        );
      },
    );
  }
}
