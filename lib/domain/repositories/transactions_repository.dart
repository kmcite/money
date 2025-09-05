import 'package:money/main.dart';
import 'package:money/utils/crud.dart';
import 'package:money/domain/models/transaction.dart';

class TransactionsRepository extends Repository<Transaction>
    with CRUD<Transaction> {}
