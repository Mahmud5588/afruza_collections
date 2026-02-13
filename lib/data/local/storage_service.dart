import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:shared_preferences/shared_preferences.dart";

class StorageService {
  StorageService(this.prefs, this.secureStorage);

  final SharedPreferences prefs;
  final FlutterSecureStorage secureStorage;

  static const _tokenKey = "auth_token";
  static const _refreshTokenKey = "refresh_token";
  static const _tokenIssuedAtKey = "auth_token_issued_at";
  static const _isAdminKey = "is_admin";
  static const _localeKey = "app_locale";

  Future<void> saveToken(String token) async {
    await secureStorage.write(key: _tokenKey, value: token);
    await prefs.setInt(
      _tokenIssuedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> readToken() {
    return secureStorage.read(key: _tokenKey);
  }

  Future<String?> readRefreshToken() {
    return secureStorage.read(key: _refreshTokenKey);
  }

  Future<DateTime?> readTokenIssuedAt() async {
    final value = prefs.getInt(_tokenIssuedAtKey);
    if (value == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<bool> isTokenValid(Duration maxAge) async {
    final token = await readToken();
    if (token == null) {
      return false;
    }
    final issuedAt = await readTokenIssuedAt();
    if (issuedAt == null) {
      return false;
    }
    final expiry = issuedAt.add(maxAge);
    return DateTime.now().isBefore(expiry);
  }

  Future<void> saveIsAdmin(bool isAdmin) async {
    await prefs.setBool(_isAdminKey, isAdmin);
  }

  Future<bool> readIsAdmin() async {
    return prefs.getBool(_isAdminKey) ?? false;
  }

  Future<void> saveLocaleCode(String code) async {
    await prefs.setString(_localeKey, code);
  }

  Future<String?> readLocaleCode() async {
    return prefs.getString(_localeKey);
  }

  Future<void> clearToken() async {
    await secureStorage.delete(key: _tokenKey);
    await secureStorage.delete(key: _refreshTokenKey);
    await prefs.remove(_tokenIssuedAtKey);
    await prefs.remove(_isAdminKey);
  }
}
