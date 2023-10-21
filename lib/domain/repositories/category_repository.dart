import 'package:nurse_diary/domain/models/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}