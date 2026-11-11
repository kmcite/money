import 'package:get/get.dart';

class DarkController extends GetxController {
  final isDark = true.obs;

  void toggle() {
    isDark.value = !isDark.value;
  }
}
