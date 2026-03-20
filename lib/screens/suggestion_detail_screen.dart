import 'package:flutter/material.dart';

import '../models/place.dart';
import '../widgets/lifeos_scaffold.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';
import 'map_places_screen.dart';

class SuggestionDetailScreen extends StatelessWidget {
  const SuggestionDetailScreen({super.key, required this.place});

  static const routeName = '/suggestion-detail';

  final Place place;

  @override
  Widget build(BuildContext context) {
    return LifeOsScaffold(
      appBar: AppBar(title: const Text('Suggestion')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You seem tired',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'A short change of scene could soften the rest of your day.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(place.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(place.description),
                const SizedBox(height: 16),
                Text(
                  place.area,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Chip(label: Text(place.distance)),
                    const SizedBox(width: 10),
                    Chip(label: Text(place.time)),
                    const SizedBox(width: 10),
                    Chip(label: Text(place.tagLabel)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alternative suggestions'),
                SizedBox(height: 12),
                _AltSuggestion(label: 'Watch short content'),
                SizedBox(height: 8),
                _AltSuggestion(label: 'Play quick game'),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Open Map',
            icon: Icons.map_rounded,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const MapPlacesScreen(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Done'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _AltSuggestion extends StatelessWidget {
  const _AltSuggestion({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.circle, size: 8),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}
