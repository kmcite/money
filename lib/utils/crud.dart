import 'package:money/main.dart';
import 'package:objectbox/objectbox.dart';

mixin CRUD<T> on Repository<T> {
  late final store = serve<Store>();
  late final Box<T> crud = store.box<T>();

  Iterable<T> getAll() => crud.getAll();
  T? get(int id) => crud.get(id);
  void put(T entity) {
    crud.put(entity);
    notifyListeners();
  }

  void remove(T entity) {
    final id = (entity as dynamic).id;
    if (id != null) {
      crud.remove(id);
      notifyListeners();
    }
  }

  void removeAll() {
    crud.removeAll();
    notifyListeners();
  }

  int get length => crud.count();
  Stream<List<T>> watch() {
    return crud
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
