class Profile {
  final String id;
  final String role;
  final String? name;
  final String? department;
  final int? year;
  final DateTime createdAt;
  String? profilePic;

  Profile({
    required this.id,
    required this.role,
    this.name,
    this.department,
    this.year,
    required this.createdAt,
    this.profilePic,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] ?? '',
      role: map['role'] ?? 'student',
      name: map['name'] as String?,
      department: map['department'] as String?,
      year: map['year'] is int
          ? map['year'] as int
          : int.tryParse(map['year']?.toString() ?? ''),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      profilePic: map['profile_pic'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'name': name,
      'department': department,
      'year': year,
      'created_at': createdAt.toIso8601String(),
      'profile_pic': profilePic,
    };
  }

  void updateProfilePic(String newUrl) {
    profilePic = newUrl;
  }
}
