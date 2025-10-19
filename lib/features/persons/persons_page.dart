import 'package:money/domain/models/person.dart';
import 'package:money/domain/repositories/persons_repository.dart';
import 'package:money/features/persons/new_person_dialog.dart';
import 'package:money/features/persons/person_page.dart';
import 'package:money/main.dart';
import 'package:money/utils/navigator.dart';

class PersonsBloc extends Bloc {
  late final personsRepository = depend<PersonsRepository>();

  /// GLOBAL STATE
  Iterable<Person> get persons => personsRepository.getAll();

  /// LOCAL STATE
  String query = '';

  Iterable<Person> get filteredPersons {
    if (query.isEmpty) return persons;

    return persons.where(
        (person) => person.name.toLowerCase().contains(query.toLowerCase()));
  }

  /// MUTATIONS
  void onQueryChanged(String value) {
    query = value;
    notifyListeners();
  }
}

class PersonsPage extends Feature<PersonsBloc> {
  @override
  PersonsBloc create() => PersonsBloc();
  const PersonsPage({super.key});
  @override
  Widget build(context, controller) {
    return Scaffold(
      appBar: AppBar(
        title: Text('People'),
        actions: [
          IconButton(
            onPressed: () => navigator.toDialog(NewPersonDialog()),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search people...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: controller.onQueryChanged,
            ),
          ),

          // People List
          Expanded(
            child: controller.filteredPersons.isEmpty
                ? _EmptyPersonsState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.filteredPersons.length,
                    itemBuilder: (_, index) {
                      final person =
                          controller.filteredPersons.elementAt(index);
                      return _PersonListItem(
                        person: person,
                        onTap: () => navigator.to(PersonPage(person: person)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// UI Components for Persons Page
// UI Components for Persons Page
class _PersonListItem extends StatelessWidget {
  final Person person;
  final VoidCallback onTap;

  const _PersonListItem({
    required this.person,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          person.name,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('View transactions'),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _EmptyPersonsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No people found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
            ),
            SizedBox(height: 8),
            Text(
              'Add people to start tracking transactions',
              style: TextStyle(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => navigator.toDialog(NewPersonDialog()),
              icon: Icon(Icons.add),
              label: Text('Add Person'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
