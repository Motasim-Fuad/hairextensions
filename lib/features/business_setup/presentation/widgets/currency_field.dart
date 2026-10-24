import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/business_setup/presentation/extensions/currency_name_extension.dart';
import 'package:hairextensions/features/business_setup/presentation/widgets/currency_picker_sheet.dart';
import 'package:hairextensions/shared/widgets/inputs/app_field_label.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

class CurrencyField extends StatelessWidget {
  const CurrencyField({super.key});

  Future<void> _pick(BuildContext context, String current) async {
    final bloc = context.read<BusinessSetupBloc>();
    final chosen = await CurrencyPickerSheet.show(context, selected: current);
    if (chosen != null && chosen != current) {
      bloc.add(BusinessSetupCurrencyChanged(chosen));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<BusinessSetupBloc, BusinessSetupState, String>(
      selector: (state) => state.draft.currencyCode,
      builder: (context, code) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppFieldLabel(text: l10n.fieldCurrency),
            const SizedBox(height: AppSpacing.xs),
            Semantics(
              button: true,
              hint: l10n.actionChooseCurrency,
              child: InkWell(
                onTap: () => _pick(context, code),
                borderRadius: AppRadius.mdAll,
                child: InputDecorator(
                  decoration: const InputDecoration(suffixIcon: AppSvgIcon(AppIcon.chevronDown)),
                  child: Text(
                    l10n.currencyLabelFor(code),
                    style: context.textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
