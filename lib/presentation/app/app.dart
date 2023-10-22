import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_diary/common/app_module.dart';
import 'package:nurse_diary/presentation/categories/bloc/categories_cubit.dart';
import 'package:nurse_diary/presentation/categories/screens/categories_screen.dart';
import 'package:nurse_diary/presentation/common/utils/app_themes.dart';
import 'package:nurse_diary/presentation/tasks/bloc/tasks_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => injector.get<CategoriesCubit>(),
        ),
        BlocProvider(
          create: (context) => injector.get<TasksCubit>(),
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
