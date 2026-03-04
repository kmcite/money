import 'package:money/dashboard/application_shell.dart';
import 'package:money/expenses/expense_tile.dart';
import 'package:money/expenses/expenses_screen.dart';
import 'package:money/expenses/expense_model.dart';
import 'package:money/main.dart';
import 'package:money/settings/dark.dart';

class DashboardPage extends UI {
  const DashboardPage({super.key});

  @override
  Widget build(context) {
    final theme = Theme.of(context);
    final allExpenses = expenses();
    final allTotal = allExpenses.fold(
      0,
      (sum, expense) => sum + expense.money,
    );
    // Get recent expenses (last 5, sorted by date)
    final recentExpenses = List<Expense>.from(allExpenses)
      ..sort((a, b) => b.date.compareTo(a.date));
    final recentFive = recentExpenses.take(5).toList();

    // Calculate today's total
    final today = DateTime.now();
    final todayExpenses = allExpenses.where((expense) {
      return expense.date.year == today.year &&
          expense.date.month == today.month &&
          expense.date.day == today.day;
    }).toList();
    final todayTotal = todayExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.money,
    );

    // Calculate monthly total
    final monthlyExpenses = allExpenses.where((expense) {
      return expense.date.year == today.year &&
          expense.date.month == today.month;
    }).toList();
    final monthlyTotal = monthlyExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.money,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => darkToggled(),
            icon: Icon(darkSignal() ? Icons.dark_mode : Icons.light_mode),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Total Expense',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '₹${allTotal.toStringAsFixed(0)}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Quick Stats',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Stats Cards Grid
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.bar_chart,
                        size: 24,
                      ),
                      SizedBox(height: 8),
                      Text('Monthly'),
                      SizedBox(height: 4),
                      Text(
                        '₹${monthlyTotal.toStringAsFixed(0)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.money,
                        size: 24,
                      ),
                      SizedBox(height: 8),
                      Text('Today'),
                      SizedBox(height: 4),
                      Text(
                        '₹${todayTotal.toStringAsFixed(0)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Recent Expenses Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Expenses',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    indexSignal.set(1);
                  },
                  child: Text(
                    'View All',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recent Expenses List
            if (recentFive.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 48,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No expenses yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your recent expenses will appear here',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: recentFive
                    .asMap()
                    .entries
                    .map((entry) => ExpenseTile(expense: entry.value))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
