import 'package:money/domain/repositories/index_repository.dart';
import 'package:money/features/persons/persons_page.dart';
import 'package:money/features/transactions/transactions_page.dart';
import 'package:money/main.dart';

import '../settings/settings_page.dart';
import 'dashboard.dart';

class ApplicationShellBloc extends Bloc {
  /// SOURCES
  late final indexRepository = depend<IndexRepository>();

  /// GLOBAL STATE
  int get index => indexRepository.lengdex.index;

  /// LOCAL
  late final pageController = PageController(
    initialPage: index,
    viewportFraction: 1,
  );

  /// EFFECTS
  void setIndex(int value) {
    indexRepository.index(value);
    pageController.jumpToPage(value);
    notifyListeners();
  }
}

/// UI LAYER
class ApplicationShell extends Feature<ApplicationShellBloc> {
  const ApplicationShell({super.key});

  @override
  ApplicationShellBloc create() => ApplicationShellBloc();

  @override
  Widget build(context, controller) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.index,
        onDestinationSelected: controller.setIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.group),
            label: 'Persons',
          ),
          NavigationDestination(
            icon: Icon(Icons.attach_money),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.setIndex,
        children: [
          DashboardPage(),
          PersonsPage(),
          TransactionsPage(),
          SettingsPage(),
        ],
      ),
    );
  }
}
