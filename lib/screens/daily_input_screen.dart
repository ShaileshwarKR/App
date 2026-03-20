import 'package:flutter/material.dart';

import '../models/daily_log.dart';
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
  double stressLevel = 6;

  MoodLevel get mood => switch (selectedMood) {
        0 => MoodLevel.happy,
        1 => MoodLevel.neutral,
        _ => MoodLevel.low,
      };

  @override
  Widget build(BuildContext context) {
    return LifeOsScaffold(
      appBar: AppBar(title: const Text('Log today')),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A quick check-in is enough.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Add the essentials plus a few body signals for a better Life Score.',
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
                  Text('Stress level', style: Theme.of(context).textTheme.bodyLarge),
                  Slider(
                    value: stressLevel,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: stressLevel.round().toString(),
                    onChanged: (value) => setState(() => stressLevel = value),
                  ),
                  const SizedBox(height: 8),
                  const ValueInput(label: 'Work hours', hint: '8'),
                  const SizedBox(height: 16),
                  const ValueInput(label: 'Sleep hours', hint: '7'),
                  const SizedBox(height: 16),
                  const ValueInput(label: 'Commute', hint: '35 min'),
                  const SizedBox(height: 16),
                  const ValueInput(label: 'Hydration (L)', hint: '2.0'),
                  const SizedBox(height: 16),
                  const ValueInput(label: 'Meals', hint: '3'),
                  const SizedBox(height: 16),
                  const ValueInput(label: 'Exercise (min)', hint: '20'),
                  const SizedBox(height: 12),
                  Text(
                    'Detected mood: ${mood.name}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Save',
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
