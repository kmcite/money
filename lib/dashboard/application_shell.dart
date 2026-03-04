import 'package:flutter/material.dart';
import 'package:money/dashboard/dashboard.dart';
import 'package:money/expenses/expenses_screen.dart';
import 'package:money/utils/ui.dart';
import 'package:signals/signals.dart';

final indexSignal = signal(0);
// final pageController = PageController();

// EffectCleanup? indexEffect;

class ApplicationShell extends UI {
  const ApplicationShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        DashboardPage(),
        ExpensesScreen(),
      ][indexSignal()],
      bottomNavigationBar: NavigationBar(
        selectedIndex: indexSignal(),
        onDestinationSelected: indexSignal.set,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.request_page),
            label: 'Expenses',
          ),
        ],
      ),
    );
  }
}
