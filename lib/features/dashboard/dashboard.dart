import 'package:money/domain/models/person.dart';
import 'package:money/domain/models/transaction.dart';
import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/domain/repositories/transactions_repository.dart';
import 'package:money/features/persons/persons_page.dart';
import 'package:money/features/transactions/transactions_page.dart';
import 'package:money/features/persons/person_page.dart';
import 'package:money/utils/date_formatter.dart';
import 'package:money/main.dart';
import 'package:money/utils/navigator.dart';

class DashboardBloc extends Bloc {
  /// SOURCES
  late final transactionsRepository = depend<TransactionsRepository>();
  late final personsRepository = depend<PersonsRepository>();

  /// GLOBAL STATE
  Iterable<Transaction> get transactions => transactionsRepository.getAll();

  // Calculate total balance (positive = money to receive, negative = money to give)
  int get totalBalance =>
      transactions.fold(0, (sum, transaction) => sum + transaction.amount);

  // Money you need to give (negative amounts)
  int get moneyToGive => transactions
      .where((t) => t.amount < 0)
      .fold(0, (sum, t) => sum + t.amount.abs());

  // Money you need to receive (positive amounts)
  int get moneyToReceive => transactions
      .where((t) => t.amount > 0)
      .fold(0, (sum, t) => sum + t.amount);

  int get personCount => personsRepository.length;
  int get transactionCount => transactions.length;

  // Get top persons by transaction count
  List<Person> get topPersons {
    final personTransactionCounts = <Person, int>{};

    for (final transaction in transactions) {
      final person = transaction.person.target;
      if (person != null) {
        personTransactionCounts[person] =
            (personTransactionCounts[person] ?? 0) + 1;
      }
    }

    final sortedPersons = personTransactionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedPersons.take(3).map((e) => e.key).toList();
  }

  // Get recent transactions
  List<Transaction> get recentTransactions {
    final sortedTransactions = transactions.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedTransactions.take(5).toList();
  }
}

class DashboardPage extends Feature<DashboardBloc> {
  const DashboardPage({super.key});

  @override
  DashboardBloc create() => DashboardBloc();

  @override
  Widget build(context, controller) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh logic can be added here if needed
        },
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(16),
          children: [
            // Balance Overview Card
            _BalanceCard(
              totalBalance: controller.totalBalance,
              moneyToGive: controller.moneyToGive,
              moneyToReceive: controller.moneyToReceive,
            ),

            SizedBox(height: 24),

            // Quick Actions
            _QuickActionsCard(),

            SizedBox(height: 24),

            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'People',
                    value: controller.personCount.toString(),
                    icon: Icons.group,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Transactions',
                    value: controller.transactionCount.toString(),
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Top People Section
            if (controller.topPersons.isNotEmpty) ...[
              _SectionHeader(title: 'Most Active People'),
              SizedBox(height: 12),
              ...controller.topPersons
                  .map((person) => _PersonCard(person: person)),
              SizedBox(height: 24),
            ],

            // Recent Transactions Section
            if (controller.recentTransactions.isNotEmpty) ...[
              _SectionHeader(title: 'Recent Transactions'),
              SizedBox(height: 12),
              ...controller.recentTransactions.map(
                  (transaction) => _TransactionCard(transaction: transaction)),
            ],
          ],
        ),
      ),
    );
  }
}

// Custom UI Components for Dashboard
class _BalanceCard extends StatelessWidget {
  final int totalBalance;
  final int moneyToGive;
  final int moneyToReceive;

  const _BalanceCard({
    required this.totalBalance,
    required this.moneyToGive,
    required this.moneyToReceive,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = totalBalance >= 0;
    final balanceColor = isPositive ? Colors.green : Colors.red;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            balanceColor.withValues(alpha: 0.1),
            balanceColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: balanceColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${isPositive ? '+' : ''}\$${totalBalance.abs().toString()}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: balanceColor,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _BalanceItem(
                  label: 'To Receive',
                  amount: moneyToReceive,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _BalanceItem(
                  label: 'To Give',
                  amount: moneyToGive,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  final String label;
  final int amount;
  final Color color;

  const _BalanceItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          '\$${amount.toString()}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => navigator.to(PersonsPage()),
                    icon: Icon(Icons.group, size: 18),
                    label: Text('Add Person'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => navigator.to(TransactionsPage()),
                    icon: Icon(Icons.attach_money, size: 18),
                    label: Text('Add Transaction'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  final Person person;

  const _PersonCard({required this.person});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          person.name,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('Active person'),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () => navigator.to(PersonPage(person: person)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _TransactionCard({required this.transaction});

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
              transaction.person.target?.name ?? 'Unknown person',
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
