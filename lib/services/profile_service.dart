import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

/// Stores profile data in both Firestore and local cache so the app
/// can bootstrap quickly and still work offline.
class ProfileService {
  ProfileService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  static const demoUserId = 'demo-user';
  static const _cacheKey = 'lifeos_user_profile';

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get currentUserId => _auth.currentUser?.uid ?? demoUserId;

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

  Future<UserProfile?> loadProfile([String? userId]) async {
    final resolvedUserId = userId ?? currentUserId;
    try {
      final doc = await _firestore.collection('users').doc(resolvedUserId).get();
      if (doc.exists && doc.data() != null) {
        final profile = UserProfile.fromMap(resolvedUserId, doc.data()!);
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
