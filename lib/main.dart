import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'services/profile_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final hasProfile = await ProfileService().hasLocalProfile();
  runApp(LifeOsApp(showProfileOnboarding: !hasProfile));
}
