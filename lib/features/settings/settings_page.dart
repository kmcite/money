import 'package:money/domain/repositories/dark_repository.dart';
import 'package:money/main.dart';

class SettingsBloc extends Controller {
  late final darkRepository = depend<DarkRepository>();
  bool get dark => darkRepository.dark;
  void toggleDark() {
    darkRepository.setDark(!dark);
  }
}

class SettingsPage extends UI<SettingsBloc> {
  @override
  SettingsBloc create() => SettingsBloc();

  const SettingsPage({super.key});

  @override
  Widget build(context, controller) {
    return FScaffold(
      header: FHeader(
        title: Text('SETTINGS'),
      ),
      child: ListView(
        children: [
          FButton(
            onPress: controller.toggleDark,
            child: Text(controller.dark ? 'DARK' : 'LIGHT'),
          ),
        ],
      ),
    );
  }
}
