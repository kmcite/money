import 'package:money/domain/models/person.dart';
import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/domain/models/transaction.dart';
import 'package:money/domain/repositories/transactions_repository.dart';
import 'package:money/main.dart';
import 'package:money/utils/navigator.dart';

class NewTransactionBloc extends Bloc {
  /// SOURCES
  late final transactionsRepository = depend<TransactionsRepository>();
  late final personsRepository = depend<PersonsRepository>();

  /// GLOBAL STATE
  Iterable<Person> get persons => personsRepository.getAll();

  /// LOCAL STATE
  Transaction? _transaction;
  Transaction get transaction => _transaction!;

  @override
  void initState() {
    super.initState();
    _transaction = Transaction();
  }

  void save() {
    if (_transaction != null) transactionsRepository.put(_transaction!);
    navigator.back();
  }

  void cancel() {
    _transaction = null;
    navigator.back();
  }

  void onPersonTapped(Person person) {
    if (transaction.person.target?.id != person.id) {
      _transaction?.person.target = person;
    } else {
      _transaction?.person.target = null;
    }
    notifyListeners();
  }
}

class NewTransactionDialog extends Feature<NewTransactionBloc> {
  const NewTransactionDialog({super.key});
  @override
  NewTransactionBloc create() => NewTransactionBloc();

  @override
  Widget build(context, controller) {
    return AlertDialog(
      title: Text('New Transaction'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                try {
                  controller.transaction.amount = int.parse(value);
                } catch (e) {
                  controller.transaction.amount = 0;
                }
              },
            ),
            SizedBox(height: 16),

            // Description Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.transaction.notes = value,
            ),
            SizedBox(height: 16),

            // Person Selection
            if (controller.persons.isEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No people available. Add people first to create transactions.',
                        style: TextStyle(color: Colors.orange[700]),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              Text(
                'Select Person',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Container(
                constraints: BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      controller.persons.length,
                      (index) {
                        final person = controller.persons.elementAt(index);
                        final isSelected =
                            controller.transaction.person.target?.id ==
                                person.id;

                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                              SizedBox(width: 6),
                              Text(person.name),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (_) => controller.onPersonTapped(person),
                          backgroundColor: Colors.grey.withOpacity(0.1),
                          selectedColor: Colors.blue,
                          checkmarkColor: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: controller.cancel,
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: controller.save,
          child: Text('Save'),
        ),
      ],
    );
  }
}
