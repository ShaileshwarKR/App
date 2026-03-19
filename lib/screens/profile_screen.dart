import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../widgets/section_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: ProfileService().getCachedProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = snapshot.data;
        if (profile == null) {
          return const Center(child: Text('No profile saved yet.'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Automation uses this profile to reduce manual logging.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('Home: ${profile.homeAddress}'),
                    const SizedBox(height: 8),
                    Text('Company: ${profile.companyAddress}'),
                    const SizedBox(height: 8),
                    Text('WFH: ${profile.isWfh ? 'Yes' : 'No'}'),
                    const SizedBox(height: 8),
                    Text('Schedule: ${profile.workSchedule['label'] ?? 'Not set'}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
