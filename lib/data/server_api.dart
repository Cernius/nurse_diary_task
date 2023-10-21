import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurse_diary/data/models/category_dto.dart';
import 'package:nurse_diary/data/models/task_dto.dart';
import 'package:nurse_diary/domain/repositories/preference_repository.dart';
import 'package:nurse_diary/domain/services/logger.dart';

class ServerApi {
  final PreferenceRepository _preferenceRepository;
  final Logger _logger;

  ServerApi(this._preferenceRepository, this._logger);

  Future<http.Response> getData(
    String endpoint, {
    Map<String, String>? query,
  }) async {
    Uri url = Uri.http(_preferenceRepository.getServerUrl(), endpoint, query);
    dynamic response;

    response = await http.get(url);

    return response;
  }

  Future<http.Response> post(String endpoint,
      {required String body, bool loginHeaders = false, Map<String, dynamic>? queryParams}) async {
    Uri url = Uri.http(_preferenceRepository.getServerUrl(), endpoint, queryParams);
    http.Response response = http.Response('Error', 404);

    response = await http.post(
      url,
      headers: await _getHeaders(),
      body: body,
    );

    return response;
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

      _logger.d(list);
      return list['tasks'].map<TaskDTO>((e) => TaskDTO.fromJson(e)).toList();
    });
  }

  Future<Map<String, String>> _getHeaders() async => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Connection': 'close',
        'TimeZone': DateTime.now().timeZoneOffset.inHours.toString(),
      };
}
