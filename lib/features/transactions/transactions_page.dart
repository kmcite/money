import 'package:money/domain/repositories/transactions_repository.dart';
import 'package:money/features/transactions/add_transaction_dialog.dart';
import 'package:money/main.dart';
import 'package:money/domain/models/transaction.dart';

class TransactionsBloc extends Controller {
  late final TransactionsRepository transactionsRepository = depend();

  Iterable<Transaction> get transactions => transactionsRepository.getAll();

  void put(Transaction transaction) {
    transactionsRepository.put(transaction);
  }

  void remove(Transaction transaction) {
    transactionsRepository.remove(transaction);
  }

  String searchQuery = '';
  Iterable<Transaction> get filteredTransactions {
    return transactions.where(
      (transaction) {
        return transaction.notes.contains(searchQuery) ||
            transaction.amount.toString().contains(searchQuery);
      },
    );
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    // notifyListeners();
  }

  void onUpdated(Transaction transaction) => put(transaction);
}

class TransactionsPage extends UI<TransactionsBloc> {
  @override
  TransactionsBloc create() => TransactionsBloc();
  const TransactionsPage({super.key});

  @override
  Widget build(context, controller) {
    return FScaffold(
      header: _buildHeader(controller),
      child: Column(
        children: [
          _buildSearchField(controller),
          Expanded(child: _buildTransactionsList(controller)),
        ],
      ),
    );
  }

  Widget _buildHeader(TransactionsBloc controller) {
    return FHeader(
      title: Text('TRANSACTIONS'),
      suffixes: [
        FHeaderAction(
          onPress: () => navigator.toDialog(NewTransactionDialog()),
          icon: Icon(FIcons.plus),
        ),
      ],
    );
  }

  Widget _buildSearchField(TransactionsBloc controller) {
    return FTextField(
      label: Text('Search'),
      initialText: controller.searchQuery,
      onChange: controller.setSearchQuery,
    );
  }

  Widget _buildTransactionsList(TransactionsBloc controller) {
    return ListView.separated(
      itemCount: controller.filteredTransactions.length,
      separatorBuilder: (_, __) => FDivider(),
      itemBuilder: (context, index) {
        final transaction = controller.filteredTransactions.elementAt(index);
        return _TransactionItem(
          transaction,
          onUpdated: controller.onUpdated,
          onDeleted: controller.remove,
        );
      },
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final void Function(Transaction) onUpdated;
  final void Function(Transaction) onDeleted;

  const _TransactionItem(
    this.transaction, {
    required this.onUpdated,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return FTile(
      title: Text(transaction.amount.toString()),
      subtitle: Text(transaction.notes),
      suffix: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FButton.icon(
            child: Icon(FIcons.check),
            onPress: () => navigator.toDialog(
              EditTransactionAmountDialog(
                transaction,
                onConfirm: onUpdated,
                onCancel: () => navigator.back(),
              ),
            ),
          ),
          SizedBox(width: 8),
          FButton.icon(
            style: FButtonStyle.destructive(),
            onPress: () => onDeleted(transaction),
            child: Icon(FIcons.delete),
          ),
        ],
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
    return FDialog(
      title: Text('Edit Amount'),
      body: FTextField(
        label: Text('Amount'),
        initialText: transaction.amount.toString(),
        onChange: (value) => transaction.amount = int.parse(value),
        keyboardType: TextInputType.number,
      ),
      direction: Axis.horizontal,
      actions: [
        FButton(
          onPress: () {
            onConfirm?.call(transaction);
            // navigator.back();
          },
          child: Text('Confirm'),
        ),
        FButton(
          onPress: () {
            onCancel?.call();
            // navigator.back();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
