import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/errors/failure_message_extension.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/date_formatter.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/review/quote_review_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/review/review_destination.dart';
import 'package:hairextensions/features/quotes/presentation/extensions/quote_line_text.dart';
import 'package:hairextensions/features/quotes/presentation/extensions/quote_status_text.dart';
import 'package:hairextensions/features/quotes/presentation/pages/review/widgets/profit_card.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/calc_row.dart';
import 'package:hairextensions/shared/widgets/buttons/app_back_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_icon_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_outline_button.dart';
import 'package:hairextensions/shared/widgets/buttons/app_primary_button.dart';
import 'package:hairextensions/shared/widgets/feedback/app_status_chip.dart';
import 'package:hairextensions/shared/widgets/feedback/inline_error_text.dart';
import 'package:hairextensions/shared/widgets/layout/app_top_bar.dart';
import 'package:hairextensions/shared/widgets/layout/bottom_action_bar.dart';
import 'package:hairextensions/shared/widgets/layout/icon_badge.dart';
import 'package:hairextensions/shared/widgets/layout/overline_label.dart';
import 'package:hairextensions/shared/widgets/layout/section_card.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';

/// Design 3.5. Saving replaces the builder stack: the saved quote opens on
/// its own (detail) or straight into the PDF preview.
class QuoteReviewView extends StatelessWidget {
  const QuoteReviewView({super.key});

  void _onSaved(BuildContext context, QuoteReviewState state) {
    final id = state.quote.id;
    final detail = context.namedLocation(AppRoutes.quoteDetail, pathParameters: {AppRoutes.idParam: id});
    context.go(
      state.savedFor == ReviewDestination.pdf
          ? context.namedLocation(AppRoutes.quotePreview, pathParameters: {AppRoutes.idParam: id})
          : detail,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return BlocConsumer<QuoteReviewCubit, QuoteReviewState>(
      listenWhen: (previous, current) => previous.savedFor == null && current.savedFor != null,
      listener: _onSaved,
      builder: (context, state) {
        final cubit = context.read<QuoteReviewCubit>();
        final quote = state.quote;
        final totals = quote.totals;
        final currency = quote.currencyCode;
        String money(int minor) => MoneyFormatter.format(minor, currency);
        final appointment = quote.appointment;
        final note = quote.note;
        final link = quote.paymentLink;
        return Scaffold(
          appBar: AppTopBar(
            leading: const AppBackButton(),
            title: l10n.actionReviewQuote,
            trailing: [
              AppIconButton(icon: AppIcon.pen, semanticLabel: l10n.actionEdit, onPressed: () => context.pop()),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.xxl),
            children: [
              SectionCard(
                child: Row(
                  spacing: AppSpacing.md,
                  children: [
                    IconBadge(
                      icon: AppIcon.user,
                      size: AppSizes.avatar,
                      background: colors.primarySurface,
                      foreground: colors.primary,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(quote.clientName, style: AppTextStyles.rowTitle.copyWith(color: colors.textPrimary)),
                          Text(
                            appointment == null
                                ? quote.number
                                : l10n.reviewAppointment(quote.number, DateFormatter.dayMonthYear(appointment)),
                            style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
                          ),
                        ],
                      ),
                    ),
                    AppStatusChip(label: quote.status.label(l10n), tone: quote.status.tone),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              OverlineLabel(text: l10n.reviewClientBreakdown, color: colors.textTertiary),
              const SizedBox(height: AppSpacing.sm),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final line in quote.lines)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    line.displayTitle(l10n),
                                    style: AppTextStyles.rowLabel.copyWith(color: colors.textPrimary),
                                  ),
                                  Text(
                                    line.shortDetail(l10n),
                                    style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              MoneyFormatter.plain(line.amountMinor, showDecimals: true),
                              style: AppTextStyles.rowValue.copyWith(color: colors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    Divider(height: AppSpacing.lg, color: colors.border),
                    CalcRow(label: l10n.labelSubtotal, value: money(totals.subtotalMinor)),
                    CalcRow(
                      label: l10n.reviewVatOn(
                        PercentFormatter.format(quote.vatRatePercent),
                        MoneyFormatter.format(totals.taxableMinor, currency, showDecimals: false),
                      ),
                      value: money(totals.vatMinor),
                    ),
                    CalcRow(label: l10n.labelTotal, value: money(totals.totalMinor), isStrong: true),
                    if (totals.depositMinor > 0) ...[
                      CalcRow(label: l10n.labelDeposit, value: l10n.minusValue(money(totals.depositMinor))),
                      CalcRow(
                        label: l10n.labelBalanceDue,
                        value: money(totals.balanceMinor),
                        isStrong: true,
                        valueColor: colors.primary,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfitCard(quote: quote, showFormulas: state.showFormulas, onToggleFormulas: cubit.toggleFormulas),
              if (note != null || link != null) ...[
                const SizedBox(height: AppSpacing.section),
                OverlineLabel(text: l10n.reviewNoteAndPayment, color: colors.textTertiary),
                const SizedBox(height: AppSpacing.sm),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.md,
                    children: [
                      if (note != null) Text(note, style: AppTextStyles.detail.copyWith(color: colors.textSecondary)),
                      if (link != null)
                        Row(
                          spacing: AppSpacing.sm,
                          children: [
                            AppSvgIcon(AppIcon.link, size: AppSizes.iconSm, color: colors.primary),
                            Expanded(
                              child: Text(
                                Uri.tryParse(link)?.host.isNotEmpty ?? false
                                    ? '${Uri.parse(link).host}${Uri.parse(link).path}'
                                    : link,
                                style: AppTextStyles.detailAccent.copyWith(color: colors.primary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          bottomNavigationBar: BottomActionBar(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.sm,
              children: [
                if (state.failure != null) InlineErrorText(message: state.failure!.localizedMessage(l10n)),
                Row(
                  spacing: AppSpacing.md,
                  children: [
                    Expanded(
                      child: AppOutlineButton(
                        label: l10n.actionSave,
                        leadingIcon: AppIcon.check,
                        isLoading: state.savingFor == ReviewDestination.detail,
                        onPressed: state.isSaving ? null : () => unawaited(cubit.save(ReviewDestination.detail)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: AppPrimaryButton(
                        label: l10n.actionGeneratePdf,
                        leadingIcon: AppIcon.file,
                        isLoading: state.savingFor == ReviewDestination.pdf,
                        onPressed: state.isSaving ? null : () => unawaited(cubit.save(ReviewDestination.pdf)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
