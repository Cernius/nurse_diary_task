import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_diary/domain/models/task.dart';
import 'package:nurse_diary/domain/repositories/task_repository.dart';
import 'package:nurse_diary/presentation/common/utils/extenions.dart';

part '../state/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TaskRepository _taskRepository;

  TasksCubit(this._taskRepository) : super(TasksInitial());

  Future<void> getTasks() async {
    emit(TasksLoading(selectedDay: state.selectedDay));
    try {
      final tasks = await _taskRepository.getTasks();
      emit(TasksLoaded(
        tasks: tasks,
        version: state.version,
      ));
    } catch (e, stacktrace) {
      debugPrint('$e, $stacktrace');
      emit(TasksFailure());
    }
  }

  Future<void> getTasksByCategory(String category) async {
    emit(TasksLoading(selectedDay: state.selectedDay));
    try {
      final tasks = await _taskRepository.getTasksByCategory(category);
      final filteredTasks =
          tasks.where((task) => task.deadline.isSameDay(state.selectedDay)).toList();
      filteredTasks.sort((a, b) => a.deadline.compareTo(b.deadline));
      emit(
        TasksLoaded(
          tasks: state.tasks,
          filteredTasks: filteredTasks,
          selectedDay: state.selectedDay,
          category: category,
          version: state.version,
        ),
      );
    } catch (e, stacktrace) {
      debugPrint('$e, $stacktrace');
      emit(TasksFailure());
    }
  }

  Task completeTask(Task task) {
    try {
      final completedTask = task.copyWith(completedAt: DateTime.now());

      _taskRepository.completeTask(completedTask);

      if (state is TasksLoaded) {
        final filteredTasks = (state as TasksLoaded).filteredTasks ?? [];
        final index = filteredTasks.indexWhere((task) => task.title == completedTask.title);
        filteredTasks.removeAt(index);
        filteredTasks.insert(index, completedTask);
        filteredTasks.sort((a, b) => a.completedAt != null ? 1 : -1);
        emit((state as TasksLoaded).copyWith(
          filteredTasks: filteredTasks,
          version: state.version + 1,
        ));
        return completedTask;
      }
      throw ();
    } catch (e, stacktrace) {
      debugPrint('$e, $stacktrace');
      emit(TasksFailure());
      return task;
    }
  }

  void nextDay() {
    if (state is TasksLoaded) {
      final nextDay = (state as TasksLoaded).selectedDay.add(const Duration(days: 1));
      emit((state as TasksLoaded).copyWith(selectedDay: nextDay));

      getTasksByCategory((state as TasksLoaded).category!);
    }
  }

  void previousDay() {
    if (state is TasksLoaded) {
      final previousDay = (state as TasksLoaded).selectedDay.subtract(const Duration(days: 1));
      emit((state as TasksLoaded).copyWith(selectedDay: previousDay));
      getTasksByCategory((state as TasksLoaded).category!);
    }
  }
}
