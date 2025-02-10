import '../main.dart';

class Application extends UI {
  const Application({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      body: [
        DashboardPage(),
        PersonsPage(),
        // TransactionsPage(),
        SettingsPage()
      ][index()],
      bottomNavigationBar: NavigationBar(
        elevation: 8,
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: .3),
        selectedIndex: index(),
        onDestinationSelected: index,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_rounded),
            label: 'Persons',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_rounded),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class DateTimeUI extends UI {
  const DateTimeUI({super.key, required this.dateTime});
  final dynamic dateTime;
  @override
  Widget build(BuildContext context) {
    final time = '${dateTime().hour}:${dateTime().minute}';
    final date = '${dateTime().day}-${dateTime().month}-${dateTime().year}';
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: (time + ' ' + date)
          .text(
            textScaleFactor: 1.3,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
          .center(),
    );
  }
}

final indexRM = RM.inject(() => 0);

int index([index]) {
  if (index != null) indexRM.state = index;
  return indexRM.state;
}

class DashboardPage extends UI {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Khata'.text(
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).primaryColor.withValues(alpha: .5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  'Total'
                      .text(
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                      .pad(),
                  // '${transactionsAll}'
                  //     .text(
                  //       textScaleFactor: 3,
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //     )
                  //     .pad(),
                  Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          'to give'
                              .text(
                                style: TextStyle(
                                  fontSize: 16,
                                  // color: Colors.green,
                                ),
                              )
                              .pad(),
                          // '${transactionsToGet}'
                          //     .text(
                          //       textScaleFactor: 2,
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.green,
                          //       ),
                          //     )
                          //     .pad(),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 1,
                      ),
                      Column(
                        children: [
                          'to get'
                              .text(
                                style: TextStyle(
                                  fontSize: 16,
                                  // color: Colors.red,
                                ),
                              )
                              .pad(),
                          // '${transactionsToGive}'
                          //     .text(
                          //       textScaleFactor: 2,
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.red,
                          //       ),
                          //     )
                          //     .pad(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
