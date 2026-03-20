import 'package:flutter/material.dart';

import '../widgets/lifeos_scaffold.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';
import '../widgets/value_input.dart';
import 'home_shell.dart';

class QuickSetupScreen extends StatelessWidget {
  const QuickSetupScreen({super.key});

  static const routeName = '/quick-setup';

  @override
  Widget build(BuildContext context) {
    return LifeOsScaffold(
      appBar: AppBar(title: const Text('Quick setup')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set your baseline in a few seconds.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Just enough to understand your day without turning it into a form.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const SectionCard(
            child: Column(
              children: [
                ValueInput(label: 'Work hours', hint: '8'),
                SizedBox(height: 16),
                ValueInput(label: 'Sleep hours', hint: '7.5'),
                SizedBox(height: 16),
                ValueInput(label: 'Commute time', hint: '45 min'),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Continue',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              HomeShell.routeName,
              (route) => false,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
