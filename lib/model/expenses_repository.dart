import 'package:money/model/expense_model.dart';
import 'package:shared_database/shared_database.dart';

class ExpenseRepository {
  ExpenseRepository({SharedDatabase? database})
    : _database = database ?? SharedDatabase.instance;

  final SharedDatabase _database;

  static const collectionName = 'expenses';

  Future<void> initialize() => _database.ensure(collectionName);

  Stream<List<Expense>> watchExpenses() {
    return _database
        .watchCollection(collectionName)
        .map((records) => records.map(_expenseFromRecord).toList());
  }

  Future<List<Expense>> getExpenses() async {
    final records = await _database.all(collectionName);
    return records.map(_expenseFromRecord).toList();
  }

  Future<String> saveExpense(Expense expense) {
    return _database.put(
      collectionName,
      expense.toJson(),
      id: expense.isPersisted ? expense.id : null,
    );
  }

  Future<void> deleteExpense(String id) {
    return _database.drop(collectionName, id);
  }

  Expense _expenseFromRecord(SharedRecord record) {
    return Expense.fromJson(record.id, record.data);
  }
}
