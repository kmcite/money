import 'package:objectbox/objectbox.dart';

import 'person.dart';

@Entity()
class Transaction {
  @Id()
  int id = 0;
  int amount = 0;
  String notes = '';
  final person = ToOne<Person>();
}
