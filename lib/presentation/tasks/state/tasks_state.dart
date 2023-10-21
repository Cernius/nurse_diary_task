part of '../bloc/tasks_cubit.dart';

abstract class TasksState extends Equatable {
  final List<Task> tasks;
  final DateTime selectedDay;
  final String? category;
  final List<Task>? filteredTasks;
  final int version;

  const TasksState({
    required this.tasks,
    required this.selectedDay,
    this.category,
    this.filteredTasks,
    this.version = 0,
  });

  @override
  List<Object?> get props => [tasks, selectedDay, category, filteredTasks, version];
}

class TasksInitial extends TasksState {
  TasksInitial() : super(tasks: [], selectedDay: DateTime(2023, 08, 23));
}

class TasksLoading extends TasksState {
  TasksLoading({DateTime? selectedDay})
      : super(
          tasks: [],
          selectedDay: selectedDay ?? DateTime(2023, 08, 23),
        );
}

class TasksFailure extends TasksState {
  TasksFailure() : super(tasks: [], selectedDay: DateTime(2023, 08, 23));
}

class TasksLoaded extends TasksState {
  TasksLoaded({
    required List<Task> tasks,
    List<Task>? filteredTasks,
    String? category,
    DateTime? selectedDay,
    required int version,
  }) : super(
          tasks: tasks,
          selectedDay: selectedDay ?? DateTime(2023, 08, 23),
          category: category,
          filteredTasks: filteredTasks,
          version: version,
        );

  TasksLoaded copyWith({
    List<Task>? filteredTasks,
    DateTime? selectedDay,
    String? category,
    int? version,
  }) {
    return TasksLoaded(
      tasks: tasks,
      filteredTasks: this.filteredTasks,
      selectedDay: selectedDay ?? this.selectedDay,
      category: category ?? this.category,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [tasks, selectedDay, category, filteredTasks, version];
}
