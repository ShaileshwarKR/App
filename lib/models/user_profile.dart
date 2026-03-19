class UserProfile {
  const UserProfile({
    required this.userId,
    required this.name,
    required this.homeAddress,
    required this.companyAddress,
    required this.isWfh,
    required this.profilePictureUrl,
    required this.workSchedule,
  });

  final String userId;
  final String name;
  final String homeAddress;
  final String companyAddress;
  final bool isWfh;
  final String profilePictureUrl;
  final Map<String, dynamic> workSchedule;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'home_address': homeAddress,
      'company_address': companyAddress,
      'is_wfh': isWfh,
      'profile_picture_url': profilePictureUrl,
      'work_schedule': workSchedule,
    };
  }

  Map<String, dynamic> toCacheMap() {
    return {
      'user_id': userId,
      ...toMap(),
    };
  }

  factory UserProfile.fromMap(String userId, Map<String, dynamic> map) {
    return UserProfile(
      userId: userId,
      name: map['name'] as String? ?? '',
      homeAddress: map['home_address'] as String? ?? '',
      companyAddress: map['company_address'] as String? ?? '',
      isWfh: map['is_wfh'] as bool? ?? false,
      profilePictureUrl: map['profile_picture_url'] as String? ?? '',
      workSchedule: Map<String, dynamic>.from(
        map['work_schedule'] as Map? ?? const {},
      ),
    );
  }

  factory UserProfile.fromCacheMap(Map<String, dynamic> map) {
    return UserProfile.fromMap(
      map['user_id'] as String? ?? '',
      map,
    );
  }
}
