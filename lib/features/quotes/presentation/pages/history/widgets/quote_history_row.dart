import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_radius.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/presentation/pages/history/widgets/quote_swipe_action.dart';
import 'package:hairextensions/features/quotes/presentation/widgets/quote_list_tile.dart';

/// Swipe left for Copy and Delete (design 3.7).
class QuoteHistoryRow extends StatelessWidget {
  const QuoteHistoryRow({
    required this.quote,
    required this.now,
    required this.onTap,
    required this.onCopy,
    required this.onDelete,
    super.key,
  });

  static const double _actionsExtent = 0.42;

  final Quote quote;
  final DateTime now;
  final VoidCallback onTap;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return ClipRRect(
      borderRadius: AppRadius.lgAll,
      child: Slidable(
        key: ValueKey(quote.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: _actionsExtent,
          children: [
            QuoteSwipeAction(
              icon: AppIcon.copy,
              label: l10n.actionCopy,
              background: colors.goldSoft,
              foreground: colors.goldDeep,
              onPressed: onCopy,
            ),
            QuoteSwipeAction(
              icon: AppIcon.trash,
              label: l10n.actionDelete,
              background: colors.danger,
              foreground: colors.onPrimary,
              onPressed: onDelete,
            ),
          ],
        ),
        child: QuoteListTile(quote: quote, now: now, onTap: onTap),
      ),
    );
  }
}
