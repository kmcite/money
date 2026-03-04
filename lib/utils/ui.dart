import 'package:flutter/material.dart';
import 'package:signals/signals_core.dart' as core;
import 'package:signals/signals_flutter.dart';

abstract class UI<T extends Widget> extends StatefulWidget {
  const UI({super.key});

  T build(BuildContext context);

  /// Optional debug label to use for devtools
  String? get debugLabel => null;

  @override
  State<UI<T>> createState() => _UI<T>();

  void init(BuildContext context) {}
  void dispose() {}
}

class _UI<T extends Widget> extends State<UI<T>> with SignalsMixin {
  late final result = createComputed(
    () {
      return widget.build(context);
    },
    debugLabel: widget.debugLabel,
  );
  bool _init = true;

  @override
  void initState() {
    super.initState();
    // for (final dep in widget.dependencies) {
    //   bindSignal(dep);
    // }
  }

  @override
  void reassemble() {
    super.reassemble();
    final target = core.SignalsObserver.instance;
    if (target is core.DevToolsSignalsObserver) {
      target.reassemble();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      result.recompute();
      if (mounted) setState(() {});
      result.value;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      // Called on first build (we do not need to rebuild yet)
      _init = false;
      widget.init(context);
      return;
    }
    result.recompute();
  }

  @override
  void didUpdateWidget(covariant UI<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.build != widget.build) {
      result.recompute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return result.value;
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }
}

Computed<List<T>> streamComputed<T>(
  Stream<List<T>> Function() stream,
) {
  final streaming = streamSignal(stream);
  return computed(() {
    return streaming().map(
      data: (data) => data,
      error: (error) => <T>[],
      loading: () => <T>[],
    );
  });
}
