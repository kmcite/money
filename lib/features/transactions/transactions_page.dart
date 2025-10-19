import 'package:money/domain/repositories/transactions_repository.dart';
import 'package:money/features/transactions/add_transaction_dialog.dart';
import 'package:money/utils/date_formatter.dart';
import 'package:money/main.dart';
import 'package:money/domain/models/transaction.dart';
import 'package:money/utils/navigator.dart';

class TransactionsBloc extends Bloc {
  late TransactionsRepository transactionsRepository = depend();

  /// GLOBAL STATE
  Iterable<Transaction> get transactions => transactionsRepository.getAll();

  /// LOCAL STATE
  String query = '';
  String sortBy = 'date'; // 'date', 'amount', 'person'
  bool sortAscending = false;

  Iterable<Transaction> get filteredTransactions {
    var filtered = transactions.where(
      (transaction) {
        final matchesQuery = query.isEmpty ||
            transaction.notes.toLowerCase().contains(query.toLowerCase()) ||
            transaction.amount.toString().contains(query) ||
            transaction.person.target?.name
                    .toLowerCase()
                    .contains(query.toLowerCase()) ==
                true;

        return matchesQuery;
      },
    );

    // Sort transactions
    final sortedList = filtered.toList();
    sortedList.sort((a, b) {
      int comparison = 0;
      switch (sortBy) {
        case 'amount':
          comparison = a.amount.compareTo(b.amount);
          break;
        case 'person':
          final aName = a.person.target?.name ?? '';
          final bName = b.person.target?.name ?? '';
          comparison = aName.compareTo(bName);
          break;
        case 'date':
        default:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
      }
      return sortAscending ? comparison : -comparison;
    });

    return sortedList;
  }

  /// MUTATIONS
  void onQueryChanged(String value) {
    query = value;
    notifyListeners();
  }

  void onSortChanged(String newSortBy) {
    if (sortBy == newSortBy) {
      sortAscending = !sortAscending;
    } else {
      sortBy = newSortBy;
      sortAscending = false;
    }
    notifyListeners();
  }

  void onTransactionRemoved(Transaction transaction) {
    transactionsRepository.remove(transaction);
  }

  void onTransactionUpdated(Transaction transaction) =>
      transactionsRepository.put(transaction);
}

class TransactionsPage extends Feature<TransactionsBloc> {
  @override
  TransactionsBloc create() => TransactionsBloc();
  const TransactionsPage({super.key});

  @override
  Widget build(context, controller) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          IconButton(
            onPressed: () => navigator.toDialog(NewTransactionDialog()),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search transactions...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: controller.onQueryChanged,
                ),
                SizedBox(height: 12),
                // Sort Options
                Row(
                  children: [
                    Text('Sort by:',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(width: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _SortChip(
                              label: 'Date',
                              isSelected: controller.sortBy == 'date',
                              onTap: () => controller.onSortChanged('date'),
                              sortAscending: controller.sortBy == 'date'
                                  ? controller.sortAscending
                                  : null,
                            ),
                            SizedBox(width: 8),
                            _SortChip(
                              label: 'Amount',
                              isSelected: controller.sortBy == 'amount',
                              onTap: () => controller.onSortChanged('amount'),
                              sortAscending: controller.sortBy == 'amount'
                                  ? controller.sortAscending
                                  : null,
                            ),
                            SizedBox(width: 8),
                            _SortChip(
                              label: 'Person',
                              isSelected: controller.sortBy == 'person',
                              onTap: () => controller.onSortChanged('person'),
                              sortAscending: controller.sortBy == 'person'
                                  ? controller.sortAscending
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: controller.filteredTransactions.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction =
                          controller.filteredTransactions.elementAt(index);
                      return _TransactionItem(
                        transaction,
                        onTransactionUpdated: controller.onTransactionUpdated,
                        onTransactionRemoved: controller.onTransactionRemoved,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final void Function(Transaction) onTransactionUpdated;
  final void Function(Transaction) onTransactionRemoved;

  const _TransactionItem(
    this.transaction, {
    required this.onTransactionUpdated,
    required this.onTransactionRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount > 0;
    final amountColor = isPositive ? Colors.green : Colors.red;
    final personName = transaction.person.target?.name ?? 'Unknown';

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.notes.isNotEmpty
                            ? transaction.notes
                            : 'Transaction',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'With $personName',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        DateFormatter.formatRelative(transaction.date),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isPositive ? '+' : ''}\$${transaction.amount.abs().toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: amountColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => navigator.toDialog(
                            EditTransactionAmountDialog(
                              transaction,
                              onConfirm: onTransactionUpdated,
                              onCancel: () => navigator.back(),
                            ),
                          ),
                          icon: Icon(Icons.edit, size: 16),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                          ),
                        ),
                        SizedBox(width: 4),
                        IconButton(
                          onPressed: () => onTransactionRemoved(transaction),
                          icon: Icon(Icons.delete, size: 16),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: amountColor.withOpacity(0.1),
                child: Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: amountColor,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTransactionAmountDialog extends StatelessWidget {
  final Transaction transaction;
  final void Function(Transaction)? onConfirm;
  final void Function()? onCancel;
  const EditTransactionAmountDialog(
    this.transaction, {
    super.key,
    this.onConfirm,
    this.onCancel,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Amount'),
      content: TextField(
        decoration: InputDecoration(
          labelText: 'Amount',
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(text: transaction.amount.toString()),
        keyboardType: TextInputType.number,
        onChanged: (value) => transaction.amount = int.tryParse(value) ?? 0,
      ),
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm?.call(transaction);
            Navigator.of(context).pop();
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}

// Additional UI Components
class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool? sortAscending;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.sortAscending,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? Colors.blue : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
            if (sortAscending != null) ...[
              SizedBox(width: 4),
              Icon(
                sortAscending! ? Icons.arrow_upward : Icons.arrow_downward,
                size: 12,
                color: isSelected ? Colors.blue : Colors.grey[700],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.money,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first transaction to get started',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          FilledButton(
            // style: FButtonStyle.primary(),
            onPressed: () => navigator.toDialog(NewTransactionDialog()),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 18),
                SizedBox(width: 8),
                Text('Add Transaction'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
