import 'package:nurse_diary/domain/models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();

  Future<List<Task>> getTasksByCategory({required String category});

  Future<void> completeTask({required Task task});
}
