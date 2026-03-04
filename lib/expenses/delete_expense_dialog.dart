import 'package:money/db/objects.dart';
import 'package:money/expenses/expense_model.dart';
import 'package:money/main.dart';

class DeleteExpenseDialog extends StatelessWidget {
  final Expense expense;
  const DeleteExpenseDialog(this.expense, {super.key});

  @override
  Widget build(context) {
    return AlertDialog(
      title: Text('Delete Expense'),
      content: Text('Are you sure you want to delete this expense?'),
      actions: [
        TextButton(
          onPressed: () => navigateBack(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            objects.remove<Expense>(expense.id);
            navigateBack();
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
