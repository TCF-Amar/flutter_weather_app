import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/storage/local_storage.dart';

class SharedPrefsStorage implements LocalStorage {
  final SharedPreferences _prefs;

  SharedPrefsStorage(this._prefs);

  @override
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
