import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/shared/widgets/inputs/app_segmented_control.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';

class DepositTypeSelector extends StatelessWidget {
  const DepositTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<BusinessSetupBloc, BusinessSetupState, DepositType>(
      selector: (state) => state.draft.depositType,
      builder: (context, type) {
        return AppSegmentedControl<DepositType>(
          options: [
            SegmentOption(value: DepositType.percent, label: l10n.depositPercentOption),
            SegmentOption(value: DepositType.fixed, label: l10n.depositFixedOption),
          ],
          selected: type,
          onChanged: (value) => context.read<BusinessSetupBloc>().add(BusinessSetupDepositTypeChanged(value)),
        );
      },
    );
  }
}
