part of '../bloc/categories_cubit.dart';

@immutable
abstract class CategoriesState extends Equatable {
  final List<Category> categories;

  const CategoriesState({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoriesLoading extends CategoriesState {
  CategoriesLoading() : super(categories: []);
}

class CategoriesFailure extends CategoriesState {
  CategoriesFailure() : super(categories: []);
}

class CategoriesInitial extends CategoriesState {
  CategoriesInitial() : super(categories: []);
}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded({required List<Category> categories}) : super(categories: categories);

  CategoriesLoaded copyWith({List<Category>? categories}) {
    return CategoriesLoaded(categories: categories ?? this.categories);
  }
}
