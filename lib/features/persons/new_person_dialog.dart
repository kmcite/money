import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/main.dart';
import 'package:money/utils/navigator.dart';

import '../../domain/models/person.dart';

class NewPersonBloc extends Bloc {
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

class NewPersonDialog extends Feature<NewPersonBloc> {
  const NewPersonDialog({super.key});

  @override
  NewPersonBloc create() => NewPersonBloc();

  @override
  Widget build(context, NewPersonBloc controller) {
    return AlertDialog(
      title: Text('Add New Person'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Person Name',
              border: OutlineInputBorder(),
            ),
            onChanged: controller.onNameChanged,
          ),
          if (controller.person?.name.isNotEmpty == true)
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ready to add "${controller.person?.name}"',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: controller.cancel,
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              controller.person?.name.isEmpty ?? true ? null : controller.save,
          child: Text('Add Person'),
        ),
      ],
    );
  }
}
