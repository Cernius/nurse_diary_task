import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurse_diary/domain/models/task.dart';
import 'package:nurse_diary/domain/repositories/task_repository.dart';
import 'package:nurse_diary/presentation/tasks/bloc/tasks_cubit.dart';

class MockTasksRepository extends Mock implements TaskRepository {}

void main() {
  group('TasksCubit', () {
    late TasksCubit tasksCubit;
    late TaskRepository taskRepository;
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
    final getTasksResponse = [
      randomTask,
      taskToComplete,
    ];
    final getTasksByCategoryResponse = [
      randomTask,
      taskToComplete,
    ];

    setUp(() async {
      taskRepository = MockTasksRepository();
      tasksCubit = TasksCubit(taskRepository);
    });

    test('Initial State is TasksInitial', () {
      expect(tasksCubit.state, TasksInitial());
    });

    group('Get Tasks', () {
      blocTest<TasksCubit, TasksState>(
        'emits [TasksLoading, TasksLoaded] when successful',
        setUp: () => when(taskRepository.getTasks).thenAnswer((_) async => getTasksResponse),
        build: () => tasksCubit,
        act: (bloc) {
          bloc.getTasks();
        },
        expect: () => <Matcher>[
          isA<TasksLoading>(),
          isA<TasksLoaded>(),
        ],
      );

      blocTest<TasksCubit, TasksState>(
        'emits [TasksLoading, TasksFailure] '
        'when getTasks fails',
        setUp: () => when(taskRepository.getTasks).thenThrow(Exception()),
        build: () => tasksCubit,
        act: (bloc) {
          bloc.getTasks();
        },
        expect: () => <Matcher>[
          isA<TasksLoading>(),
          isA<TasksFailure>(),
        ],
      );
    });
    group('Get Tasks By Category', () {
      blocTest<TasksCubit, TasksState>(
        'emits [TasksLoading, TasksLoaded] when successful',
        setUp: () => when(
          () => taskRepository.getTasksByCategory(any()),
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

      group('Get Tasks By Category', () {
        blocTest<TasksCubit, TasksState>(
          'emits [TasksLoading, TasksFailure] on error',
          setUp: () {
            when(() => taskRepository.getTasksByCategory(any())).thenThrow(Exception());
          },
          build: () => tasksCubit,
          act: (bloc) {
            bloc.getTasksByCategory('Medication');
          },
          expect: () => <Matcher>[
            isA<TasksLoading>(),
            isA<TasksFailure>(),
          ],
        );
        blocTest<TasksCubit, TasksState>(
          'emits [TasksLoading, TasksFailure] on error',
          setUp: () {
            when(() => taskRepository.getTasksByCategory(any()))
                .thenThrow(Exception('An error occurred'));
          },
          build: () => tasksCubit,
          act: (bloc) {
            bloc.getTasks();
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
            tasks: getTasksResponse,
            filteredTasks: getTasksByCategoryResponse,
            version: 0,
            selectedDay: DateTime(2023, 08, 23),
            category: 'Medication',
          ),
          setUp: () {
            when(() => taskRepository.completeTask(taskToComplete)).thenAnswer((_) async {});
          },
          act: (bloc) {
            when(() => taskRepository.completeTask(taskToComplete)).thenAnswer((_) async {});

            bloc.completeTask(taskToComplete);
          },
          expect: () {
            return [isA<TasksLoaded>()];
          },
        );
        blocTest<TasksCubit, TasksState>(
          'returns completedTask with non-null completedAt',
          build: () => tasksCubit,
          seed: () => TasksLoaded(
            tasks: getTasksResponse,
            filteredTasks: getTasksByCategoryResponse,
            version: 0,
            selectedDay: DateTime(2023, 08, 23),
            category: 'Medication',
          ),
          act: (bloc) {
            final completedTask = bloc.completeTask(taskToComplete);

            expect(completedTask, isNotNull);
            expect(completedTask?.completedAt, isNotNull);
          },
        );
        blocTest<TasksCubit, TasksState>(
          'emits [TasksLoading, TasksFailure] when an error occurs',
          build: () => tasksCubit,
          act: (bloc) {
            when(() => taskRepository.completeTask(taskToComplete)).thenThrow(Exception());
            bloc.completeTask(taskToComplete);
          },
          expect: () => <Matcher>[
            isA<TasksFailure>(),
          ],
        );
      });
    });
  });
}
