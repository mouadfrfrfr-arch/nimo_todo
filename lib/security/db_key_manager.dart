import 'dart:math';

import 'package:nimo_todo/security/secure_store.dart';

class DbKeyManager {
  DbKeyManager({SecureStore? store}) : _store = store ?? SecureStore();
  final SecureStore _store;

  Future<String> getOrCreateDbKey() async {
    final existing = await _store.readDbKey();
    if (existing != null && existing.isNotEmpty) return existing;

    final generated = _randomKey(32);
    await _store.writeDbKey(generated);
    return generated;
  }

  String _randomKey(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final r = Random.secure();
    return List.generate(length, (_) => chars[r.nextInt(chars.length)]).join();
  }
}
