import 'package:nurse_diary/domain/categories/models/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}