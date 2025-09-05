import 'package:money/domain/models/person.dart';
import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/domain/models/transaction.dart';
import 'package:money/domain/repositories/transactions_repository.dart';
import 'package:money/main.dart';

class NewTransactionBloc extends Controller {
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

  // void setPersonId(int? id) {
  //   transaction.personId = id;
  //   // notifyListeners();
  // }
}

class NewTransactionDialog extends UI<NewTransactionBloc> {
  const NewTransactionDialog({super.key});
  @override
  NewTransactionBloc create() => NewTransactionBloc();

  @override
  Widget build(context, controller) {
    return FDialog(
      title: Text('New Transaction'),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FTextField(
            label: Text('Amount'),
            initialText: controller.transaction.amount.toString(),
            onChange: (value) {
              try {
                controller.transaction.amount = int.parse(value);
              } catch (e) {
                controller.transaction.amount = 0;
              }
            },
          ),
          FTextField(
            label: Text('Description'),
            initialText: controller.transaction.notes,
            onChange: (value) => controller.transaction.notes = value,
          ),
          controller.persons.isEmpty
              ? Text('No persons')
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(controller.persons.length, (index) {
                    final person = controller.persons.elementAt(index);
                    return FTappable(
                      child: FBadge(
                        style: controller.transaction.person.target?.id ==
                                person.id
                            ? FBadgeStyle.primary()
                            : FBadgeStyle.secondary(),
                        child: Text(person.name),
                      ),
                      onPress: () {
                        if (controller.transaction.person.target?.id ==
                            person.id) {
                          controller.transaction.person.target = null;
                        } else {
                          controller.transaction.person.target = person;
                        }
                      },
                    );
                  }),
                ),
        ],
      ),
      direction: Axis.horizontal,
      actions: [
        FButton(onPress: controller.save, child: Text('Save')),
        FButton(
          style: FButtonStyle.destructive(),
          onPress: controller.cancel,
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
