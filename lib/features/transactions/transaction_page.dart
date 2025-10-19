import 'package:money/domain/models/transaction.dart';
import 'package:money/domain/models/person.dart';
import 'package:money/domain/repositories/transactions_repository.dart';
import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/utils/date_formatter.dart';
import 'package:money/main.dart';
import 'package:money/utils/navigator.dart';

class TransactionBloc extends Bloc {
  TransactionBloc(this.transaction);

  /// LOCAL STATE
  Transaction transaction;
  bool isEditing = false;

  /// REPOSITORIES
  late final transactionsRepository = depend<TransactionsRepository>();
  late final personsRepository = depend<PersonsRepository>();

  /// GLOBAL STATE
  Iterable<Person> get persons => personsRepository.getAll();
  Person? get selectedPerson => transaction.person.target;

  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  void updateAmount(int amount) {
    transaction.amount = amount;
    transactionsRepository.put(transaction);
    notifyListeners();
  }

  void updateNotes(String notes) {
    transaction.notes = notes;
    transactionsRepository.put(transaction);
    notifyListeners();
  }

  void selectPerson(Person person) {
    transaction.person.target = person;
    transactionsRepository.put(transaction);
    notifyListeners();
  }

  void removeTransaction() {
    transactionsRepository.remove(transaction);
    navigator.back();
  }
}

class TransactionPage extends Feature<TransactionBloc> {
  final Transaction transaction;
  const TransactionPage({super.key, required this.transaction});

  @override
  TransactionBloc create() => TransactionBloc(transaction);

  @override
  Widget build(BuildContext context, controller) {
    final isPositive = controller.transaction.amount > 0;
    final amountColor = isPositive ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.selectedPerson?.name ?? 'Transaction'),
        actions: [
          IconButton(
            onPressed: controller.toggleEditing,
            icon: Icon(
              controller.isEditing ? Icons.edit_off : Icons.edit,
            ),
          ),
          IconButton(
            onPressed: controller.removeTransaction,
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Amount Display
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 32,
                            color: amountColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            controller.transaction.amount.toString(),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: amountColor,
                            ),
                          ),
                        ],
                      ),
                      if (controller.isEditing)
                        PopupMenuButton<Person>(
                          icon: Icon(Icons.person_add),
                          tooltip: 'Select person for this transaction',
                          itemBuilder: (context) {
                            return controller.persons.map((person) {
                              return PopupMenuItem<Person>(
                                value: person,
                                child: Text(person.name),
                              );
                            }).toList();
                          },
                          onSelected: controller.selectPerson,
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    isPositive ? 'Money to receive' : 'Money to give',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Quick Amount Buttons (when editing)
          if (controller.isEditing) ...[
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.edit_attributes, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Quick Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildAmountButton(1, Icons.exposure_plus_1,
                            Colors.indigo, controller),
                        _buildAmountButton(
                            5, Icons.looks_5, Colors.blue, controller),
                        _buildAmountButton(
                            10, Icons.looks_one, Colors.cyan, controller),
                        _buildAmountButton(50, Icons.format_list_numbered,
                            Colors.teal, controller),
                        _buildAmountButton(
                            100, Icons.money, Colors.green, controller),
                        _buildAmountButton(500, Icons.attach_money,
                            Colors.lightGreen, controller),
                        _buildAmountButton(1000, Icons.monetization_on,
                            Colors.lime, controller),
                        _buildAmountButton(5000, Icons.currency_rupee,
                            Colors.amber, controller),
                        _buildAmountButton(10000, Icons.account_balance,
                            Colors.orange, controller),
                        _buildAmountButton(50000, Icons.savings,
                            Colors.deepOrange, controller),
                        _buildAmountButton(
                            100000, Icons.diamond, Colors.purple, controller),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],

          // Date Information
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Date Created',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormatter.formatRelative(controller.transaction.date),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Notes Section
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.note, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Notes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  controller.isEditing
                      ? TextField(
                          decoration: InputDecoration(
                            hintText: 'Add notes...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          controller: TextEditingController(
                              text: controller.transaction.notes),
                          onChanged: controller.updateNotes,
                          maxLines: 3,
                        )
                      : Text(
                          controller.transaction.notes.isNotEmpty
                              ? controller.transaction.notes
                              : 'No notes',
                          style: TextStyle(fontSize: 16),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountButton(
      int value, IconData icon, Color color, TransactionBloc controller) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: controller.isEditing
          ? () => controller.updateAmount(controller.transaction.amount + value)
          : null,
      onDoubleTap: controller.isEditing
          ? () => controller.updateAmount(controller.transaction.amount - value)
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            SizedBox(width: 4),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
