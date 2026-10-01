abstract class SettingsRepository {
  String? getApiUrl();

  Future<void> saveApiUrl(String url);
}
