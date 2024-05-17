class Wikifood {
  final String id;
  final String title;
  final String text;
  final String source;

  Wikifood({
    required this.id,
    required this.title,
    required this.text,
    required this.source,
  });

  factory Wikifood.fromJson(Map<String, dynamic> json) {
    return Wikifood(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      source: json['source'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'text': text,
      'source': source,
    };
  }
}
