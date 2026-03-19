import 'package:flutter/material.dart';

import 'app.dart';
import 'services/profile_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasProfile = await ProfileService().hasLocalProfile();
  runApp(LifeOsApp(showProfileOnboarding: !hasProfile));
}
