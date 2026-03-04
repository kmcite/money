import 'dart:async' show Completer;

import 'package:hive_flutter/hive_flutter.dart' show Box, Hive, HiveX;

class HiveStore {
  final String name;
  Box? _box;
  final _initCompleter = Completer<void>();

  HiveStore({this.name = 'money'}) {
    _init();
  }

  Future<void> _init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(name);
    _initCompleter.complete();
  }

  Future<void> ensureReady() => _initCompleter.future;

  Future<T?> read<T>(String key) async {
    await ensureReady();
    return _box!.get(key) as T?;
  }

  Future<void> write<T>(String key, T value) async {
    await ensureReady();
    await _box!.put(key, value);
  }

  Future<bool> contains(String key) async {
    await ensureReady();
    return _box!.containsKey(key);
  }
}

// Global instance
final hiveStore = HiveStore();
