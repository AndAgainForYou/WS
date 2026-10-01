import 'package:hive/hive.dart';

class SettingsLocalDataSource {
  const SettingsLocalDataSource(this._box);

  static const _apiUrlKey = 'api_url';

  final Box<dynamic> _box;

  String? getApiUrl() {
    final value = _box.get(_apiUrlKey);
    return value is String ? value : null;
  }

  Future<void> saveApiUrl(String url) {
    return _box.put(_apiUrlKey, url);
  }
}
