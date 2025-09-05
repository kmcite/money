import 'package:money/main.dart';

class Lengdex {
  int length = 4;
  int index = 0;
}

class IndexRepository extends Repository<Lengdex> {
  Lengdex lengdex = Lengdex();

  void index(int index) {
    lengdex.index = index;
    notifyListeners();
  }

  void length(int length) {
    lengdex.length = length;
    notifyListeners();
  }
}
