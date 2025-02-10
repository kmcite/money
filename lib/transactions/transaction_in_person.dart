import 'package:money/main.dart';

import '../experiments.dart';

class TransactionInPerson extends UI {
  final Transaction transaction;
  TransactionInPerson(this.transaction);
  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: transaction.amount.text(),
    ).pad();
  }
}
