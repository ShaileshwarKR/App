import 'package:flutter/material.dart';

import '../widgets/section_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'A simple space for your defaults and small reminders.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Maya Chen', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Preferred rhythm: calm evenings, protected sleep, lighter commute.'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    Chip(label: Text('Balanced days: 4')),
                    Chip(label: Text('Rest goal: 7.5 h')),
                    Chip(label: Text('Work cap: 8 h')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
