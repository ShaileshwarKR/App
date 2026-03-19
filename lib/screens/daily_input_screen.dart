import 'package:flutter/material.dart';

import '../widgets/lifeos_scaffold.dart';
import '../widgets/mood_selector.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';
import '../widgets/value_input.dart';

class DailyInputScreen extends StatefulWidget {
  const DailyInputScreen({super.key});

  static const routeName = '/daily-input';

  @override
  State<DailyInputScreen> createState() => _DailyInputScreenState();
}

class _DailyInputScreenState extends State<DailyInputScreen> {
  int selectedMood = 1;

  @override
  Widget build(BuildContext context) {
    return LifeOsScaffold(
      appBar: AppBar(title: const Text('Log today')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A quick check-in is enough.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'How does today feel in your body?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mood', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 14),
                MoodSelector(
                  selectedIndex: selectedMood,
                  onSelected: (value) => setState(() => selectedMood = value),
                ),
                const SizedBox(height: 18),
                const ValueInput(label: 'Work hours', hint: '8'),
                const SizedBox(height: 16),
                const ValueInput(label: 'Sleep hours', hint: '7'),
                const SizedBox(height: 16),
                const ValueInput(label: 'Commute', hint: '35 min'),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Save',
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
