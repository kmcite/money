import 'package:intl/intl.dart';
import 'package:money/experiments.dart';

import '../main.dart';

class PersonPage extends UI {
  final Person person;

  PersonPage({super.key, required this.person});
  @override
  Widget build(BuildContext context) {
    update([Person? _person]) {
      if (_person != null)
        appDatabase.into(appDatabase.persons).insert(_person);

      return Person(id: 0, name: '', editing: true, created: DateTime(2003));
    }

    String name([String? _]) {
      // if (_ != null) update(update()..name = _);
      return update().name;
    }

    bool editing([bool? _]) {
      // if (_ != null) update(update()..editing = _);
      return update().editing;
    }

    DateTime created([DateTime? _]) {
      // if (_ != null) update(update()..created = _);
      return update().created;
    }

    return Scaffold(
      appBar: AppBar(
        title: name().text(),
        actions: [
          IconButton(
            icon: Icon(editing() ? Icons.check : Icons.edit),
            onPressed: () => editing(!editing()),
          ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: editing()
                  ? TextFormField(
                      initialValue: name(),
                      onChanged: name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: InputBorder.none,
                      ),
                    )
                  : Text(name(),
                      style: Theme.of(context).textTheme.headlineSmall),
              subtitle: Text(
                  'Created on: ${DateFormat('MMM dd, yyyy').format(created())}'),
            ),
          ).pad(),
          IconButton.filled(
            onPressed: () {
              appDatabase.deletePerson(person.id);
              navigator.back();
            },
            icon: Icon(Icons.delete),
            tooltip: 'Delete person',
          ).pad(),
          // if (update().transactions.isNotEmpty)
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Transactions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                // ...update().transactions.map(TransactionInPerson.new),
              ],
            ),
          ).pad()
          // else
          //   Center(
          //     child: Text(
          //       'No transactions yet',
          //       style: Theme.of(context).textTheme.bodyLarge,
          //     ),
          //   ).pad(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigator.toDialog(_AddNewTransactionDialog(update()));
        },
        label: 'add new transaction'.text(),
      ),
    );
  }
}

class _AddNewTransactionDialog extends UI {
  static final amountRM = RM.inject(() => '');
  final Person person;
  _AddNewTransactionDialog(this.person, {super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          'add new transaction'.text().pad(),
          TextFormField(
            initialValue: amountRM.state,
            onChanged: (value) => amountRM.state = value,
          ).pad(),
          FilledButton(
            onPressed: () {
              final amount = int.tryParse(amountRM.state);
              if (amount != null) {
                // final transaction = Transaction()..amount = amount;
                // personsRM.put(
                //   person..transactions.add(transaction),
                // );
              }
            },
            child: 'save'.text(),
          )
        ],
      ),
    );
  }
}
