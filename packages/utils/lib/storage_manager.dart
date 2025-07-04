import 'package:shared_preferences/shared_preferences.dart';

/// A mixin that provides methods to store, retrieve and remove values from storage.
mixin StorageManager {
  String AUTH_LOADING = "AUTH_LOADING";
  String AUTH_USER = "AUTH_USER";
  String AUTH_TOKEN = "AUTH_TOKEN";
  String SELECTED_ARTIST = "SELECTED_ARTIST";
  String USER_COORDS = "USER_COORDS";

  /// Stores value in storage
  Future<void> storeValue(String key, String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value ?? "");
  }

  /// Retrieves value from storage
  Future<String?> getValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Removes value from storage
  Future<void> removeValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /// Stores or removes value from storage
  Future<void> setValue(String key, String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await (value != null ? prefs.setString(key, value) : prefs.remove(key));
  }
}
