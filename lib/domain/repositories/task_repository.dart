import 'package:nurse_diary/domain/models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();

  Future<List<Task>> getTasksByCategory(String category);

  void completeTask(Task task);
}
