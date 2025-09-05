import 'package:money/domain/models/person.dart';
import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/features/persons/new_person_dialog.dart';
import 'package:money/features/persons/person_page.dart';
import 'package:money/main.dart';

class PersonsBloc extends Controller {
  late final personsRepository = depend<PersonsRepository>();
  Iterable<Person> get persons => personsRepository.getAll();
}

class PersonsPage extends UI<PersonsBloc> {
  @override
  PersonsBloc create() => PersonsBloc();

  const PersonsPage({super.key});
  @override
  Widget build(context, controller) {
    return FScaffold(
      childPad: false,
      header: FHeader(
        title: Text('PERSONS'),
        suffixes: [
          FHeaderAction(
            onPress: () {
              navigator.toDialog(NewPersonDialog());
            },
            icon: Icon(FIcons.plus),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: controller.persons.length,
        itemBuilder: (_, index) {
          final person = controller.persons.elementAt(index);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: FButton(
              child: Text(person.name),
              onPress: () {
                navigator.to(PersonPage(person: person));
              },
            ),
          );
        },
      ),
    );
  }
}
