import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/lifeos_scaffold.dart';
import '../widgets/primary_button.dart';
import 'location_access_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const highlights = <String>[
    'Track your life, not just work',
    'Know when to rest',
    'Get real suggestions',
  ];

  @override
  Widget build(BuildContext context) {
    return LifeOsScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: LifeOsColors.primarySoft,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.spa_rounded,
              size: 34,
              color: LifeOsColors.primary,
            ),
          ),
          const SizedBox(height: 28),
          Text('LifeOS', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 14),
          Text(
            'You don’t need more time. You need better balance.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 18),
          Text(
            'A softer way to notice stress, protect your energy, and keep your day human.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: highlights
                .map(
                  (item) => Chip(
                    label: Text(item),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                )
                .toList(),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Get Started',
            onPressed: () => Navigator.pushNamed(
              context,
              LocationAccessScreen.routeName,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
