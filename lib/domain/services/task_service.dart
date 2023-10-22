import 'package:nurse_diary/domain/models/task.dart';
import 'package:nurse_diary/domain/repositories/task_repository.dart';
import 'package:nurse_diary/presentation/common/utils/extenions.dart';

class TaskService {
  final TaskRepository taskRepository;

  TaskService({required this.taskRepository});

  Future<List<Task>> getTasksByCategory({
    required String category,
    required DateTime selectedDay,
  }) async {
    final tasks = await taskRepository.getTasksByCategory(category: category);

    return _filterTasksByDayAndSort(tasks: tasks, selectedDay: selectedDay);
  }

  List<Task> _filterTasksByDayAndSort({required List<Task> tasks, required DateTime selectedDay}) {
    final filteredTasks = tasks.where((task) => task.deadline.isSameDay(selectedDay)).toList();
    filteredTasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    return filteredTasks;
  }

  Future<List<Task>> completeTask({required Task task, required List<Task> tasks}) async {
    final completedTask = task.copyWith(completedAt: DateTime.now());
    await taskRepository.completeTask(task: completedTask);
    tasks = _reinsertCompletedTaskToListAndSort(task: completedTask, tasks: tasks);
    return tasks;
  }

  List<Task> _reinsertCompletedTaskToListAndSort({required Task task, required List<Task> tasks}) {
    final index = tasks.indexWhere((element) => element.title == task.title);
    tasks.removeAt(index);
    tasks.insert(index, task);
    tasks.sort((a, b) => a.completedAt != null ? 1 : -1);
    return tasks;
  }
}
