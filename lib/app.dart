import 'package:flutter/material.dart';

import 'models/place.dart';
import 'screens/daily_input_screen.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'screens/quick_setup_screen.dart';
import 'screens/suggestion_detail_screen.dart';
import 'theme.dart';

class LifeOsApp extends StatelessWidget {
  const LifeOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeOS',
      debugShowCheckedModeBanner: false,
      theme: buildLifeOsTheme(),
      home: const OnboardingScreen(),
      routes: {
        QuickSetupScreen.routeName: (_) => const QuickSetupScreen(),
        HomeShell.routeName: (_) => const HomeShell(),
        DailyInputScreen.routeName: (_) => const DailyInputScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == SuggestionDetailScreen.routeName) {
          final place = settings.arguments is Place
              ? settings.arguments! as Place
              : suggestedPlaces.first;
          return MaterialPageRoute<void>(
            builder: (_) => SuggestionDetailScreen(place: place),
          );
        }

        return null;
      },
    );
  }
}
