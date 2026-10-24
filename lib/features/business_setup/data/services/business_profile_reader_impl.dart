import 'package:hairextensions/core/contracts/business_profile_reader.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/features/business_setup/data/datasources/local/business_profile_local_data_source.dart';
import 'package:hairextensions/features/business_setup/data/mappers/business_profile_mapper.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BusinessProfileReader)
class BusinessProfileReaderImpl implements BusinessProfileReader {
  BusinessProfileReaderImpl(this._local);

  final BusinessProfileLocalDataSource _local;

  @override
  Future<BusinessProfile?> read() async {
    final model = await _local.read();
    return model == null ? null : BusinessProfileMapper.toEntity(model);
  }

  @override
  Stream<BusinessProfile?> watch() async* {
    yield await read();
    yield* _local.changes.map(BusinessProfileMapper.toEntity);
  }
}
