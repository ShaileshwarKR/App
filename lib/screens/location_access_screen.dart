import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/lifeos_scaffold.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';
import 'quick_setup_screen.dart';

class LocationAccessScreen extends StatelessWidget {
  const LocationAccessScreen({super.key});

  static const routeName = '/location-access';

  @override
  Widget build(BuildContext context) {
    return LifeOsScaffold(
      appBar: AppBar(title: const Text('Local suggestions')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: LifeOsColors.primarySoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.near_me_rounded,
              color: LifeOsColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Use your location for nearby resets.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'LifeOS can find parks, quiet places, and energizing stops near you so suggestions feel real, not generic.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LocationBenefit(
                  icon: Icons.park_rounded,
                  title: 'Find nearby calm places',
                  subtitle: 'Parks, quiet spaces, and low-friction breaks around you.',
                ),
                SizedBox(height: 16),
                _LocationBenefit(
                  icon: Icons.route_rounded,
                  title: 'Use real travel time',
                  subtitle: 'Suggestions stay practical for the time and energy you have.',
                ),
                SizedBox(height: 16),
                _LocationBenefit(
                  icon: Icons.lock_outline_rounded,
                  title: 'You stay in control',
                  subtitle: 'Skip for now and enable location later in the app.',
                ),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Use My Location',
            icon: Icons.my_location_rounded,
            onPressed: () => Navigator.pushNamed(
              context,
              QuickSetupScreen.routeName,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              QuickSetupScreen.routeName,
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Skip for now'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _LocationBenefit extends StatelessWidget {
  const _LocationBenefit({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: LifeOsColors.primarySoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: LifeOsColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
