import 'package:money/main.dart';
import 'package:money/utils/hive.dart';

class DarkRepository extends Repository<bool> with Hive {
  DarkRepository() {
    final saved = box.get('dark') == 'true';
    setDark(saved);
  }
  bool dark = false;

  void setDark(bool value) {
    dark = value;
    box.put('dark', value.toString());
    notifyListeners();
  }
}
