export 'package:flutter/material.dart' hide RefreshCallback;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:money/settings/dark.dart';
import 'package:money/db/objects.dart';
import 'package:money/dashboard/application_shell.dart';
import 'package:money/db/hive.dart';
export 'package:signals/signals.dart';
export 'package:money/utils/ui.dart';
export 'package:money/navigation/navigator.dart';
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsBinding.instance,
  );
  SignalsObserver.instance = null;
  await hiveStore.ensureReady();
  await objects.ensureReady();
  await ensureDark();

  runApp(MoneyApp());
}

class MoneyApp extends UI {
  const MoneyApp({super.key});

  @override
  void init(BuildContext context) {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: darkSignal() ? ThemeMode.dark : ThemeMode.light,
      home: ApplicationShell(),
    );
  }
}
