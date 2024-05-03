import 'package:intl/intl.dart';

class CelebrationDay {
  final int? id;
  final String description;
  final DateTime dueDate;

  CelebrationDay({this.id, required this.description, required this.dueDate});

  // Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'dueDate': DateFormat('yyyy-MM-dd').format(dueDate),
    };
  }

  // Create a new instance from a map
  static CelebrationDay fromMap(Map<String, dynamic> map) {
    return CelebrationDay(
      id: map['id'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
    );
  }

  // Allows copying the data model while changing a subset of the attributes
  CelebrationDay copyWith({
    int? id,
    String? description,
    DateTime? dueDate,
  }) {
    return CelebrationDay(
      id: id ?? this.id,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
