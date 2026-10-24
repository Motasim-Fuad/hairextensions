import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/extensions/theme_context_extension.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/core/shared_entities/sold_by.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/core/theme/tokens/app_sizes.dart';
import 'package:hairextensions/core/theme/tokens/app_spacing.dart';
import 'package:hairextensions/core/theme/tokens/app_text_styles.dart';
import 'package:hairextensions/core/utils/money_formatter.dart';
import 'package:hairextensions/core/utils/percent_formatter.dart';
import 'package:hairextensions/features/library/presentation/bloc/library/library_cubit.dart';
import 'package:hairextensions/features/library/presentation/bloc/library/library_segment.dart';
import 'package:hairextensions/features/library/presentation/bloc/library/library_sort.dart';
import 'package:hairextensions/features/library/presentation/extensions/hair_type_text.dart';
import 'package:hairextensions/features/library/presentation/widgets/library_item_tile.dart';
import 'package:hairextensions/shared/state/view_status.dart';
import 'package:hairextensions/shared/widgets/buttons/app_icon_button.dart';
import 'package:hairextensions/shared/widgets/feedback/empty_state.dart';
import 'package:hairextensions/shared/widgets/inputs/app_search_field.dart';
import 'package:hairextensions/shared/widgets/inputs/app_segmented_control.dart';
import 'package:hairextensions/shared/widgets/inputs/segment_option.dart';
import 'package:hairextensions/shared/widgets/layout/app_large_title.dart';
import 'package:hairextensions/shared/widgets/media/app_svg_icon.dart';
import 'package:hairextensions/shared/widgets/shimmer/skeleton_list.dart';

/// Design 4.2. Prices shown in the library currency (AED in the demo).
class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  static const String currency = 'AED';

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    const currency = LibraryView.currency;
    String money(int minor, {bool decimals = false}) => MoneyFormatter.format(minor, currency, showDecimals: decimals);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<LibraryCubit, LibraryState>(
          builder: (context, state) {
            final cubit = context.read<LibraryCubit>();
            if (state.status == ViewStatus.loading) {
              return const SkeletonList();
            }
            final rows = switch (state.segment) {
              LibrarySegment.products => [
                for (final product in state.visibleProducts)
                  LibraryItemTile(
                    icon: AppIcon.package,
                    title: product.name,
                    subtitle: [product.type.label(l10n), product.colour].join(l10n.separatorDot),
                    detail: l10n.productPackPrice(
                      money(product.packPriceMinor),
                      product.unitsPerPack,
                      product.soldBy == SoldBy.pieces ? l10n.unitStrands : l10n.unitGramsShort,
                    ),
                    chipLabel: money(product.costPerUnitMinor, decimals: true),
                    chipCaption: product.soldBy == SoldBy.pieces ? l10n.perStrand : l10n.perGram,
                    onTap: () => unawaited(context.pushNamed<void>(AppRoutes.productForm, extra: product)),
                  ),
              ],
              LibrarySegment.materials => [
                for (final material in state.visibleMaterials)
                  LibraryItemTile(
                    icon: AppIcon.wallet,
                    title: material.name,
                    subtitle: l10n.materialCostPrice(money(material.unitCostMinor), money(material.unitPriceMinor)),
                    chipLabel: money(material.unitPriceMinor),
                  ),
              ],
              LibrarySegment.services => [
                for (final service in state.visibleServices)
                  LibraryItemTile(
                    icon: AppIcon.scissors,
                    title: service.name,
                    subtitle: service.isHourly
                        ? l10n.lineHoursRatePerHour(PercentFormatter.format(service.hours), money(service.rateMinor))
                        : l10n.lineFlatFee,
                    chipLabel: money(service.chargeMinor),
                  ),
              ],
            };
            return ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xxl),
              children: [
                AppLargeTitle(
                  title: l10n.navLibrary,
                  trailing: [
                    AppIconButton(
                      icon: AppIcon.plus,
                      semanticLabel: l10n.homeAddProduct,
                      isTinted: true,
                      onPressed: () => unawaited(context.pushNamed<void>(AppRoutes.productForm)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppSegmentedControl<LibrarySegment>(
                  options: [
                    SegmentOption(value: LibrarySegment.products, label: l10n.libraryProducts),
                    SegmentOption(value: LibrarySegment.materials, label: l10n.labelMaterials),
                    SegmentOption(value: LibrarySegment.services, label: l10n.libraryServices),
                  ],
                  selected: state.segment,
                  onChanged: cubit.selectSegment,
                ),
                const SizedBox(height: AppSpacing.md),
                AppSearchField(controller: _search, hintText: l10n.librarySearchHint, onChanged: cubit.search),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.libraryCount(state.visibleCount),
                        style: AppTextStyles.detailStrong.copyWith(color: colors.textSecondary),
                      ),
                    ),
                    if (state.segment == LibrarySegment.products)
                      InkWell(
                        onTap: cubit.toggleSort,
                        child: Row(
                          spacing: AppSpacing.xs,
                          children: [
                            Text(
                              state.sort == LibrarySort.recent ? l10n.sortRecent : l10n.sortName,
                              style: AppTextStyles.detailAccent.copyWith(color: colors.textSecondary),
                            ),
                            AppSvgIcon(AppIcon.chevronDown, size: AppSizes.iconSm, color: colors.textSecondary),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                if (rows.isEmpty)
                  EmptyState(
                    icon: AppIcon.search,
                    title: l10n.libraryNoResults,
                    message: l10n.quotesNoResultsMessage,
                  )
                else
                  for (final row in rows)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: row,
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}
