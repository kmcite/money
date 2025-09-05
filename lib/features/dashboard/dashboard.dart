import 'package:money/domain/models/person.dart';
import 'package:money/domain/models/transaction.dart';
import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/domain/repositories/transactions_repository.dart';
import 'package:money/main.dart';

class DashboardBloc extends Controller {
  /// SOURCES
  late final transactionsRepository = depend<TransactionsRepository>();
  late final personsRepository = depend<PersonsRepository>();

  /// GLOBAL STATE
  Iterable<Transaction> get transactions => transactionsRepository.getAll();
  int get allTransactions => transactions.fold(0, (i, v) => i + v.amount);
  int get transactionsToGive => transactions.fold(0, (i, v) => i + v.amount);
  int get transactionsToGet => transactions.fold(0, (i, v) => i + v.amount);

  int get count => personsRepository.length;

  Iterable<Person> get topThreePersons {
    return personsRepository.getAll().take(3);
  }
}

class DashboardPage extends UI<DashboardBloc> {
  const DashboardPage({super.key});

  @override
  DashboardBloc create() => DashboardBloc();

  @override
  Widget build(context, controller) {
    return FScaffold(
      childPad: false,
      header: FHeader(title: Text('DASHBOARD')),
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        children: [
          Column(
            spacing: 8,
            children: [
              Text('total'),
              Text('${controller.allTransactions}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('to give'),
                      Text('${controller.transactionsToGet}'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('to get'),
                      Text('${controller.transactionsToGive}'),
                    ],
                  ),
                ],
              ),
              Row(
                spacing: 8,
                children: [
                  FButton.icon(
                    style: FButtonStyle.primary(),
                    onPress: () {},
                    child: Icon(FIcons.group),
                  ),
                  FButton.icon(
                    style: FButtonStyle.primary(),
                    onPress: () {},
                    child: Icon(FIcons.dollarSign),
                  ),
                ],
              ),
              Text(
                'persons',
                style: TextStyle(fontSize: 32),
              ),
              if (controller.topThreePersons.isEmpty) Text('no persons'),
              for (final person in controller.topThreePersons)
                FTile(
                  title: Text(person.name),
                  subtitle: Text(person.amount.toString()),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.count.toString(),
                  style: TextStyle(fontSize: 48),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
