import 'package:intl/intl.dart';

class Task {
  final int? id;
  final String title;
  final String description;
  final String status;
  final String dueDate;
  final String createdAt;
  final String priority;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
    required this.createdAt,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'dueDate': dueDate,
      'createdAt': createdAt,
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      dueDate: map['dueDate'],
      createdAt: map['createdAt'],
      priority: map['priority'],
    );
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static DateTime parseDateTime(String dateTimeString) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString);
  }

  static String formatForDisplay(String dateTimeString) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString);
    return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
  }

}
