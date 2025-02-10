import 'package:money/experiments.dart';

import '../main.dart';

final AppDatabase appDatabase = AppDatabase();

final personsWithTransactions = RM.injectStream(
  appDatabase.watchAllPeopleWithTransactions,
);

extension AllPeopleWithTransactions on AppDatabase {
  Stream<List<PersonWithTransactions>> watchAllPeopleWithTransactions() {
    return select(persons).watch().asyncMap(
      (List<Person> people) async {
        // For each person, fetch their transactions
        final List<PersonWithTransactions> peopleWithTransactions =
            await Future.wait(
          people.map(
            (person) async {
              final transactions = await getTransactionsForPerson(person.id);
              return PersonWithTransactions(
                person: person,
                transactions: transactions,
              );
            },
          ),
        );

        return peopleWithTransactions;
      },
    );
  }
}
