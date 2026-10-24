import 'package:flutter/material.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/core/theme/tokens/app_shadows.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/features/quotes/domain/entities/document_row.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_document.dart';
import 'package:hairextensions/shared/widgets/media/business_logo.dart';

/// Paper-style rendering of a [QuoteDocument], matching the shared PDF.
class QuoteDocumentPreview extends StatelessWidget {
  const QuoteDocumentPreview({required this.document, super.key, this.logoPath});

  final QuoteDocument document;
  final String? logoPath;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final muted = AppTextStyles.micro.copyWith(color: colors.textTertiary);
    final callToAction = document.callToAction;
    final note = document.note;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surface, borderRadius: AppRadius.mdAll, boxShadow: AppShadows.card),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                BusinessLogo(businessName: document.businessName, logoPath: logoPath, size: AppSizes.iconBadgeSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document.businessName, style: AppTextStyles.monogram.copyWith(color: colors.textPrimary)),
                      Text(document.businessContact, style: muted),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(document.title, style: AppTextStyles.documentTitle.copyWith(color: colors.primary)),
                    Text(document.reference, style: muted),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(document.billToLabel, style: AppTextStyles.overline.copyWith(color: colors.textTertiary)),
            Text(document.billTo, style: AppTextStyles.caption.copyWith(color: colors.textPrimary)),
            const SizedBox(height: AppSpacing.md),
            _Row(
              row: DocumentRow(label: document.descriptionLabel, value: document.amountLabel),
              isHeader: true,
            ),
            for (final row in document.lines) _Row(row: row),
            const SizedBox(height: AppSpacing.sm),
            for (final row in document.summary) _SummaryRow(row: row),
            if (note != null && note.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(document.noteLabel ?? '', style: AppTextStyles.overline.copyWith(color: colors.textTertiary)),
              Text(note, style: AppTextStyles.caption.copyWith(color: colors.textSecondary)),
            ],
            if (callToAction != null) ...[
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: colors.primary, borderRadius: AppRadius.smAll),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    child: Text(callToAction, style: AppTextStyles.chip.copyWith(color: colors.onPrimary)),
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text(document.footer, style: muted, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.row, this.isHeader = false});

  final DocumentRow row;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = isHeader
        ? AppTextStyles.micro.copyWith(color: colors.textTertiary)
        : AppTextStyles.caption.copyWith(color: colors.textPrimary);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          spacing: AppSpacing.sm,
          children: [
            Expanded(child: Text(row.label, style: style)),
            Text(row.value, style: style),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.row});

  final DocumentRow row;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = row.isEmphasized
        ? AppTextStyles.detailStrong.copyWith(color: colors.primary)
        : AppTextStyles.caption.copyWith(color: colors.textSecondary);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          Expanded(child: Text(row.label, style: style)),
          Text(row.value, style: style),
        ],
      ),
    );
  }
}
