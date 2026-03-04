import 'package:money/expenses/expense_model.dart';
import 'package:money/db/objects.dart';
import 'package:money/expenses/add_expense_dialog.dart';
import 'package:money/expenses/expense_tile.dart';
import 'package:money/main.dart';

final expensesSignal = streamSignal(
  objects.watch<Expense>,
  initialValue: <Expense>[],
);

final expenses = computed(
  () => expensesSignal().map(
    data: (data) => data,
    error: (error) => <Expense>[],
    loading: () => <Expense>[],
  ),
);

// Filter signals
final searchQuerySignal = signal('');
final sortBySignal = signal(SortOption.date);

// Computed signal for filtered and sorted expenses
final filteredExpenses = computed(() {
  final allExpenses = expenses();
  final searchQuery = searchQuerySignal().toLowerCase();
  final sortBy = sortBySignal();

  // Apply filters
  var filtered = allExpenses.where((expense) {
    final matchesSearch =
        expense.note.toLowerCase().contains(searchQuery) ||
        expense.money.toString().contains(searchQuery);
    return matchesSearch;
  }).toList();

  // Apply sorting
  filtered.sort(sortBy.comparator);
  return filtered;
});

enum SortOption {
  date('Date'),
  money('Money'),
  note('Note'),
  ;

  const SortOption(this.label);
  final String label;
}

extension on SortOption {
  int Function(Expense, Expense) get comparator {
    return switch (this) {
      SortOption.date => (a, b) => b.date.compareTo(a.date),
      SortOption.money => (a, b) => b.money.compareTo(a.money),
      SortOption.note => (a, b) => a.note.compareTo(b.note),
    };
  }
}

class ExpensesScreen extends UI {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = filteredExpenses();
    final searchQuery = searchQuerySignal();

    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              navigateToDialog(AddExpenseDialog());
            },
            icon: Icon(Icons.add),
          ),
          PopupMenuButton(
            icon: Icon(switch (sortBySignal()) {
              SortOption.date => Icons.date_range,
              SortOption.money => Icons.attach_money,
              SortOption.note => Icons.note,
            }),
            itemBuilder: (context) => SortOption.values
                .map(
                  (option) => PopupMenuItem(
                    value: option,
                    child: Text(option.label),
                  ),
                )
                .toList(),
            onSelected: (value) => sortBySignal.set(value),
          ),

          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 8,
            children: [
              // Filter and Search Section
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search expenses...',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                controller: TextEditingController(text: searchQuery),
                onChanged: (value) => searchQuerySignal.set(value),
                onFieldSubmitted: (value) => searchQuerySignal.set(value),
              ),

              // Expenses List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.money,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No expenses yet',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the + button to add your first expense',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final expense = filtered[index];
                          return ExpenseTile(expense: expense);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
