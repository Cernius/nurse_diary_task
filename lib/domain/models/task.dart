import 'package:equatable/equatable.dart';

class Task   {
  final String title;
  final String description;
  final DateTime deadline;
  final String priority;
  final bool involvesPatient;
  final String category;
  final DateTime? completedAt;

  Task({
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.involvesPatient,
    required this.category,
    this.completedAt,
  });

  Task copyWith({DateTime? completedAt}) {
    return Task(
      title: title,
      description: description,
      deadline: deadline,
      priority: priority,
      involvesPatient: involvesPatient,
      category: category,
      completedAt: completedAt,
    );
  }

}
