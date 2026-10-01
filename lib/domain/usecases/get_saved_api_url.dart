import 'package:ws_test/domain/repositories/settings_repository.dart';

class GetSavedApiUrl {
  const GetSavedApiUrl(this._repository);

  final SettingsRepository _repository;

  String? call() => _repository.getApiUrl();
}
