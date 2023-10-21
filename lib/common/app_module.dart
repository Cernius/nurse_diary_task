import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:nurse_diary/data/mappers/category_mapper.dart';
import 'package:nurse_diary/data/mappers/task_mapper.dart';
import 'package:nurse_diary/data/repositories/category_repository_impl.dart';
import 'package:nurse_diary/data/repositories/preference_repository_impl.dart';
import 'package:nurse_diary/data/repositories/task_repository_impl.dart';
import 'package:nurse_diary/data/server_api.dart';
import 'package:nurse_diary/data/services/logger_impl.dart';
import 'package:nurse_diary/domain/repositories/category_repository.dart';
import 'package:nurse_diary/domain/repositories/preference_repository.dart';
import 'package:nurse_diary/domain/repositories/task_repository.dart';
import 'package:nurse_diary/domain/services/logger.dart';
import 'package:nurse_diary/presentation/categories/bloc/categories_cubit.dart';
import 'package:nurse_diary/presentation/tasks/bloc/tasks_cubit.dart';

class AppModule {
  Injector initialise(Injector injector) {
    injector.map<Logger>(
      (i) => LoggerImpl(),
      isSingleton: true,
    );

    injector.map<PreferenceRepository>((i) => PreferenceRepositoryImpl(), isSingleton: true);
    injector.map<ServerApi>((i) => ServerApi(i.get<PreferenceRepository>(), i.get<Logger>()));
    injector.map<CategoryRepository>(
      (i) => CategoryRepositoryImpl(
        i.get<ServerApi>(),
        i.get<CategoryMapper>(),
      ),
      isSingleton: true,
    );
    injector.map<TaskRepository>(
      (i) => TaskRepositoryImpl(
        i.get<ServerApi>(),
        i.get<TaskMapper>(),
      ),
      isSingleton: true,
    );
    injector.map<CategoriesCubit>((i) => CategoriesCubit(i.get<CategoryRepository>()));
    injector.map<CategoryMapper>((i) => CategoryMapper());
    injector.map<TaskMapper>((i) => TaskMapper());
    injector.map<TasksCubit>((i) => TasksCubit(i.get<TaskRepository>()), isSingleton: true);

    return injector;
  }
}

Injector injector = AppModule().initialise(Injector());
