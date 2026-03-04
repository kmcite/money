import 'package:money/expenses/expense_model.dart';
import 'package:money/main.dart';

final showExpenseSignal = signal<Expense?>(null);

class ShowExpenseDialog extends UI {
  final Expense expense;
  const ShowExpenseDialog(this.expense, {super.key});

  @override
  void init(BuildContext context) {
    showExpenseSignal.set(expense);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expense = showExpenseSignal.value!;

    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.attach_money,
            size: 24,
          ),
          SizedBox(width: 8),
          Text('Expense Details'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),

          // Amount
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '₹${expense.money.toStringAsFixed(0)}',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),

          // Note
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              expense.note.isNotEmpty ? expense.note : 'No note added',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: expense.note.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
                fontSize: 16,
              ),
            ),
          ),

          // Date
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${expense.day}/${expense.month}/${expense.year}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => navigateBack(),
          child: Text('Close'),
        ),
      ],
    );
  }
}
