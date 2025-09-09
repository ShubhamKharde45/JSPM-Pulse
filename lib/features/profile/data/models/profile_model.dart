class Profile {
  final String id;
  final String name;
  final String role;
  final String department;
  final int year;
  final DateTime createdAt;
  String? profilePic; // <-- mutable

  Profile({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.year,
    required this.createdAt,
    this.profilePic,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
      department: map['department'] as String,
      year: map['year'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      profilePic: map['profile_pic'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
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
