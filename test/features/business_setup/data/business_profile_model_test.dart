import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/database/tables/business_profile_table.dart';
import 'package:hairextensions/features/business_setup/data/mappers/business_profile_mapper.dart';
import 'package:hairextensions/features/business_setup/data/models/business_profile_model.dart';
import 'package:hairextensions/features/business_setup/domain/entities/business_profile_draft.dart';

import '../../../fixtures/business_profile_fixture.dart';

void main() {
  const base = BusinessProfileFixture.glamStrands;
  final model = BusinessProfileMapper.toModel(
    BusinessProfileDraft.fromProfile(base).withLogo('/logos/logo_1.png').toProfile(base: base),
    createdAt: 1,
    updatedAt: 2,
  );

  test('row round trip keeps every field including the local logo', () {
    final restored = BusinessProfileModel.fromRow(model.toRow(syncStatus: 'pending'));
    expect(BusinessProfileMapper.toEntity(restored), BusinessProfileMapper.toEntity(model));
  });

  test('JSON never carries the device-local logo path', () {
    final json = model.toJson();
    expect(json.containsKey(BusinessProfileTable.logoPath), isFalse);
    expect(BusinessProfileModel.fromJson(json).logoPath, isNull);
    expect(BusinessProfileModel.fromJson(json).businessName, model.businessName);
  });
}
