import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:money/dashboard/dashboard.dart';
import 'package:money/expenses/expenses_screen.dart';
import 'package:signals/signals.dart';

final indexSignal = signal(0);

class ApplicationShell extends StatefulWidget {
  const ApplicationShell({super.key});

  @override
  State<ApplicationShell> createState() => _ApplicationShellState();
}

class _ApplicationShellState extends State<ApplicationShell> {
  int index = 0;
  void onIndexChanged(int value) => setState(() => index = value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        DashboardPage(),
        ExpensesScreen(),
      ][indexSignal()],
      floatingActionButtonLocation: .centerTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(eccentricity: .2),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.tertiary,
              ],
              transform: GradientRotation(pi / 4),
            ),
          ),
          child: Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: onIndexChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Expenses',
          ),
        ],
      ),
    );
  }
}
