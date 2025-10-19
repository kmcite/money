import 'package:objectbox/objectbox.dart';

import 'person.dart';

@Entity()
class Transaction {
  @Id()
  int id = 0;
  int amount = 0;
  String notes = '';
  int createdAt = DateTime.now().millisecondsSinceEpoch;
  final person = ToOne<Person>();

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(createdAt);

  void set date(DateTime value) {
    createdAt = value.millisecondsSinceEpoch;
  }
}
