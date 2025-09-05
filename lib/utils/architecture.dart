import 'dart:developer';
import 'package:flutter/material.dart';

/// -----------------------------------------------------------
/// GLOBAL CONFIG
/// -----------------------------------------------------------
bool logging = true;

void logInfo(String message) {
  if (logging) log('$message', name: 'ARCH');
}

/// -----------------------------------------------------------
/// REGISTRIES
/// -----------------------------------------------------------
final repositories = <Type, Repository>{};
final services = <Type, dynamic>{};

/// REPOSITORY -> inject repositories
void repository<T extends Repository>(T instance) {
  repositories[T] = instance;
  logInfo('Registered Repository: $T');
  // return instance;
  // final repo = repositories[T];
  // if (repo == null) {
  //   throw Exception('No repository registered for type $T');
  // }
  // logInfo('Using Repository: $T');
  // return repo as T;
}

/// SERVEICE -> inject services
void service<T>(T any) {
  services[T] = any;
  logInfo('Registered Service: $T');
}

/// -----------------------------------------------------------
/// REPOSITORY
/// -----------------------------------------------------------
abstract class Repository<T> extends ChangeNotifier {
  S serve<S>() {
    return services[S] as S;
  }

  void disposeRepository() {
    logInfo('Disposed Repository: $runtimeType');
    dispose();
  }
}

/// -----------------------------------------------------------
/// CONTROLLER
/// -----------------------------------------------------------
abstract class Controller extends ChangeNotifier {
  final _disposers = <void Function()>[];
  bool disposed = false;
  bool initialized = false;

  void initState() {
    initialized = true;
    logInfo('Initialized Controller: $runtimeType');
  }

  /// watch repository
  T depend<T extends Repository>() {
    final instance = repositories[T];
    if (instance == null) {
      throw Exception('No repository registered for type $T');
    }
    final repo = instance as T;
    repo.addListener(notifyListeners);
    _disposers.add(() => repo.removeListener(notifyListeners));
    logInfo('$runtimeType depends on $T');
    return repo;
  }

  @override
  void dispose() {
    if (disposed) return;
    for (var action in _disposers) {
      action();
    }
    disposed = true;
    initialized = false;
    logInfo('Disposed Controller: $runtimeType');
    super.dispose();
  }
}

/// -----------------------------------------------------------
/// UI FEATURE
/// -----------------------------------------------------------
abstract class UI<T extends Controller> extends StatefulWidget {
  const UI({super.key});
  T create();
  Widget build(BuildContext context, T controller);

  @override
  State<StatefulWidget> createState() => _UIState<T>();
}

class _UIState<T extends Controller> extends State<UI<T>> {
  late final T controller = widget.create()
    ..initState()
    ..addListener(_listener);

  void _listener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, controller);
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }
}
