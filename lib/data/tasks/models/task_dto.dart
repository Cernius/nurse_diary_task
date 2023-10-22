import 'package:json_annotation/json_annotation.dart';

part 'task_dto.g.dart';

@JsonSerializable()
class TaskDTO {
  final String title;
  final String description;
  final DateTime deadline;
  final String priority;
  @JsonValue('involves_patient')
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

  factory TaskDTO.fromJson(Map<String, dynamic> json) => _$TaskDTOFromJson(json);
}
