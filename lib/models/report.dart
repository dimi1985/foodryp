class Report {
  final String id;
  final String commentId;
  final String reporterId;
  final String reason;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.commentId,
    required this.reporterId,
    required this.reason,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'] as String,
      commentId: json['commentId'] as String,
      reporterId: json['reporterId'] as String,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
