class User {
  final String id;
  final String username;
  final String email;
  final String profileImage;
  final String? gender;
  final DateTime? memberSince;
  final String? role;
  final List<String>? recipes;
  final List<String>? likedRecipes;
  final List<String>? followers;
  final List<String>? following;
  List<String>? followRequestsSent;
  List<String>? followRequestsReceived;
  List<String>? followRequestsCanceled;
  final List<String>? commentId;
    final List<String>? savedRecipes;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.profileImage,
    this.gender,
    required this.memberSince,
    required this.role,
    required this.recipes,
    required this.likedRecipes,
    required this.followers,
    required this.following,
    required this.followRequestsSent,
    required this.followRequestsReceived,
    required this.followRequestsCanceled,
    required this.commentId,
    required this.savedRecipes,
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
      likedRecipes: json['likedRecipes']?.cast<String>(),
      followers: json['followers']?.cast<String>(),
      following: json['following']?.cast<String>(),
      followRequestsSent: json['followRequestsSent']?.cast<String>(),
      followRequestsReceived: json['followRequestsReceived']?.cast<String>(),
      followRequestsCanceled: json['followRequestsCanceled']?.cast<String>(),
      commentId: json['commentId']?.cast<String>(),
      savedRecipes: json['savedRecipes']?.cast<String>(),
    );
  }

  set buttonText(String buttonText) {}

  Map<String, dynamic> toJson() => {
        '_id': id,
        'username': username,
        'email': email,
        'profileImage': profileImage,
        'gender': gender,
        'memberSince': memberSince,
        'role': role,
        'recipes': recipes,
        'likedRecipes': likedRecipes,
        'followers': followers,
        'following': following,
        'followRequestsSent': followRequestsSent,
        'followRequestsReceived': followRequestsReceived,
        'followRequestsCanceled': followRequestsCanceled,
        'commentId': commentId,
         'savedRecipes': savedRecipes,
      };
}
