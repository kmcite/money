import 'package:money/main.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void navigateTo(Widget page) {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => page),
  );
}

void navigateUntill(Widget page) {
  navigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  );
}

void navigateBack() {
  navigatorKey.currentState?.pop();
}

void navigateToDialog(Widget page) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    throw Exception('Navigator key is not initialized');
  } else {
    showDialog(
      context: context,
      builder: (context) => page,
    );
  }
}
