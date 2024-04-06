class User {
  final String id;
  final String username;
  final String email;
  final String profileImage;
  final String? gender; // Make gender nullable

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.profileImage,
    this.gender, // Update constructor to accept nullable gender
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      gender: json['gender'], // Assign the gender directly, it can be null
    );
  }
}
