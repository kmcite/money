import '../experiments.dart';
import '../main.dart';

class PersonsPage extends UI {
  const PersonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Persons'.text(
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: personsWithTransactions.isWaiting
          ? CircularProgressIndicator().center()
          : Column(
              children: [
                SearchBar().pad(),
                Expanded(
                  child: ListView.builder(
                    itemCount: personsWithTransactions.state.length,
                    itemBuilder: (context, index) {
                      PersonWithTransactions person(
                          [PersonWithTransactions? _]) {
                        if (_ != null) {}
                        return personsWithTransactions.state.elementAt(index);
                      }

                      final theme = Theme.of(context);
                      final colorScheme = theme.colorScheme;

                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledButton(
                              onPressed: () {
                                navigator
                                    .to(PersonPage(person: person().person));
                                appDatabase.deletePerson(person().person.id);
                              },
                              child: person().person.name.text(),
                            ).pad(),
                            if (person().transactions.isNotEmpty)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: person().transactions.map(
                                    (transaction) {
                                      return Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Chip(
                                          label: Text(
                                            transaction.amount.toString(),
                                            style: TextStyle(
                                              color: colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                          backgroundColor:
                                              colorScheme.secondaryContainer,
                                          elevation: 0,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // final person = await navigator.toDialog<Person>(_NewPersonDialog());
          // if (person != null) personsRM.put(person);
          await appDatabase
              .into(appDatabase.persons)
              .insert(PersonsCompanion.insert(name: 'Adnan'));
        },
        tooltip: 'Add person',
        icon: Icon(Icons.add),
        label: 'add person'.text(),
      ),
    );
  }
}

final newPersonNameRM = RM.inject(() => '');

class _NewPersonDialog extends UI {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          'new person'.text().pad(),
          TextFormField(
            initialValue: newPersonNameRM.state,
            onChanged: (value) => newPersonNameRM.state = value,
          ).pad(),
          Row(
            children: [
              'tap outside to cancel'.text().pad(),
              ElevatedButton(
                onPressed: () {
                  // navigator.back(Person()..name = newPersonNameRM.state);
                  newPersonNameRM.state = '';
                },
                child: 'save'.text(),
              ),
            ],
          ).pad(),
        ],
      ),
    );
  }
}
