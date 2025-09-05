import 'package:money/domain/repositories/index_repository.dart';
import 'package:money/features/persons/persons_page.dart';
import 'package:money/features/transactions/transactions_page.dart';
import 'package:money/main.dart';

import '../settings/settings_page.dart';
import 'dashboard.dart';

class ApplicationShellBloc extends Controller {
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
class ApplicationShell extends UI<ApplicationShellBloc> {
  const ApplicationShell({super.key});

  @override
  ApplicationShellBloc create() => ApplicationShellBloc();

  @override
  Widget build(context, controller) {
    return Scaffold(
      bottomNavigationBar: FBottomNavigationBar(
        index: controller.index,
        onChange: controller.setIndex,
        children: [
          FBottomNavigationBarItem(
            icon: Icon(FIcons.house),
            label: Text('Dashboard'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.group),
            label: Text('Persons'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.dollarSign),
            label: Text('Transactions'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.settings),
            label: Text('Settings'),
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
