import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_diary/common/app_module.dart';
import 'package:nurse_diary/presentation/categories/bloc/categories_cubit.dart';
import 'package:nurse_diary/presentation/categories/screens/categories_screen.dart';
import 'package:nurse_diary/presentation/common/utils/app_themes.dart';
import 'package:nurse_diary/presentation/tasks/bloc/tasks_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) {
            final bloc = injector.get<CategoriesCubit>();
            bloc.getCategories();
            return bloc;
          },
        ),
        BlocProvider(
          lazy: false,
          create: (context) {
            final bloc = injector.get<TasksCubit>();
            bloc.getTasks();
            return bloc;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Nurse Diary',
        theme: AppTheme.themeData(),
        home: const CategoriesScreen(),
      ),
    );
  }
}
