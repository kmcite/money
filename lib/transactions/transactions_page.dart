// import '../main.dart';

// class TransactionsPage extends UI {
//   const TransactionsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: 'Transactions'.text(
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: ListView.separated(
//         itemCount: transactionsRM().length,
//         separatorBuilder: (context, index) => Divider(height: 1),
//         itemBuilder: (context, index) {
//           Transaction transaction([Transaction? transaction]) {
//             if (transaction != null) transactionsRM.put(transaction);
//             return transactionsRM().elementAt(index);
//           }

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     child: Icon(
//                       Icons.person,
//                       size: 32,
//                     ),
//                   ).pad(),
//                   "${transaction().person.target?.name ?? 'Orphan transaction'}"
//                       .text(
//                         style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )
//                       .pad(),
//                 ],
//               ),
//               transaction()
//                   .amount
//                   .text(
//                     textScaleFactor: 2,
//                     style: TextStyle(
//                       color:
//                           transaction().amount >= 0 ? Colors.green : Colors.red,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   )
//                   .pad(),
//               Row(
//                 children: [
//                   PopupMenuButton<Person>(
//                     icon: Icon(Icons.person_add),
//                     tooltip: 'Select person',
//                     itemBuilder: (context) => personsRM()
//                         .map(
//                           (person) => PopupMenuItem<Person>(
//                             value: person,
//                             child: Row(
//                               children: [
//                                 Icon(Icons.person_outline, size: 18),
//                                 SizedBox(width: 8),
//                                 person.name.text(),
//                               ],
//                             ),
//                           ),
//                         )
//                         .toList(),
//                     onSelected: (person) => transactionsRM
//                         .put(transaction()..person.target = person),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       transactionsRM.put(
//                           transaction()..amount = transaction().amount + 500);
//                     },
//                     icon: Icon(Icons.add),
//                     tooltip: 'Add 500',
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       transactionsRM.put(
//                           transaction()..amount = transaction().amount - 500);
//                     },
//                     icon: Icon(Icons.remove),
//                     tooltip: 'Subtract 500',
//                   ),
//                   IconButton(
//                     onPressed: () => navigator.to(
//                       transactionRM.inherited(
//                         builder: (_) => TransactionPage(),
//                         stateOverride: () => transaction(),
//                       ),
//                     ),
//                     icon: Icon(Icons.edit),
//                     tooltip: 'Edit transaction',
//                   ),
//                   IconButton(
//                     onPressed: () => transactionsRM.remove(transaction().id),
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     tooltip: 'Delete transaction',
//                   ),
//                 ],
//               ).pad(),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           transactionsRM.put(
//             Transaction(),
//           );
//         },
//         icon: Icon(Icons.add),
//         label: 'Add Transaction'.text(),
//       ),
//     );
//   }
// }

// class AddTransactionPage extends UI {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: 'Add Transaction'.text(),
//         actions: [
//           IconButton(
//             onPressed: () {
//               navigator.to(TransactionsPage());
//             },
//             icon: Icon(Icons.transcribe),
//           ).pad(),
//         ],
//       ),
//       body: Column(
//         children: [
//           TextFormField().pad(),
//         ],
//       ),
//     );
//   }
// }
