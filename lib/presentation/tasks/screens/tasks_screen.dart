import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nurse_diary/domain/tasks/models/task.dart';
import 'package:nurse_diary/presentation/common/widgets/list_tile_widget.dart';
import 'package:nurse_diary/presentation/tasks/bloc/tasks_cubit.dart';

class TasksScreen extends StatelessWidget {
  final String category;

  const TasksScreen(this.category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<TasksCubit>().getPreviousDayTasks();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              if (state is TasksLoaded) {
                return Text(
                  DateFormat('dd/MM/yyyy').format((state).selectedDay),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          IconButton(
            onPressed: () {
              context.read<TasksCubit>().getNextDayTasks();
            },
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              if (state is TasksLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TasksFailure) {
                return const Center(
                  child: Text("Failed to load tasks"),
                );
              } else if (state is TasksLoaded && state.filteredTasks.isEmpty) {
                return const Center(
                  child: Text("No tasks found"),
                );
              }
              state as TasksLoaded;
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final task = state.filteredTasks[index];
                  return _BuildListTile(task: task);
                  // return ListTile(
                  //     title: Text(task.title),
                  //     subtitle: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(task.description),
                  //         Text(DateFormat('dd/MM/yyyy').format(task.deadline)),
                  //         if (task.completedAt != null)
                  //           Text(
                  //               'Completed at: ${DateFormat('dd/MM/yyyy HH:mm').format(task.completedAt!)}'),
                  //       ],
                  //     ),
                  //     trailing: CupertinoSwitch(
                  //       value: task.completedAt != null,
                  //       onChanged: (value) {
                  //         context.read<TasksCubit>().completeTask(task);
                  //       },
                  //     ));
                },
                itemCount: state.filteredTasks.length,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BuildListTile extends StatelessWidget {
  final Task task;

  const _BuildListTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTileWidget(
      onTap: () => context.read<TasksCubit>().completeTask(task),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: task.completedAt != null ? Colors.grey : Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            task.description,
            style: TextStyle(
              color: task.completedAt != null ? Colors.grey : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Deadline: ${DateFormat('dd/MM/yyyy').format(task.deadline)}',
            style: TextStyle(
              color: task.completedAt != null ? Colors.grey : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            task.completedAt == null
                ? 'Active'
                : 'Completed at: ${DateFormat('dd/MM/yyyy HH:mm').format(task.completedAt!)}',
            style: TextStyle(
              color: task.completedAt != null ? Colors.grey : Colors.green,
            ),
          ),
          if (task.involvesPatient) const SizedBox(height: 4),
          if (task.involvesPatient)
            Text(
              'Involves patient',
              style: TextStyle(
                color: task.completedAt != null ? Colors.grey : Colors.black,
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
