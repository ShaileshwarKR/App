import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/lifeos_scaffold.dart';
import 'habits_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'weekly_insights_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  static const routeName = '/home';

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final _pages = const [
    HomeScreen(),
    WeeklyInsightsScreen(),
    HabitsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LifeOsScaffold(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) => setState(() => _currentIndex = value),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_rounded),
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_rounded),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              backgroundColor: LifeOsColors.textPrimary,
              foregroundColor: Colors.white,
              onPressed: () => Navigator.pushNamed(context, '/daily-input'),
              label: const Text('+ Log Today'),
            )
          : null,
    );
  }
}
