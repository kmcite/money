import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'experiments.g.dart';

// Table Definitions
class Persons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get editing => boolean().withDefault(const Constant(false))();
  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personId => integer()
      .nullable()
      .references(Persons, #id, onDelete: KeyAction.cascade)();
  IntColumn get amount => integer()();
  TextColumn get notes => text()();
  BoolColumn get editing => boolean().withDefault(const Constant(false))();
  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();
}

// Data Classes for Relationships
class PersonWithTransactions {
  final Person person;
  final List<Transaction> transactions;

  PersonWithTransactions({
    required this.person,
    required this.transactions,
  });

  // Helper getter for total amount
  int get totalAmount => transactions.fold(
        0,
        (previousValue, transaction) => previousValue + transaction.amount,
      );
}

// Database Definition
@DriftDatabase(tables: [Persons, Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'money',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  // Get a person with their transactions
  Future<PersonWithTransactions> getPersonWithTransactions(int personId) async {
    final person = await (select(persons)..where((p) => p.id.equals(personId)))
        .getSingle();
    final transactions = await getTransactionsForPerson(personId);

    return PersonWithTransactions(
      person: person,
      transactions: transactions,
    );
  }

  // Get all people with their transactions
  Future<List<PersonWithTransactions>> getAllPeopleWithTransactions() async {
    final people = await select(persons).get();
    return Future.wait(
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
  }

  // Helper method to get transactions for a person
  Future<List<Transaction>> getTransactionsForPerson(int personId) {
    return (select(transactions)
          ..where((t) => t.personId.equals(personId))
          ..orderBy([(t) => OrderingTerm.desc(t.created)]))
        .get();
  }

  // Get total amount for a person using SQL (optimized)
  Future<int> getTotalForPerson(int personId) {
    final amountSum = transactions.amount.sum();
    final query = selectOnly(transactions)
      ..where(transactions.personId.equals(personId))
      ..addColumns([amountSum]);

    return query.map((row) => row.read(amountSum) ?? 0).getSingle();
  }

  // Add a new person
  Future<int> addPerson(String name) {
    return into(persons).insert(PersonsCompanion.insert(name: name));
  }

  // Add a new transaction for a person
  Future<int> addTransaction(int personId, int amount, String notes) {
    return into(transactions).insert(
      TransactionsCompanion.insert(
        personId: Value(personId),
        amount: amount,
        notes: notes,
      ),
    );
  }

  // Delete a person and their transactions (cascading delete)
  Future<void> deletePerson(int personId) async {
    await (delete(persons)..where((p) => p.id.equals(personId))).go();
  }
}
