import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_diary/domain/models/category.dart';
import 'package:nurse_diary/domain/repositories/category_repository.dart';

part '../states/categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoryRepository categoryRepository;

  CategoriesCubit({required this.categoryRepository}) : super(CategoriesInitial());

  Future<void> getCategories() async {
    emit(CategoriesLoading());
    try {
      final categories = await categoryRepository.getCategories();
      emit(CategoriesLoaded(categories: categories));
    } catch (e, stacktrace) {
      debugPrint('$e, $stacktrace');
      emit(CategoriesFailure());
    }
  }
}
