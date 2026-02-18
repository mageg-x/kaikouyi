import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  String? _currentUserId;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  void setCurrentUser(String? userId) {
    _currentUserId = userId;
  }

  String? getCurrentUser() {
    return _currentUserId;
  }

  String _getKey(String key) {
    if (_currentUserId == null) {
      return key;
    }
    return '${_currentUserId}_$key';
  }

  Future<void> setString(String key, String value) async {
    await _prefs?.setString(_getKey(key), value);
  }

  String? getString(String key) {
    return _prefs?.getString(_getKey(key));
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(_getKey(key), value);
  }

  int? getInt(String key) {
    return _prefs?.getInt(_getKey(key));
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(_getKey(key), value);
  }

  double? getDouble(String key) {
    return _prefs?.getDouble(_getKey(key));
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(_getKey(key), value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(_getKey(key));
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _prefs?.setStringList(_getKey(key), value);
  }

  List<String>? getStringList(String key) {
    return _prefs?.getStringList(_getKey(key));
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(_getKey(key));
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }

  bool containsKey(String key) {
    return _prefs?.containsKey(_getKey(key)) ?? false;
  }

  static Future<List<String>> getAllUserIds() async {
    if (_prefs == null) return [];
    final keys = _prefs!.getKeys();
    final userIds = <String>{};
    for (final key in keys) {
      if (key.startsWith('user_') && key.endsWith('_username')) {
        final userId = key.substring(5, key.length - 9);
        userIds.add(userId);
      }
    }
    return userIds.toList();
  }

  bool checkUserCredentials(String username, String password) {
    final storedPassword = _prefs?.getString('user_${username}_password');
    return storedPassword == password;
  }

  bool userExists(String username) {
    return _prefs?.containsKey('user_${username}_username') ?? false;
  }

  Future<void> createUser(String username, String password) async {
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    await _prefs?.setString('${userId}_username', username);
    await _prefs?.setString('${userId}_password', password);
    await _prefs?.setString('user_${username}_userId', userId);
    await _prefs?.setString('user_${username}_username', username);
  }

  String? getUserIdByUsername(String username) {
    return _prefs?.getString('user_${username}_userId');
  }
}
