import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const _storage = FlutterSecureStorage();

  static const _kDbKey = 'db_key_v1';
  static const _kLockEnabled = 'lock_enabled_v1';
  static const _kLockDelaySeconds = 'lock_delay_seconds_v1';
  static const _kLockOnBackground = 'lock_on_background_v1';
  static const _kPasscode = 'passcode_v1';

  Future<String?> readDbKey() => _storage.read(key: _kDbKey);
  Future<void> writeDbKey(String key) => _storage.write(key: _kDbKey, value: key);

  Future<String?> readLockEnabled() => _storage.read(key: _kLockEnabled);
  Future<void> writeLockEnabled(bool enabled) =>
      _storage.write(key: _kLockEnabled, value: enabled ? '1' : '0');

  Future<int?> readLockDelaySeconds() async {
    final v = await _storage.read(key: _kLockDelaySeconds);
    if (v == null) return null;
    return int.tryParse(v);
  }

  Future<void> writeLockDelaySeconds(int seconds) =>
      _storage.write(key: _kLockDelaySeconds, value: seconds.toString());

  Future<String?> readLockOnBackground() => _storage.read(key: _kLockOnBackground);
  Future<void> writeLockOnBackground(bool enabled) =>
      _storage.write(key: _kLockOnBackground, value: enabled ? '1' : '0');

  // Passcode is stored in secure storage. For a production app you might store a hash,
  // but secure storage is already OS-protected and is acceptable for this MVP.
  Future<String?> readPasscode() => _storage.read(key: _kPasscode);
  Future<void> writePasscode(String? code) async {
    if (code == null) {
      await _storage.delete(key: _kPasscode);
    } else {
      await _storage.write(key: _kPasscode, value: code);
    }
  }
}
