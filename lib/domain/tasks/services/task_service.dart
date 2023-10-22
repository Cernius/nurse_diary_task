import 'package:nurse_diary/domain/tasks/models/task.dart';
import 'package:nurse_diary/domain/tasks/repositories/task_repository.dart';
import 'package:nurse_diary/presentation/common/utils/extenions.dart';

class TaskService {
  final TaskRepository taskRepository;

  TaskService({required this.taskRepository});

  Future<List<Task>> getTasksByCategory({
    required String category,
    required DateTime selectedDay,
  }) async {
    List<Task> tasks = await taskRepository.getTasksByCategory(category: category);
    tasks = _filterTasksByDay(tasks: tasks, selectedDay: selectedDay);
    return _sortByDeadline(tasks: tasks);
  }

  List<Task> _filterTasksByDay({required List<Task> tasks, required DateTime selectedDay}) {
    final filteredTasks = tasks.where((task) => task.deadline.isSameDay(selectedDay)).toList();
    return filteredTasks;
  }

  List<Task> _sortByDeadline({required List<Task> tasks}) {
    tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    return tasks;
  }

  Future<List<Task>> completeTask({required Task task, required List<Task> tasks}) async {
    final completedTask = task.copyWith(completedAt: DateTime.now());
    await taskRepository.completeTask(task: completedTask);
    tasks = _reinsertCompletedTaskToList(task: completedTask, tasks: tasks);
    return _sortByCompletedAt(tasks: tasks);
  }

  List<Task> _reinsertCompletedTaskToList({required Task task, required List<Task> tasks}) {
    final index = tasks.indexWhere((element) => element.title == task.title);
    tasks.removeAt(index);
    tasks.insert(index, task);
    return tasks;
  }

  List<Task> _sortByCompletedAt({required List<Task> tasks}) {
    tasks.sort((a, b) => a.completedAt != null ? 1 : -1);
    return tasks;
  }
}
