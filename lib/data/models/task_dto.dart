class TaskDTO {
  final String title;
  final String description;
  final DateTime deadline;
  final String priority;
  final bool involvesPatient;
  final String category;

  TaskDTO({
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.involvesPatient,
    required this.category,
  });

  factory TaskDTO.fromJson(Map<String, dynamic> json) {
    return TaskDTO(
      title: json['title'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      priority: json['priority'],
      involvesPatient: json['involves_patient'],
      category: json['category'],
    );
  }
}
