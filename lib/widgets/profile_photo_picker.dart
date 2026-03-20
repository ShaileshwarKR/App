import 'package:flutter/material.dart';

import '../theme.dart';

class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({
    super.key,
    required this.imageUrl,
    required this.onPick,
  });

  final String imageUrl;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 38,
          backgroundColor: LifeOsColors.primarySoft,
          backgroundImage: imageUrl.isEmpty ? null : NetworkImage(imageUrl),
          child: imageUrl.isEmpty
              ? const Icon(Icons.person_rounded, size: 36, color: LifeOsColors.primary)
              : null,
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.add_a_photo_rounded),
          label: const Text('Add Photo'),
        ),
      ],
    );
  }
}
