import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _cloudinaryApiKey = '366556954235497';
  static const String _cloudinaryApiSecret = 'rXaQX1rtw1HLav_tisG2e1eRw8Y';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<void> saveCloudinaryCredentials({
    required String apiKey,
    required String apiSecret,
  }) async {
    await _storage.write(key: _cloudinaryApiKey, value: apiKey);
    await _storage.write(key: _cloudinaryApiSecret, value: apiSecret);
  }

  Future<String?> getCloudinaryApiKey() async {
    return await _storage.read(key: _cloudinaryApiKey);
  }

  Future<String?> getCloudinaryApiSecret() async {
    return await _storage.read(key: _cloudinaryApiSecret);
  }

  Future<bool> hasCloudinaryCredentials() async {
    final apiKey = await getCloudinaryApiKey();
    final apiSecret = await getCloudinaryApiSecret();
    return apiKey != null && apiSecret != null;
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
