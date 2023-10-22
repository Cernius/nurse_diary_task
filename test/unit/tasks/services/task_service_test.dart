import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurse_diary/domain/tasks/models/task.dart';
import 'package:nurse_diary/domain/tasks/repositories/task_repository.dart';
import 'package:nurse_diary/domain/tasks/services/task_service.dart';


class MockTasksRepository extends Mock implements TaskRepository {}

void main() {
  group('Task Service', () {
    late TaskService taskService;
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

    final getTasksByCategoryResponse = [
      randomTask,
      taskToComplete,
    ];

    setUp(() async {
      taskRepository = MockTasksRepository();
      taskService = TaskService(taskRepository: taskRepository);
    });

    group('Get Tasks By Category', () {
      test('returns tasks for selected day and category when successful', () async {
        when(
          () => taskRepository.getTasksByCategory(
            category: any(named: 'category'),
          ),
        ).thenAnswer((_) async => getTasksByCategoryResponse);
        final tasks = await taskService.getTasksByCategory(
          category: 'Medication',
          selectedDay: DateTime(2023, 08, 23),
        );
        expect(tasks, [randomTask]);
      });
      test('returns empty when no match found', () async {
        when(
          () => taskRepository.getTasksByCategory(
            category: any(named: 'category'),
          ),
        ).thenAnswer((_) async => getTasksByCategoryResponse);
        final tasks = await taskService.getTasksByCategory(
          category: 'Medication',
          selectedDay: DateTime(2023, 08, 20),
        );
        expect(tasks, []);
      });
      test('throws exception when unsuccessful', () async {
        when(
          () => taskRepository.getTasksByCategory(
            category: any(named: 'category'),
          ),
        ).thenThrow(Exception());
        expect(
          () => taskService.getTasksByCategory(
            category: 'Medication',
            selectedDay: DateTime(2023, 08, 23),
          ),
          throwsException,
        );
      });
    });
  });
}
