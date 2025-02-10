// import 'package:money/main.dart';

// // @Entity()
// // class Transaction {
// //   @Id()
// //   int id = 0;
// //   final person = ToOne<Person>();
// //   int amount = 0;
// //   String notes = '';
// //   bool editing = false;
// //   DateTime created = DateTime.now();
// // }

// // final _transactions = box<Transaction>(store);
// // final transactionsRM = rm(_transactions);
// // final transactions = list(_transactions, transactionsRM);
// // final removeTransaction = (int id) => _transactions.remove(id);

// final transactionsRM = TransactionsRM();

// class TransactionsRM with CRUD<Transaction> {
//   late final rm = RM.injectStream(
//     watch,
//     initialState: <Transaction>[],
//   );
//   List<Transaction> call() => rm.state;
// }
