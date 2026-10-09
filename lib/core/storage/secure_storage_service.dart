import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Holds client IDs and secrets. Backed by Keychain (iOS) and
/// EncryptedSharedPreferences / Keystore (Android). Never SharedPreferences.
class SecureStorageService {
  SecureStorageService([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  static String _idKey(String projectKey) => 'op_client_id_$projectKey';
  static String _secretKey(String projectKey) => 'op_client_secret_$projectKey';

  Future<void> saveCredentials({
    required String projectKey,
    required String clientId,
    required String clientSecret,
  }) async {
    await _storage.write(key: _idKey(projectKey), value: clientId);
    await _storage.write(key: _secretKey(projectKey), value: clientSecret);
  }

  Future<({String clientId, String clientSecret})?> readCredentials(
    String projectKey,
  ) async {
    final id = await _storage.read(key: _idKey(projectKey));
    final secret = await _storage.read(key: _secretKey(projectKey));
    if (id == null || secret == null) return null;
    return (clientId: id, clientSecret: secret);
  }

  Future<void> deleteCredentials(String projectKey) async {
    await _storage.delete(key: _idKey(projectKey));
    await _storage.delete(key: _secretKey(projectKey));
  }

  /// Wipes every secret this app stored (used by Log out).
  Future<void> clearAll() => _storage.deleteAll();
}
