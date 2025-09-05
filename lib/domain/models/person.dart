import 'package:objectbox/objectbox.dart';

@Entity()
class Person {
  @Id()
  int? id;
  String name = '';
}
