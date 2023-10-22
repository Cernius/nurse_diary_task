import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_diary/domain/models/category.dart';
import 'package:nurse_diary/presentation/categories/bloc/categories_cubit.dart';
import 'package:nurse_diary/presentation/common/widgets/list_tile_widget.dart';
import 'package:nurse_diary/presentation/tasks/bloc/tasks_cubit.dart';
import 'package:nurse_diary/presentation/tasks/screens/tasks_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  initState() {
    super.initState();
    context.read<CategoriesCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state is CategoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CategoriesFailure) {
                  return const Center(child: Text('Failed to load categories'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return _BuildListTile(category: category);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildListTile extends StatelessWidget {
  final Category category;

  const _BuildListTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return ListTileWidget(
      onTap: () {
        context.read<TasksCubit>().getTasksByCategory(category.name);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TasksScreen(category.name),
          ),
        );
      },
      // color: category.color,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: category.color,
            ),
            height: 15,
            width: 15,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.description,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
