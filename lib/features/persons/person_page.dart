import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/domain/models/transaction.dart';
import 'package:money/domain/repositories/transactions_repository.dart';
import 'package:money/utils/date_formatter.dart';

import '../../domain/models/person.dart';
import '../../main.dart';
import 'package:money/utils/navigator.dart';

class PersonBloc extends Bloc {
  PersonBloc(this.person);

  /// LOCAL STATE
  Person person;
  String amount = '0';

  /// REPOSITORIES
  late final transactionsRepository = depend<TransactionsRepository>();
  late final personsRepository = depend<PersonsRepository>();

  /// GLOBAL STATE
  Iterable<Person> get persons => personsRepository.getAll();
  Iterable<Transaction> get personTransactions {
    return transactionsRepository.getAll().where((tr) {
      return tr.person.target?.id == person.id;
    });
  }

  void remove(Person id) {
    personsRepository.remove(id);
    navigator.back();
  }

  /// changes name fully
  void onNameChanged(String value) {
    person.name = value;
    personsRepository.put(person);
  }
}

class PersonPage extends Feature<PersonBloc> {
  final Person person;
  const PersonPage({super.key, required this.person});

  @override
  PersonBloc create() => PersonBloc(person);

  @override
  Widget build(context, controller) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.person.name),
        actions: [
          IconButton(
            onPressed: () {
              controller.remove(controller.person);
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Person Name Display
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Icon(Icons.person, color: Colors.blue),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        controller.person.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Edit Name Section
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Name',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Change name here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.edit),
                      ),
                      controller:
                          TextEditingController(text: controller.person.name),
                      onChanged: controller.onNameChanged,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Transactions Section
            Expanded(
              child: controller.personTransactions.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transactions',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.personTransactions.length,
                            itemBuilder: (context, index) {
                              return TransactionInPerson(
                                transaction: controller.personTransactions
                                    .elementAt(index),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No transactions yet',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Transactions with this person will appear here',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionInPerson extends StatelessWidget {
  const TransactionInPerson({super.key, required this.transaction});
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount > 0;
    final amountColor = isPositive ? Colors.green : Colors.red;

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          transaction.notes.isNotEmpty ? transaction.notes : 'Transaction',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormatter.formatRelative(transaction.date),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Text(
          '${isPositive ? '+' : ''}\$${transaction.amount.abs().toString()}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: amountColor,
            fontSize: 16,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.1),
          child: Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: amountColor,
            size: 16,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
