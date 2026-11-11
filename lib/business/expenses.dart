import 'dart:async';

import 'package:get/get.dart';
import 'package:money/model/expense_model.dart';
import 'package:money/model/expenses_repository.dart';
import 'package:money/model/sort_option.dart';

class ExpenseController extends GetxController {
  ExpenseController(this._repository);

  final ExpenseRepository _repository;

  final expenses = <Expense>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final sortBy = SortOption.date.obs;

  StreamSubscription<List<Expense>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _repository.watchExpenses().listen(
      _onExpensesChanged,
      onError: _onExpensesError,
    );
    unawaited(reload());
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _subscription = null;
    super.onClose();
  }

  Future<void> reload() async {
    try {
      final items = await _repository.getExpenses();
      expenses.assignAll(items);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveExpense(Expense expense) async {
    await _repository.saveExpense(expense);
    await reload();
  }

  Future<void> deleteExpense(Expense expense) async {
    await _repository.deleteExpense(expense.id);
    await reload();
  }

  void setSearchQuery(String value) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  void setSortBy(SortOption value) {
    sortBy.value = value;
  }

  List<Expense> get filteredExpenses {
    final query = searchQuery.value.trim().toLowerCase();
    final filtered = expenses.where((expense) {
      if (query.isEmpty) return true;
      return expense.note.toLowerCase().contains(query) ||
          expense.money.toString().contains(query);
    }).toList();
    filtered.sort(sortBy.value.comparator);
    return filtered;
  }

  int get total => expenses.fold(0, (sum, expense) => sum + expense.money);

  List<Expense> get recent {
    return List.of(expenses)..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Expense> get recentFive => recent.take(5).toList();

  int totalByDate(DateTime date) {
    return expenses
        .where(
          (expense) =>
              expense.date.year == date.year &&
              expense.date.month == date.month &&
              expense.date.day == date.day,
        )
        .fold(0, (sum, expense) => sum + expense.money);
  }

  int totalByMonth(DateTime date) {
    return expenses
        .where(
          (expense) =>
              expense.date.year == date.year &&
              expense.date.month == date.month,
        )
        .fold(0, (sum, expense) => sum + expense.money);
  }

  void _onExpensesChanged(List<Expense> items) {
    expenses.assignAll(items);
    isLoading.value = false;
  }

  void _onExpensesError(Object error, StackTrace stackTrace) {
    isLoading.value = false;
  }
}
