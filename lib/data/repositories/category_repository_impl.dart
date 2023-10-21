import 'package:nurse_diary/data/mappers/category_mapper.dart';
import 'package:nurse_diary/data/server_api.dart';
import 'package:nurse_diary/domain/models/category.dart';
import 'package:nurse_diary/domain/repositories/category_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final ServerApi _serverApi;
  final CategoryMapper _categoryMapper;

  CategoryRepositoryImpl(this._serverApi, this._categoryMapper);

  // Cache expiration time in milliseconds (1 hour).
  static const cacheDuration = 3600000;
  static const _cacheKey = 'categories';

  @override
  Future<List<Category>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);

    if (cachedData != null) {
      final cachedTimestamp = prefs.getInt('${_cacheKey}_timestamp') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      if (currentTime - cachedTimestamp < cacheDuration) {
        // Cache is still valid; return the cached data.
        final categories = _categoryMapper.mapListFromString(cachedData);
        return categories;
      }
    }

    try {
      final categories = await _serverApi.getCategories();
      final mappedCategories = categories.map((e) => _categoryMapper.map(e)).toList();
      // Cache the data and update the timestamp.
      prefs.setString(_cacheKey, _categoryMapper.mapListToString(mappedCategories));
      prefs.setInt('${_cacheKey}_timestamp', DateTime.now().millisecondsSinceEpoch);

      return mappedCategories;
    } catch (error) {
      // Handle the error, possibly by falling back to cached data.
      print('Error fetching data: $error');
      if (cachedData != null) {
        return _categoryMapper.mapListFromString(cachedData);
      } else {
        // Handle the case when there is no cached data and an error occurs.
        rethrow;
      }
    }
  }
}