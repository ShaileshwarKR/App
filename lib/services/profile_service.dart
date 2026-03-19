import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

/// Stores profile data in both Firestore and local cache so the app
/// can bootstrap quickly and still work offline.
class ProfileService {
  ProfileService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const demoUserId = 'demo-user';
  static const _cacheKey = 'lifeos_user_profile';

  final FirebaseFirestore _firestore;

  Future<bool> hasLocalProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_cacheKey);
  }

  Future<UserProfile?> getCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return null;
    return UserProfile.fromCacheMap(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  Future<UserProfile?> loadProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final profile = UserProfile.fromMap(userId, doc.data()!);
        await _cacheProfile(profile);
        return profile;
      }
    } catch (_) {
      // Fall back to local cache when Firestore is unavailable.
    }
    return getCachedProfile();
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.userId).set(profile.toMap());
    await _cacheProfile(profile);
  }

  Future<void> _cacheProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(profile.toCacheMap()));
  }
}
