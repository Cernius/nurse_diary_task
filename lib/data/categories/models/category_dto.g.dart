// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDTO _$CategoryDTOFromJson(Map<String, dynamic> json) => CategoryDTO(
      name: json['name'] as String,
      description: json['description'] as String,
      color: json['color'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$CategoryDTOToJson(CategoryDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
      'icon': instance.icon,
    };
