import 'package:flutter_native_splash/flutter_native_splash.dart';
export 'package:forui/forui.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money/domain/repositories/dark_repository.dart';
import 'package:money/domain/repositories/index_repository.dart';
import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/domain/repositories/transactions_repository.dart';
import 'package:money/features/dashboard/application_shell.dart';

import 'main.dart';
import 'objectbox.g.dart' hide Box;
export 'utils/navigator.dart';

export 'package:flutter/material.dart';

export 'package:money/utils/architecture.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  /// SERVICES

  // INJECTING STORAGE
  service<Store>(await openStore());

  // hive
  await Hive.initFlutter();
  // hive box
  service<Box>(await Hive.openBox('money'));

  /// REPOS
  repository(DarkRepository());
  repository(PersonsRepository());
  repository(TransactionsRepository());
  repository(IndexRepository());

  runApp(App());
}

class App extends UI<AppBloc> {
  const App({super.key});

  @override
  Widget build(context, controller) {
    return MaterialApp(
      navigatorKey: navigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: ApplicationShell(),
      themeMode: controller.dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return FTheme(
          data: controller.dark ? FThemes.yellow.dark : FThemes.yellow.light,
          child: child!,
        );
      },
    );
  }

  @override
  AppBloc create() => AppBloc();
}

class AppBloc extends Controller {
  late var darkRepository = depend<DarkRepository>();
  bool get dark => darkRepository.dark;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }
}
