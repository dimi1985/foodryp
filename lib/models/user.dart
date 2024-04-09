class User {
  final String id;
  final String username;
  final String email;
  final String profileImage;
  final String? gender;
  final DateTime? memberSince;
  final String? role;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.profileImage,
    this.gender,
    required this.memberSince,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['_id'] ?? '',
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    profileImage: json['profileImage'] ?? '',
    gender: json['gender'],
    memberSince: json['memberSince'] != null ? DateTime.parse(json['memberSince']) : null, // Parse string to DateTime object
    role: json['role'],
  );
}
}
