import 'package:json_annotation/json_annotation.dart';

part 'category_dto.g.dart';

@JsonSerializable()
class CategoryDTO {
  String name;
  String description;
  String color;
  String icon;

  CategoryDTO({
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
  });

  factory CategoryDTO.fromJson(Map<String, dynamic> json) => _$CategoryDTOFromJson(json);
}
