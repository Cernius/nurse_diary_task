import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurse_diary/data/categories/models/category_dto.dart';
import 'package:nurse_diary/data/tasks/models/task_dto.dart';
import 'package:nurse_diary/domain/preferences/preference_repository.dart';
import 'package:nurse_diary/domain/shared/logger.dart';

class ServerApi {
  final PreferenceRepository preferenceRepository;
  final Logger logger;

  ServerApi({required this.preferenceRepository, required this.logger});

  Future<http.Response> getData(String endpoint, {Map<String, String>? query}) async {
    try {
      Uri url = Uri.http(preferenceRepository.getServerUrl(), endpoint, query);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('An error occurred: $e');
      rethrow;
    }
  }

  Future<List<CategoryDTO>> getCategories() async {
    return getData('categories').then((response) {
      // Json format is not valid, so we need to add [] to the response body
      final list = json.decode('[${response.body}]');

      return list.map<CategoryDTO>((e) => CategoryDTO.fromJson(e)).toList();
    });
  }

  Future<List<TaskDTO>> getTasks() async {
    return getData('tasks').then((response) {
      final list = json.decode(response.body);

      logger.d(list);
      return list['tasks'].map<TaskDTO>((e) => TaskDTO.fromJson(e)).toList();
    });
  }
}
