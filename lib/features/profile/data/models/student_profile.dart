class Profile {
  final String id;
  final String name;
  final String role;
  late String? profilePicUrl;

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
      profilePicUrl: map['profile_pic_url'] as String,
    );
  }

  Profile({
    required this.id,
    required this.name,
    required this.role,
    this.profilePicUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'profilePicurl': profilePicUrl,
    };
  }
}
