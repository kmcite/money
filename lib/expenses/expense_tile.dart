import 'package:money/expenses/expense_model.dart';
import 'package:money/expenses/edit_expense_dialog.dart';
import 'package:money/expenses/delete_expense_dialog.dart';
import 'package:money/expenses/show_expense_dialog.dart';
import 'package:money/main.dart';

/// A reusable tile widget representing a single [Expense].
///
/// This was extracted from `ExpensesScreen` so that the list can stay
/// clean and the tile logic is encapsulated. The tile now shows the
/// **amount** as the title and the **date** as the subtitle.
enum MenuAction { edit, delete }

class ExpenseTile extends StatelessWidget {
  final Expense expense;

  const ExpenseTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        Icons.money,
        size: 20,
      ),
      title: Text(
        '₹${expense.money.toStringAsFixed(0)}',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${expense.day}/${expense.month}/${expense.year}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: MenuAction.edit,
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
                onTap: () {
                  navigateToDialog(
                    EditExpenseDialog(expense),
                  );
                },
              ),
              PopupMenuItem(
                value: MenuAction.delete,
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
                onTap: () {
                  navigateToDialog(
                    DeleteExpenseDialog(expense),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      onTap: () => navigateToDialog(ShowExpenseDialog(expense)),
    );
  }
}
