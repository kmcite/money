import 'package:objectbox/objectbox.dart';

@Entity()
class Expense {
  @Id()
  int id = 0;
  int money = 0;

  String note = '';

  @Property(type: PropertyType.date)
  DateTime date = DateTime.now();

  @Property()
  int schemaVersion = 1; // Track which schema version created this record
}

// Date helpers
extension ExpenseDateExtension on Expense {
  int get day => date.day;
  int get month => date.month;
  int get year => date.year;
}
