import 'package:ws_test/domain/repositories/settings_repository.dart';

class SaveApiUrl {
  const SaveApiUrl(this._repository);

  final SettingsRepository _repository;

  Future<void> call(String url) {
    return _repository.saveApiUrl(url.trim());
  }
}
