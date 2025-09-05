// import '../experiments.dart';
// import '../main.dart';

// final transactionRM = RM.inject<Transaction>(
//   () => throw UnimplementedError(),
//   sideEffects: SideEffects.onData(transactionsRM.put),
// );

// class TransactionPage extends UI {
//   const TransactionPage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     Transaction transaction([Transaction? _transaction]) {
//       if (_transaction != null) {
//         transactionRM(context)
//           ..state = _transaction
//           ..notify();
//         transactionsRM.put(_transaction);
//       }
//       return transactionRM.of(context);
//     }

//     String notes([_]) {
//       if (_ != null) transaction(transaction()..notes = _);
//       return transaction().notes;
//     }

//     int amount([_]) {
//       if (_ != null) transaction(transaction()..amount = _);
//       return transaction().amount;
//     }

//     bool editing([_]) {
//       if (_ != null) transaction(transaction()..editing = _);
//       return transaction().editing;
//     }

//     final person = transaction().person.target;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue.shade100,
//         elevation: 2,
//         title: person != null
//             ? Text(
//                 person.name,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: Colors.blue.shade900,
//                 ),
//               )
//             : GestureDetector(
//                 onTap: () {
//                   Person person([Person? p]) {
//                     if (p != null) personsRM.put(p);
//                     return transaction().person.target!;
//                   }

//                   navigator.to(
//                     PersonPage(person: person()),
//                   );
//                 },
//                 child: Icon(Icons.person),
//               ),
//         actions: [
//           Row(
//             children: [
//               Icon(editing() ? Icons.edit : Icons.edit_off,
//                   color: Colors.blue.shade900),
//               SizedBox(width: 8),
//               Switch(
//                 value: editing(),
//                 onChanged: editing,
//                 activeColor: Colors.blue.shade900,
//               ).pad(horizontal: 16),
//             ],
//           )
//         ],
//       ),
//       body: ListView(
//         shrinkWrap: true,
//         padding: EdgeInsets.all(16),
//         children: [
//           Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: materialColor().shade50,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.attach_money, size: 32, color: Colors.green),
//                     SizedBox(width: 8),
//                     Text(
//                       amount().toString(),
//                       style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green),
//                     ),
//                   ],
//                 ),
//                 editing()
//                     ? PopupMenuButton(
//                         tooltip: 'select person for this transaction',
//                         icon:
//                             Icon(Icons.person_add, color: Colors.blue.shade900),
//                         itemBuilder: (context) {
//                           return personsRM().map(
//                             (person) {
//                               return PopupMenuItem(
//                                 enabled: !(transaction().person.targetId ==
//                                     person.id),
//                                 onTap: () {},
//                                 value: person,
//                                 child: Text(
//                                   person.name,
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                               );
//                             },
//                           ).toList();
//                         },
//                       )
//                     : SizedBox(),
//               ],
//             ),
//           ),
//           SizedBox(height: 16),
//           editing()
//               ? Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: materialColor().shade50,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.edit_attributes,
//                               color: Colors.blue.shade900),
//                           SizedBox(width: 8),
//                           Text(
//                             'Amount Customizer',
//                             style: TextStyle(
//                                 fontSize: 24, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Customise amount with the following. Single tap will add to the amount and double tap will decrement the amount.',
//                         style: TextStyle(
//                             fontSize: 16, color: Colors.grey.shade700),
//                       ),
//                       SizedBox(height: 16),
//                       Container(
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.blue.shade50, Colors.white],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color:
//                                   Colors.blue.shade100.withValues(alpha: 0.5),
//                               blurRadius: 8,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Wrap(
//                           spacing: 10,
//                           runSpacing: 10,
//                           children: [
//                             _buildAmountButton(
//                               1,
//                               Icons.exposure_plus_1,
//                               Colors.indigo,
//                               transaction,
//                             ),
//                             _buildAmountButton(
//                               5,
//                               Icons.looks_5,
//                               Colors.blue,
//                               transaction,
//                             ),
//                             _buildAmountButton(
//                               10,
//                               Icons.looks_one,
//                               Colors.cyan,
//                               transaction,
//                             ),
//                             _buildAmountButton(
//                               50,
//                               Icons.format_list_numbered,
//                               Colors.teal,
//                               transaction,
//                             ),
//                             _buildAmountButton(
//                               100,
//                               Icons.money,
//                               Colors.green,
//                               transaction,
//                             ),
//                             _buildAmountButton(
//                               500,
//                               Icons.attach_money,
//                               Colors.lightGreen,
//                               transaction,
//                             ),
//                             _buildAmountButton(
//                               1000,
//                               Icons.monetization_on,
//                               Colors.lime,
//                               transaction,
//                             ),
//                             _buildAmountButton(
//                               5000,
//                               Icons.currency_rupee,
//                               Colors.amber,
//                               transaction,
//                             ),
//                             _buildAmountButton(
//                               10000,
//                               Icons.account_balance,
//                               Colors.orange,
//                               transaction,
//                             ),
//                             _buildAmountButton(
//                               50000,
//                               Icons.savings,
//                               Colors.deepOrange,
//                               transaction,
//                             ),
//                             _buildAmountButton(
//                               100000,
//                               Icons.diamond,
//                               Colors.purple,
//                               transaction,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : SizedBox(),
//           SizedBox(height: 16),
//           Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: materialColor().shade50,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, color: Colors.blue.shade900),
//                     SizedBox(width: 8),
//                     Text(
//                       'Date Created',
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 DateTimeUI(
//                   dateTime: ([d]) => transaction().created,
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16),
//           Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.note, color: Colors.blue.shade900),
//                     SizedBox(width: 8),
//                     Text(
//                       'Notes',
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 transaction().editing
//                     ? TextFormField(
//                         initialValue: notes(),
//                         onChanged: notes,
//                         decoration: InputDecoration(
//                           filled: true,
//                           // fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide(
//                               color: materialColor().shade50,
//                             ),
//                           ),
//                         ),
//                       )
//                     : Text(
//                         notes(),
//                         style: TextStyle(fontSize: 16),
//                       ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAmountButton(
//     int value,
//     IconData icon,
//     MaterialColor color,
//     Transaction transaction([Transaction? _transaction]),
//   ) {
//     int amount([_]) {
//       if (_ != null) transaction(transaction()..amount = _);
//       return transaction().amount;
//     }

//     bool editing([_]) {
//       if (_ != null) transaction(transaction()..editing = _);
//       return transaction().editing;
//     }

//     return InkWell(
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: color.shade50,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: color.shade200),
//           boxShadow: [
//             BoxShadow(
//               color: color.shade100.withValues(alpha: .4),
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 18, color: color.shade700),
//             SizedBox(width: 6),
//             Text(
//               value.toString(),
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: color.shade700,
//               ),
//             ),
//           ],
//         ),
//       ),
//       onTap: editing() ? () => amount(amount() + value) : null,
//       onDoubleTap: editing() ? () => amount(amount() - value) : null,
//     );
//   }
// }
