import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/main.dart';

import '../../domain/models/person.dart';

class NewPersonBloc extends Controller {
  /// SOURCES
  late final personsRepository = depend<PersonsRepository>();

  /// LOCAL STATE
  Person? person;

  @override
  void initState() {
    super.initState();
    person = Person();
  }

  /// MUTATIONS
  void save() {
    if (person != null) personsRepository.put(person!);
    cancel();
  }

  void cancel() {
    navigator.back();
    person = null;
  }

  void onNameChanged(String value) {
    person?.name = value;
    notifyListeners();
  }
}

class NewPersonDialog extends UI<NewPersonBloc> {
  const NewPersonDialog({super.key});

  @override
  NewPersonBloc create() => NewPersonBloc();

  @override
  Widget build(context, NewPersonBloc controller) {
    return FDialog(
      title: Text('New Person'),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FTextField(
            label: Text('Name'),
            initialText: controller.person?.name,
            onChange: controller.onNameChanged,
          ),
          // .pad(),
        ],
      ),
      direction: Axis.horizontal,
      actions: [
        FButton(
          onPress:
              controller.person?.name.isEmpty ?? true ? null : controller.save,
          child: Text('Save'),
        ),
        FButton(
          style: FButtonStyle.destructive(),
          onPress: controller.cancel,
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
