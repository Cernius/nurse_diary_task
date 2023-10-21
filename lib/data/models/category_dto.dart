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

  factory CategoryDTO.fromJson(Map<String, dynamic> json) => CategoryDTO(
        name: json['name'],
        description: json['description'],
        color: json['color'],
        icon: json['icon'],
      );
}
