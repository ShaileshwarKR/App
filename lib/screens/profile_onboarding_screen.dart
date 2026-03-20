import 'package:flutter/material.dart';

import '../models/location_point.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../theme.dart';
import '../widgets/lifeos_scaffold.dart';
import '../widgets/location_picker_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/profile_photo_picker.dart';
import '../widgets/section_card.dart';
import 'home_shell.dart';

class ProfileOnboardingScreen extends StatefulWidget {
  const ProfileOnboardingScreen({super.key});

  static const routeName = '/profile-onboarding';

  @override
  State<ProfileOnboardingScreen> createState() => _ProfileOnboardingScreenState();
}

class _ProfileOnboardingScreenState extends State<ProfileOnboardingScreen> {
  final nameController = TextEditingController();
  final homeController = TextEditingController();
  final companyController = TextEditingController();
  final scheduleController = TextEditingController(text: 'Mon-Fri • 9 to 6');
  bool isWfh = false;
  String profilePictureUrl = '';
  bool isSaving = false;

  @override
  void dispose() {
    nameController.dispose();
    homeController.dispose();
    companyController.dispose();
    scheduleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LifeOsScaffold(
      appBar: AppBar(title: const Text('Set up your profile')),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell LifeOS enough to automate the basics.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This runs once, then your home, work, commute, and recovery flow can feel much lighter.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ProfilePhotoPicker(
                      imageUrl: profilePictureUrl,
                      onPick: _mockPhotoPick,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  LocationPickerField(
                    label: 'Home address',
                    controller: homeController,
                    hint: 'Add home address',
                  ),
                  const SizedBox(height: 16),
                  LocationPickerField(
                    label: 'Company address',
                    controller: companyController,
                    hint: 'Add company address',
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('I usually work from home'),
                    value: isWfh,
                    onChanged: (value) => setState(() => isWfh = value ?? false),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: scheduleController,
                    decoration: const InputDecoration(
                      hintText: 'Work schedule preferences (optional)',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Automation preview', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _AutomationRow(label: 'Commute', value: 'Google Maps from saved addresses'),
                  const SizedBox(height: 10),
                  _AutomationRow(label: 'Work hours', value: 'Calendar / activity detection'),
                  const SizedBox(height: 10),
                  _AutomationRow(label: 'Sleep', value: 'Google Fit / HealthKit sync'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: isSaving ? 'Saving...' : 'Save Profile',
              onPressed: isSaving ? () {} : _saveProfile,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    setState(() => isSaving = true);
    final profile = UserProfile(
      userId: ProfileService().currentUserId,
      name: nameController.text.trim().isEmpty ? 'Maya' : nameController.text.trim(),
      homeAddress: homeController.text.trim(),
      companyAddress: companyController.text.trim(),
      isWfh: isWfh,
      profilePictureUrl: profilePictureUrl,
      workSchedule: {
        'label': scheduleController.text.trim(),
        'start_hour': 9,
        'end_hour': 18,
      },
      // TODO: Replace with exact coordinates from a real picker / Places API.
      homeLocation: homeController.text.trim().isEmpty
          ? null
          : const LocationPoint(latitude: 37.7749, longitude: -122.4194),
      officeLocation: companyController.text.trim().isEmpty
          ? null
          : const LocationPoint(latitude: 37.7897, longitude: -122.3942),
    );

    await ProfileService().saveProfile(profile);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      HomeShell.routeName,
      (route) => false,
    );
  }

  void _mockPhotoPick() {
    setState(() {
      profilePictureUrl = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400';
    });
  }
}

class _AutomationRow extends StatelessWidget {
  const _AutomationRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: LifeOsColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
