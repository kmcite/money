import 'package:money/db/hive.dart';
import 'package:signals/signals.dart';

const darkLabel = 'dark';

// Signal first, but with uninitialized state
final _darkInitialized = signal(false);
final darkSignal = signal(false);

void darkToggled() => darkSignal.value = !darkSignal.value;

// Initialize from Hive, then set up sync effect
Future<void> ensureDark() async {
  // Read from Hive first
  final savedValue = await hiveStore.read<bool>(darkLabel);
  darkSignal.value = savedValue ?? false;
  _darkInitialized.value = true;

  // Now set up the effect to sync changes TO Hive
  effect(() {
    final value = darkSignal.value;
    // Only write after we've loaded from Hive (prevent overwrite on startup)
    if (_darkInitialized.value) {
      hiveStore.write(darkLabel, value);
    }
  });
}
