import 'package:hairextensions/features/business_setup/data/datasources/local/logo_file_store.dart';

class FakeLogoFileStore implements LogoFileStore {
  final List<String> deleted = [];

  @override
  Future<String> store(String sourcePath) async => '/stored/$sourcePath';

  @override
  Future<void> delete(String path) async => deleted.add(path);
}
