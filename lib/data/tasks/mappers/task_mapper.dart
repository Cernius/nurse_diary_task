import 'package:nurse_diary/data/tasks/models/task_dto.dart';
import 'package:nurse_diary/domain/shared/mapper.dart';
import 'package:nurse_diary/domain/tasks/models/task.dart';

class TaskMapper extends Mapper<TaskDTO, Task> {
  @override
  Task map(TaskDTO input) {
    return Task(
      title: input.title,
      description: input.description,
      deadline: input.deadline,
      priority: input.priority,
      involvesPatient: input.involvesPatient,
      category: input.category,
    );
  }

  String mapListToString(List<Task> tasks) {
    return tasks.map((task) => mapToString(task)).join(',');
  }

  String mapToString(Task task) {
    return '${task.title},${task.description},${task.deadline},${task.priority},'
        '${task.involvesPatient},${task.category},${task.completedAt?.toIso8601String()}';
  }

  List<Task> mapListFromString(String taskString) {
    final taskDataList = taskString.split(',');
    final tasks = <Task>[];
    for (var i = 0; i < taskDataList.length; i += 7) {
      tasks.add(
        Task(
          title: taskDataList[i],
          description: taskDataList[i + 1],
          deadline: DateTime.parse(taskDataList[i + 2]),
          priority: taskDataList[i + 3],
          involvesPatient: taskDataList[i + 4] == 'true',
          category: taskDataList[i + 5],
          completedAt: taskDataList[i + 6] != 'null' ? DateTime.parse(taskDataList[i + 6]) : null,
        ),
      );
    }
    return tasks;
  }
}
