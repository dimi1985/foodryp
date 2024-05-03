class Comment {
  final String id;
  final String text;
  final String userId;
  final String username;
  final String useImage;
  final String recipeId;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  List<Comment>? replies;

  Comment({
    required this.id,
    required this.text,
    required this.userId,
    required this.username,
    required this.useImage,
    required this.recipeId,
    this.dateCreated,
    this.dateUpdated,
    this.replies,
  });

  // Method to convert JSON data into a Comment object
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? '',
      text: json['text'] ?? '',
      userId:
          json['userId'] is Map ? json['userId']['_id']?.toString() ?? '' : '',
      username: json['username'] ?? '',
      useImage: json['useImage'] ?? '',
      recipeId: json['recipeId'] is Map
          ? json['recipeId']['_id']?.toString() ?? ''
          : '',
      dateCreated: json['dateCreated'] != null
          ? DateTime.parse(json['dateCreated'])
          : null,
      dateUpdated: json['dateUpdated'] != null
          ? DateTime.parse(json['dateUpdated'])
          : null,
      replies: (json['replies'] as List?)
              ?.map((data) => Comment.fromJson(data))
              .toList() ??
          [],
    );
  }

  // Method to convert a Comment object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'userId': userId,
      'username': username,
      'useImage': useImage,
      'recipeId': recipeId,
      'dateCreated': dateCreated?.toIso8601String(),
      'dateUpdated': dateUpdated?.toIso8601String(),
      'replies': replies?.map((reply) => reply.toJson()).toList(),
    };
  }
}
