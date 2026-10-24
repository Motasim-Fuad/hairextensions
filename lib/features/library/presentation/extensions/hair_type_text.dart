import 'package:hairextensions/core/shared_entities/hair_type.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';

extension HairTypeText on HairType {
  String label(AppLocalizations l10n) => switch (this) {
    HairType.tapeIn => l10n.hairTypeTapeIn,
    HairType.keratin => l10n.hairTypeKeratin,
    HairType.weft => l10n.hairTypeWeft,
    HairType.iTip => l10n.hairTypeITip,
    HairType.clipIn => l10n.hairTypeClipIn,
  };
}
