class User {
  final String id;
  final String username;
  final String email;
  final String profileImage;
  final String? gender;
  final DateTime? memberSince;
  final String? role;
  final List<String>? recipes;
   final List<String>? following;
   final List<String>? followedBy;
   final List<String>? likedRecipes;
   

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.profileImage,
    this.gender,
    required this.memberSince,
    required this.role,
    required this.recipes,
      required this.following,
      required this.followedBy,
      required this.likedRecipes,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      gender: json['gender'],
      memberSince: json['memberSince'] != null
          ? DateTime.parse(json['memberSince'])
          : null, // Parse string to DateTime object
      role: json['role'],
      recipes: json['recipes']?.cast<String>(),
      following: json['following']?.cast<String>(),
       followedBy: json['followedBy']?.cast<String>(),
         likedRecipes: json['likedRecipes']?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'username': username,
        'email': email,
        'profileImage': profileImage,
        'gender': gender,
        'memberSince': memberSince,
        'role': role,
        'recipes': recipes,
        'following': following,
         'followedBy': followedBy,
          'likedRecipes': likedRecipes,
      };
}
