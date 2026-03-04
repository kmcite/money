import 'package:flutter/services.dart';
import 'package:money/expenses/expense_model.dart';
import 'package:money/db/objects.dart';
import 'package:money/main.dart';

final expenseSignal = signal<Expense?>(null);

class AddExpenseDialog extends UI {
  const AddExpenseDialog({super.key});

  @override
  void init(BuildContext context) {
    expenseSignal.set(Expense());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expense = expenseSignal.value!;

    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_circle,
            color: theme.primaryColor,
            size: 24,
          ),
          SizedBox(width: 8),
          Text('Add Expense'),
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
              onChanged: (value) => expenseSignal.set(expense..note = value),
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
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                try {
                  expenseSignal.set(expense..money = int.parse(value));
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
            objects.put(expense);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
