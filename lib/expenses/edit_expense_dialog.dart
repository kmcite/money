import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:money/db/objects.dart';
import 'package:money/expenses/add_expense_dialog.dart';
import 'package:money/expenses/expense_model.dart';
import 'package:money/main.dart';

class EditExpenseDialog extends UI {
  final Expense expense;

  const EditExpenseDialog(this.expense, {super.key});

  @override
  void init(BuildContext context) {
    // Create a copy to avoid modifying the original until save
    final expenseCopy = Expense()
      ..id = expense.id
      ..money = expense.money
      ..note = expense.note
      ..date = expense.date;
    expenseSignal.set(expenseCopy);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentExpense = expenseSignal.value!;

    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.edit,
            color: theme.primaryColor,
            size: 24,
          ),
          SizedBox(width: 8),
          Text('Edit Expense'),
        ],
      ),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            SizedBox(height: 8),

            // Note field
            TextField(
              decoration: InputDecoration(
                hintText: 'Note',
                prefixIcon: Icon(
                  Icons.edit_note,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              controller: TextEditingController(text: currentExpense.note),
              onChanged: (value) =>
                  expenseSignal.set(currentExpense..note = value),
              maxLines: 3,
              minLines: 1,
            ),

            // Amount field
            TextField(
              decoration: InputDecoration(
                hintText: 'Amount',
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              controller: TextEditingController(
                text: currentExpense.money.toString(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                try {
                  expenseSignal.set(currentExpense..money = int.parse(value));
                } catch (e) {
                  // Handle invalid input
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => navigateBack(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            navigateBack();
            objects.put(currentExpense);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
