import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_diary/domain/tasks/models/task.dart';
import 'package:nurse_diary/domain/tasks/services/task_service.dart';

part '../state/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TaskService taskService;

  TasksCubit({required this.taskService}) : super(TasksInitial());

  Future<void> getTasksByCategory(String category) async {
    emit(TasksLoading(selectedDay: state.selectedDay));
    try {
      final filteredTasks = await taskService.getTasksByCategory(
        category: category,
        selectedDay: state.selectedDay,
      );
      emit(
        TasksLoaded(
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

  Future<void> completeTask(Task task) async {
    try {
      if (state is TasksLoaded) {
        final tasks = await taskService.completeTask(
          task: task,
          tasks: state.filteredTasks,
        );

        emit(
          (state as TasksLoaded).copyWith(
            filteredTasks: tasks,
            version: state.version + 1,
          ),
        );
      }
    } catch (e, stacktrace) {
      debugPrint('$e, $stacktrace');
      print('catch');
      emit(TasksFailure());
    }
  }

  void getNextDayTasks() {
    if (state.category == null) {
      emit(TasksFailure());
      return;
    }
    if (state is TasksLoaded) {
      final nextDay = state.selectedDay.add(const Duration(days: 1));
      emit((state as TasksLoaded).copyWith(selectedDay: nextDay));
      getTasksByCategory(state.category!);
    }
  }

  void getPreviousDayTasks() {
    if (state.category == null) {
      emit(TasksFailure());
      return;
    }
    if (state is TasksLoaded) {
      final previousDay = state.selectedDay.subtract(const Duration(days: 1));
      emit((state as TasksLoaded).copyWith(selectedDay: previousDay));
      getTasksByCategory(state.category!);
    }
  }
}
