import 'dart:ui';

import 'package:nurse_diary/data/models/category_dto.dart';
import 'package:nurse_diary/domain/mappers/mapper.dart';
import 'package:nurse_diary/domain/models/category.dart';
import 'package:nurse_diary/presentation/common/utils/extenions.dart';

class CategoryMapper extends Mapper<CategoryDTO, Category> {
  @override
  Category map(CategoryDTO input) {
    return Category(
      name: input.name,
      description: input.description,
      color: HexColor.fromHex(input.color),
      icon: input.icon,
    );
  }

  String mapListToString(List<Category> categories) {
    return categories.map((category) => mapToString(category)).join(',');
  }

  String mapToString(Category category) {
    return '${category.name},${category.description},${category.color},${category.icon}';
  }

  List<Category> mapListFromString(String categoryString) {
    final categoryDataList = categoryString.split(',');
    final categories = <Category>[];
    for (var i = 0; i < categoryDataList.length; i += 4) {
      final color = categoryDataList[i + 2];

      categories.add(Category(
        name: categoryDataList[i],
        description: categoryDataList[i + 1],
        color: HexColor.fromHex(color),
        icon: categoryDataList[i + 3],
      ));
    }
    return categories;
  }
}
