import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const _storage = FlutterSecureStorage();

  static const _kDbKey = 'db_key_v1';
  static const _kLockEnabled = 'lock_enabled_v1';

  Future<String?> readDbKey() => _storage.read(key: _kDbKey);
  Future<void> writeDbKey(String key) => _storage.write(key: _kDbKey, value: key);

  Future<String?> readLockEnabled() => _storage.read(key: _kLockEnabled);
  Future<void> writeLockEnabled(bool enabled) =>
      _storage.write(key: _kLockEnabled, value: enabled ? '1' : '0');
}
