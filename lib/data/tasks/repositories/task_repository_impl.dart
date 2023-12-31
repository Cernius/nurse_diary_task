import 'package:nurse_diary/data/tasks/mappers/task_mapper.dart';
import 'package:nurse_diary/data/server_api.dart';
import 'package:nurse_diary/domain/tasks/models/task.dart';
import 'package:nurse_diary/domain/tasks/repositories/task_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskRepositoryImpl extends TaskRepository {
  final ServerApi serverApi;
  final TaskMapper taskMapper;

  TaskRepositoryImpl({required this.serverApi, required this.taskMapper});

  // Cache expiration time in milliseconds (1 hour).
  static const cacheDuration = 3600000;
  static const _cacheKey = 'tasks';

  @override
  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);

    if (cachedData != null) {
      final cachedTimestamp = prefs.getInt('${_cacheKey}_timestamp') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      if (currentTime - cachedTimestamp < cacheDuration) {
        // Cache is still valid; return the cached data.
        final tasks = taskMapper.mapListFromString(cachedData);
        return tasks;
      }
    }

    try {
      final tasks = await serverApi.getTasks();
      final mappedTasks = tasks.map((e) => taskMapper.map(e)).toList();
      // Cache the data and update the timestamp.
      prefs.setString(_cacheKey, taskMapper.mapListToString(mappedTasks));
      prefs.setInt('${_cacheKey}_timestamp', DateTime.now().millisecondsSinceEpoch);

      return mappedTasks;
    } catch (error) {
      // Handle the error, possibly by falling back to cached data.
      print('Error fetching data: $error');
      if (cachedData != null) {
        return taskMapper.mapListFromString(cachedData);
      } else {
        // Handle the case when there is no cached data and an error occurs.
        rethrow;
      }
    }
  }

  @override
  Future<List<Task>> getTasksByCategory({required String category}) async {
    final tasks = await getTasks();
    final filteredTasks = tasks.where((element) => element.category == category).toList();
    filteredTasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    return filteredTasks;
  }

  @override
  Future<void> completeTask({required Task task}) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((element) => element.title == task.title);
    tasks.removeAt(index);
    tasks.insert(index, task);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, taskMapper.mapListToString(tasks));
  }
}
