import 'package:money/objectbox.g.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final objects = Objects();

class Objects {
  Store? _store;

  /// Load ObjectBox store and run migrations
  Future<void> ensureReady() async {
    if (_store != null) return;

    final dir = await getApplicationDocumentsDirectory();
    _store = await openStore(directory: join(dir.path, 'money'));
  }

  Box<T> _box<T>() {
    if (_store == null) {
      throw Exception('Store not initialized. Call ensureReady() first.');
    }
    return _store!.box<T>();
  }

  Future<void> put<T>(T object) async {
    await ensureReady();
    _box<T>().put(object);
  }

  Future<void> remove<T>(int id) async {
    await ensureReady();
    _box<T>().remove(id);
  }

  Future<void> removeAll<T>() async {
    await ensureReady();
    _box<T>().removeAll();
  }

  Future<List<T>> getAll<T>() async {
    await ensureReady();
    return _box<T>().getAll();
  }

  Stream<List<T>> watch<T>() {
    return _box<T>()
        .query()
        .watch(triggerImmediately: true)
        .map((q) => q.find());
  }
}
