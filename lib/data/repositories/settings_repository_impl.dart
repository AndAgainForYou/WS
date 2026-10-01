import 'package:ws_test/data/datasources/local/settings_local_ds.dart';
import 'package:ws_test/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  String? getApiUrl() => _localDataSource.getApiUrl();

  @override
  Future<void> saveApiUrl(String url) {
    return _localDataSource.saveApiUrl(url);
  }
}
