import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurse_diary/domain/models/task.dart';
import 'package:nurse_diary/domain/services/task_service.dart';
import 'package:nurse_diary/presentation/tasks/bloc/tasks_cubit.dart';

class MockTasksService extends Mock implements TaskService {}

void main() {
  group('TasksCubit', () {
    late TasksCubit tasksCubit;
    late TaskService taskService;
    final taskToComplete = Task(
      title: 'Task to complete',
      description: 'Task to complete description',
      deadline: DateTime.now(),
      priority: 'Maximum',
      involvesPatient: true,
      category: 'Medication',
      completedAt: null,
    );
    final randomTask = Task(
      title: 'pills',
      description: 'give pills to patient',
      deadline: DateTime(2023, 08, 23),
      priority: 'Max',
      involvesPatient: true,
      category: 'Medication',
    );

    final getTasksByCategoryResponse = [
      randomTask,
      taskToComplete,
    ];

    setUp(() async {
      taskService = MockTasksService();
      tasksCubit = TasksCubit(taskService: taskService);
    });

    test('Initial State is TasksInitial', () {
      expect(tasksCubit.state, TasksInitial());
    });

    group('Get Tasks By Category', () {
      blocTest<TasksCubit, TasksState>(
        'emits [TasksLoading, TasksLoaded] when successful',
        setUp: () => when(
          () => taskService.getTasksByCategory(
            category: any(named: 'category'),
            selectedDay: any(named: 'selectedDay'),
          ),
        ).thenAnswer((_) async => getTasksByCategoryResponse),
        build: () => tasksCubit,
        act: (bloc) {
          bloc.getTasksByCategory('Medication');
        },
        expect: () => <Matcher>[
          isA<TasksLoading>(),
          isA<TasksLoaded>(),
        ],
      );

      blocTest<TasksCubit, TasksState>(
        'emits [TasksLoading, TasksFailure] on error',
        setUp: () {
          when(
            () => taskService.getTasksByCategory(
              category: any(named: 'category'),
              selectedDay: any(named: 'selectedDay'),
            ),
          ).thenThrow(Exception('An error occurred'));
        },
        build: () => tasksCubit,
        act: (bloc) {
          bloc.getTasksByCategory('Category');
        },
        expect: () => <Matcher>[
          isA<TasksLoading>(),
          isA<TasksFailure>(),
        ],
      );
    });
    group('completeTask', () {
      blocTest<TasksCubit, TasksState>(
        'emits [TasksLoading, TasksLoaded] when task is successfully completed',
        build: () => tasksCubit,
        seed: () => TasksLoaded(
          filteredTasks: getTasksByCategoryResponse,
          version: 0,
          selectedDay: DateTime(2023, 08, 23),
          category: 'Medication',
        ),
        setUp: () {
          when(
            () => taskService.completeTask(
              task: taskToComplete,
              tasks: getTasksByCategoryResponse,
            ),
          ).thenAnswer((_) async {
            return getTasksByCategoryResponse;
          });
        },
        act: (bloc) {
          bloc.completeTask(taskToComplete);
        },
        expect: () {
          return [isA<TasksLoaded>()];
        },
      );
      blocTest<TasksCubit, TasksState>(
        'emits [TasksFailure] on error',
        seed: () => TasksLoaded(
          filteredTasks: getTasksByCategoryResponse,
          version: 0,
          selectedDay: DateTime(2023, 08, 23),
          category: 'Medication',
        ),
        setUp: () {
          when(
                () => taskService.completeTask(
              task: taskToComplete,
              tasks: getTasksByCategoryResponse,
            ),
          ).thenThrow(Exception('An error occurred'));
        },
        build: () => tasksCubit,
        act: (bloc) {
          bloc.completeTask(taskToComplete);
        },
        expect: () => <Matcher>[
          isA<TasksFailure>(),
        ],
      );
    });
  });
}
