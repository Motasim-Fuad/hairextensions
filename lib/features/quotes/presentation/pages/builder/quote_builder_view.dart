import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/shared_entities/deposit_type.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/amount_parser.dart';
import 'package:hairextensions/core/utils/date_formatter.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_line.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/builder/quote_builder_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/pages/builder/widgets/builder_line_tile.dart';
import 'package:hairextensions/features/quotes/presentation/pages/builder/widgets/builder_section.dart';
import 'package:hairextensions/features/quotes/presentation/pages/builder/widgets/builder_total_bar.dart';
import 'package:hairextensions/features/quotes/presentation/sheets/add_hair_sheet.dart';
import 'package:hairextensions/features/quotes/presentation/sheets/add_item_sheet.dart';
import 'package:hairextensions/features/quotes/presentation/sheets/add_service_sheet.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/calc_row.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:hairextensions/shared/widgets/buttons/app_back_button.dart';
import 'package:hairextensions/shared/widgets/buttons/dashed_add_button.dart';
import 'package:hairextensions/shared/widgets/feedback/app_loader.dart';
import 'package:hairextensions/shared/widgets/feedback/app_status_chip.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';
import 'package:hairextensions/shared/widgets/feedback/status_tone.dart';
import 'package:hairextensions/shared/widgets/inputs/app_number_field.dart';
import 'package:hairextensions/shared/widgets/inputs/app_segmented_control.dart';
import 'package:hairextensions/shared/widgets/inputs/app_switch_tile.dart';
import 'package:hairextensions/shared/widgets/inputs/app_text_field.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';
import 'package:hairextensions/shared/widgets/layout/app_top_bar.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Design 3.2.
class QuoteBuilderView extends StatefulWidget {
  const QuoteBuilderView({super.key});

  @override
  State<QuoteBuilderView> createState() => _QuoteBuilderViewState();
}

class _QuoteBuilderViewState extends State<QuoteBuilderView> {
  static const Duration _bookingWindow = Duration(days: 365);

  final TextEditingController _client = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _appointment = TextEditingController();
  final TextEditingController _shipping = TextEditingController();
  final TextEditingController _vat = TextEditingController();
  final TextEditingController _deposit = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final TextEditingController _link = TextEditingController();

  @override
  void dispose() {
    for (final controller in [_client, _phone, _appointment, _shipping, _vat, _deposit, _note, _link]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _fill(QuoteBuilderState state) {
    _client.text = state.clientName;
    _phone.text = state.clientPhone;
    _shipping.text = AmountParser.fromMinor(state.shippingMinor);
    _vat.text = PercentFormatter.format(state.vatRatePercent);
    _note.text = state.note;
    _link.text = state.paymentLink;
    _fillDeposit(state);
  }

  void _fillDeposit(QuoteBuilderState state) {
    _deposit.text = state.depositType == DepositType.percent
        ? PercentFormatter.format(state.depositPercent)
        : AmountParser.fromMinor(state.depositFixedMinor);
  }

  Future<void> _pickAppointment(QuoteBuilderState state) async {
    final cubit = context.read<QuoteBuilderCubit>();
    final first = state.createdAt;
    final picked = await showDatePicker(
      context: context,
      initialDate: state.appointment ?? first,
      firstDate: first.subtract(_bookingWindow),
      lastDate: first.add(_bookingWindow),
    );
    if (picked != null) {
      cubit.setAppointment(picked);
      _appointment.text = DateFormatter.dayMonthYear(picked);
    }
  }

  Future<void> _add(Future<QuoteLine?> Function() open) async {
    final cubit = context.read<QuoteBuilderCubit>();
    final line = await open();
    if (line != null) {
      cubit.addLine(line);
    }
  }

  void _review() {
    final quote = context.read<QuoteBuilderCubit>().submit();
    if (quote != null) {
      unawaited(context.pushNamed<void>(AppRoutes.quoteReview, extra: quote));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuoteBuilderCubit, QuoteBuilderState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (_, state) => _fill(state),
      builder: (context, state) {
        if (state.status == ViewStatus.loading) {
          return const Scaffold(body: Center(child: AppLoader()));
        }
        final quote = state.quote;
        final totals = quote.totals;
        return Scaffold(
          appBar: AppTopBar(
            leading: const AppBackButton(icon: AppIcon.close),
            title: state.kind.isInvoice ? context.l10n.builderTitleInvoice : context.l10n.builderTitle,
            subtitle: state.number.isEmpty
                ? context.l10n.builderNumberPending
                : context.l10n.builderSubtitle(state.number),
            trailing: [
              AppStatusChip(label: context.l10n.statusDraft, tone: StatusTone.neutral),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
          body: _BuilderBody(
            state: state,
            client: _client,
            phone: _phone,
            appointment: _appointment,
            shipping: _shipping,
            vat: _vat,
            deposit: _deposit,
            note: _note,
            link: _link,
            onPickAppointment: () => unawaited(_pickAppointment(state)),
            onAdd: (open) => unawaited(_add(open)),
            onDepositTypeChanged: (type) {
              final cubit = context.read<QuoteBuilderCubit>()..setDepositType(type);
              _fillDeposit(cubit.state);
            },
          ),
          bottomNavigationBar: BuilderTotalBar(
            totalMinor: totals.totalMinor,
            balanceMinor: totals.balanceMinor,
            currency: state.currency,
            onReview: _review,
            isInvoice: state.kind.isInvoice,
          ),
        );
      },
    );
  }
}

class _BuilderBody extends StatelessWidget {
  const _BuilderBody({
    required this.state,
    required this.client,
    required this.phone,
    required this.appointment,
    required this.shipping,
    required this.vat,
    required this.deposit,
    required this.note,
    required this.link,
    required this.onPickAppointment,
    required this.onAdd,
    required this.onDepositTypeChanged,
  });

  final QuoteBuilderState state;
  final TextEditingController client;
  final TextEditingController phone;
  final TextEditingController appointment;
  final TextEditingController shipping;
  final TextEditingController vat;
  final TextEditingController deposit;
  final TextEditingController note;
  final TextEditingController link;
  final VoidCallback onPickAppointment;
  final ValueChanged<Future<QuoteLine?> Function()> onAdd;
  final ValueChanged<DepositType> onDepositTypeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<QuoteBuilderCubit>();
    final currency = state.currency;
    final totals = state.quote.totals;
    String money(int minor, {bool decimals = false}) => MoneyFormatter.format(minor, currency, showDecimals: decimals);

    List<Widget> lines(LineCategory category) => [
      for (final line in state.lines.where((line) => line.category == category))
        BuilderLineTile(line: line, currency: currency, onRemove: () => cubit.removeLine(line.id)),
    ];

    String? sectionAmount(LineCategory category) {
      final total = state.sectionTotal(category);
      return total == 0 ? null : money(total);
    }

    final sections = <Widget>[
      AppSegmentedControl<QuoteStatus>(
        options: [
          SegmentOption(value: QuoteStatus.quote, label: l10n.statusQuote),
          SegmentOption(value: QuoteStatus.invoice, label: l10n.statusInvoice),
        ],
        selected: state.kind,
        onChanged: cubit.setKind,
      ),
      BuilderSection(
        icon: AppIcon.user,
        title: l10n.sectionClient,
        child: Column(
          spacing: AppSpacing.md,
          children: [
            AppTextField(
              label: l10n.fieldClientName,
              isRequired: true,
              controller: client,
              hintText: l10n.fieldClientNameHint,
              textCapitalization: TextCapitalization.words,
              errorText: state.showClientError ? l10n.fieldRequired : null,
              onChanged: cubit.setClientName,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.md,
              children: [
                Expanded(
                  child: AppTextField(
                    label: l10n.fieldPhone,
                    controller: phone,
                    hintText: l10n.fieldClientPhoneHint,
                    keyboardType: TextInputType.phone,
                    onChanged: cubit.setClientPhone,
                  ),
                ),
                Expanded(
                  child: AppTextField(
                    label: l10n.fieldAppointment,
                    controller: appointment,
                    hintText: l10n.fieldAppointmentHint,
                    readOnly: true,
                    onTap: onPickAppointment,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: AppSvgIcon(AppIcon.calendar, size: AppSizes.iconMd, color: colors.textTertiary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      BuilderSection(
        icon: AppIcon.package,
        title: l10n.sectionHair,
        amount: sectionAmount(LineCategory.hair),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...lines(LineCategory.hair),
            DashedAddButton(
              label: l10n.actionAddHair,
              onPressed: () => onAdd(() => AddHairSheet.show(context, currency: currency)),
            ),
            if (state.showLinesError) ...[
              const SizedBox(height: AppSpacing.sm),
              InlineErrorText(message: l10n.builderNeedsLine),
            ],
          ],
        ),
      ),
      BuilderSection(
        icon: AppIcon.scissors,
        title: l10n.sectionService,
        amount: sectionAmount(LineCategory.service),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...lines(LineCategory.service),
            DashedAddButton(
              label: l10n.actionAddService,
              onPressed: () => onAdd(() => AddServiceSheet.show(context, currency: currency)),
            ),
          ],
        ),
      ),
      BuilderSection(
        icon: AppIcon.wallet,
        title: l10n.labelMaterials,
        amount: sectionAmount(LineCategory.material),
        initiallyExpanded: state.lines.any((line) => line.category == LineCategory.material),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...lines(LineCategory.material),
            DashedAddButton(
              label: l10n.actionAddMaterial,
              onPressed: () => onAdd(
                () => AddItemSheet.show(context, category: LineCategory.material, currency: currency),
              ),
            ),
          ],
        ),
      ),
      BuilderSection(
        icon: AppIcon.star,
        title: l10n.sectionAddOns,
        amount: sectionAmount(LineCategory.addOn),
        initiallyExpanded: state.lines.any((line) => line.category == LineCategory.addOn),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...lines(LineCategory.addOn),
            DashedAddButton(
              label: l10n.actionAddAddOn,
              onPressed: () => onAdd(
                () => AddItemSheet.show(context, category: LineCategory.addOn, currency: currency),
              ),
            ),
          ],
        ),
      ),
      BuilderSection(
        icon: AppIcon.truck,
        title: l10n.sectionShipping,
        amount: state.shippingMinor == 0 ? null : money(state.shippingMinor),
        initiallyExpanded: state.shippingMinor > 0,
        child: Column(
          children: [
            AppNumberField(
              controller: shipping,
              prefixText: currency,
              hintText: l10n.amountHint,
              onChanged: (value) => cubit.setShipping(AmountParser.toMinor(value)),
            ),
            AppSwitchTile(
              title: l10n.lineTaxable,
              value: state.shippingTaxable,
              onChanged: (value) => cubit.setShippingTaxable(value: value),
            ),
          ],
        ),
      ),
      BuilderSection(
        icon: AppIcon.percent,
        title: l10n.fieldTaxRate,
        amount: money(totals.vatMinor),
        child: Row(
          spacing: AppSpacing.md,
          children: [
            SizedBox(
              width: AppSizes.rateFieldWidth,
              child: AppNumberField(
                label: l10n.fieldRate,
                controller: vat,
                suffixText: l10n.unitPercent,
                decimals: 1,
                onChanged: (value) => cubit.setVatRate(AmountParser.decimal(value)),
              ),
            ),
            Expanded(
              child: Text(
                l10n.vatAppliedTo(totals.taxableLineCount, money(totals.taxableMinor, decimals: true)),
                style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
              ),
            ),
          ],
        ),
      ),
      BuilderSection(
        icon: AppIcon.wallet,
        title: l10n.labelDeposit,
        amount: money(totals.depositMinor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            AppSegmentedControl<DepositType>(
              options: [
                SegmentOption(value: DepositType.percent, label: l10n.depositPercentOfTotal),
                SegmentOption(value: DepositType.fixed, label: l10n.depositFixedAmount),
              ],
              selected: state.depositType,
              onChanged: onDepositTypeChanged,
            ),
            if (state.depositType == DepositType.percent)
              AppNumberField(
                controller: deposit,
                suffixText: l10n.unitPercent,
                decimals: 1,
                onChanged: (value) => cubit.setDepositPercent(AmountParser.decimal(value)),
              )
            else
              AppNumberField(
                controller: deposit,
                prefixText: currency,
                onChanged: (value) => cubit.setDepositFixed(AmountParser.toMinor(value)),
              ),
            CalcRow(label: l10n.labelBalanceDue, value: money(totals.balanceMinor, decimals: true), isStrong: true),
          ],
        ),
      ),
      BuilderSection(
        icon: AppIcon.pen,
        title: l10n.sectionNote,
        initiallyExpanded: false,
        child: Column(
          spacing: AppSpacing.md,
          children: [
            AppTextField(
              label: l10n.fieldNoteToClient,
              controller: note,
              hintText: l10n.fieldDefaultNoteHint,
              maxLines: 4,
              minLines: 3,
              textCapitalization: TextCapitalization.sentences,
              onChanged: cubit.setNote,
            ),
            AppTextField(
              label: l10n.fieldPaymentLinkShort,
              controller: link,
              hintText: l10n.fieldPaymentLinkHint,
              keyboardType: TextInputType.url,
              onChanged: cubit.setPaymentLink,
              suffixIcon: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: AppSvgIcon(AppIcon.link, size: AppSizes.iconMd, color: colors.textTertiary),
              ),
            ),
          ],
        ),
      ),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.xxl),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: AppSpacing.cardGap, children: sections),
    );
  }
}
