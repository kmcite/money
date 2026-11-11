import 'package:money/model/expense_model.dart';

enum SortOption {
  date('Date'),
  money('Money'),
  note('Note');

  const SortOption(this.label);
  final String label;
  int Function(Expense, Expense) get comparator {
    return switch (this) {
      SortOption.date => (a, b) => b.date.compareTo(a.date),
      SortOption.money => (a, b) => b.money.compareTo(a.money),
      SortOption.note => (a, b) => a.note.compareTo(b.note),
    };
  }
}
