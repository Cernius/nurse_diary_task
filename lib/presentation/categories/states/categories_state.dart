part of '../bloc/categories_cubit.dart';

@immutable
abstract class CategoriesState extends Equatable{
  final List<Category> categories;

  const CategoriesState(this.categories);

  @override
  List<Object> get props => [categories];
}
class CategoriesLoading extends CategoriesState {
  CategoriesLoading() : super([]);
}
class CategoriesFailure extends CategoriesState {
  CategoriesFailure() : super([]);
}
class CategoriesInitial extends CategoriesState {
  CategoriesInitial() : super([]);
}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded({required List<Category> categories}) : super(categories);

  CategoriesLoaded copyWith({List<Category>? categories}) {
    return CategoriesLoaded(categories: categories ?? this.categories);
  }
}
