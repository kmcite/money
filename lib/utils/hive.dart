import 'package:hive_flutter/hive_flutter.dart';
import 'package:money/main.dart';

mixin Hive<T> on Repository<T> {
  late final box = serve<Box>();
}
