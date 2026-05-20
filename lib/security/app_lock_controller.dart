import 'package:local_auth/local_auth.dart';
import 'package:nimo_todo/security/secure_store.dart';

class AppLockController {
  AppLockController({LocalAuthentication? auth, SecureStore? store})
      : _auth = auth ?? LocalAuthentication(),
        _store = store ?? SecureStore();

  final LocalAuthentication _auth;
  final SecureStore _store;

  Future<bool> isEnabled() async {
    final v = await _store.readLockEnabled();
    return v == '1';
  }

  Future<void> setEnabled(bool enabled) => _store.writeLockEnabled(enabled);

  Future<int> lockDelaySeconds() async {
    // Default: lock immediately
    return (await _store.readLockDelaySeconds()) ?? 0;
  }

  Future<void> setLockDelaySeconds(int seconds) => _store.writeLockDelaySeconds(seconds);

  Future<bool> lockOnBackground() async {
    // Default: true
    final v = await _store.readLockOnBackground();
    if (v == null) return true;
    return v == '1';
  }

  Future<void> setLockOnBackground(bool enabled) => _store.writeLockOnBackground(enabled);

  Future<bool> authenticate() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    if (!isSupported || !canCheck) return false;

    return _auth.authenticate(
      localizedReason: 'Unlock Nimo Todo Lis',
      options: const AuthenticationOptions(
        biometricOnly: false,
        stickyAuth: true,
      ),
    );
  }
}
