import 'package:money/main.dart';
import 'package:money/utils/crud.dart';
import 'package:money/domain/models/person.dart';

class PersonsRepository extends Repository<Person> with CRUD<Person> {}

extension PersonX on Person {
  int get amount {
    // final repo = repository<TransactionsRepository>();
    // final persons = repo.getAll();
    // final personTxs = persons.where((ele) => ele.personId == id);
    // final amount = personTxs.fold(0, (i, v) => i + v.amount);
    return 0;
  }
}
