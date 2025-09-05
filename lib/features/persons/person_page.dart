import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/domain/models/transaction.dart';
import 'package:money/domain/repositories/transactions_repository.dart';

import '../../domain/models/person.dart';
import '../../main.dart';

class PersonBloc extends Controller {
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

class PersonPage extends UI<PersonBloc> {
  final Person person;
  const PersonPage({super.key, required this.person});

  @override
  PersonBloc create() => PersonBloc(person);

  @override
  Widget build(context, controller) {
    return FScaffold(
      header: FHeader(
        title: Text(controller.person.name),
        suffixes: [
          FHeaderAction(
            onPress: navigator.back,
            icon: Text('BACK'),
          ),
          FHeaderAction(
            onPress: () {
              controller.remove(controller.person);
            },
            icon: Icon(
              FIcons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      child: Column(
        spacing: 8,
        children: [
          FTile(
            title: Text(
              controller.person.name,
              style: FTheme.of(context).typography.xl4,
            ),
          ),
          FTextField(
            label: Text('Change name here'),
            initialText: controller.person.name,
            onChange: controller.onNameChanged,
          ),
          if (controller.personTransactions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: controller.personTransactions.length,
                itemBuilder: (context, index) {
                  return TransactionInPerson(
                    transaction: controller.personTransactions.elementAt(index),
                  );
                },
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No transactions yet',
              ),
            ),
        ],
      ),
    );
  }
}

class TransactionInPerson extends StatelessWidget {
  const TransactionInPerson({super.key, required this.transaction});
  final Transaction transaction;
  @override
  Widget build(BuildContext context) {
    return FTile(
      title: Text(transaction.notes, style: context.theme.typography.xs),
    );
  }
}
