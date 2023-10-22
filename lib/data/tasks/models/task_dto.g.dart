// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDTO _$TaskDTOFromJson(Map<String, dynamic> json) => TaskDTO(
      title: json['title'] as String,
      description: json['description'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      priority: json['priority'] as String,
      involvesPatient: json['involvesPatient'] as bool,
      category: json['category'] as String,
    );

Map<String, dynamic> _$TaskDTOToJson(TaskDTO instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'deadline': instance.deadline.toIso8601String(),
      'priority': instance.priority,
      'involvesPatient': instance.involvesPatient,
      'category': instance.category,
    };
