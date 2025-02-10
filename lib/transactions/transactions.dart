// import 'transaction.dart';

// int get transactionsAll {
//   return transactionsRM().fold(
//     0,
//     (previousValue, transaction) {
//       if (transaction.amount < 0) {
//         return previousValue - transaction.amount;
//       } else {
//         return previousValue + transaction.amount;
//       }
//     },
//   );
// }

// int get transactionsToGet {
//   return transactionsRM().where(
//     (transaction) {
//       return transaction.amount > 0;
//     },
//   ).fold(
//     0,
//     (previousValue, transaction) {
//       return previousValue + transaction.amount;
//     },
//   );
// }

// int get transactionsToGive {
//   return transactionsRM().where(
//     (transaction) {
//       return transaction.amount < 0;
//     },
//   ).fold(
//     0,
//     (previousValue, transaction) {
//       return previousValue + transaction.amount;
//     },
//   );
// }
