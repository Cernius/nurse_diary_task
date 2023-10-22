import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurse_diary/domain/categories/models/category.dart';
import 'package:nurse_diary/domain/categories/repositories/category_repository.dart';
import 'package:nurse_diary/presentation/categories/bloc/categories_cubit.dart';

class MockCategoriesRepository extends Mock implements CategoryRepository {}

void main() {
  group('CategoriesCubit', () {
    late CategoriesCubit categoriesBloc;
    late CategoryRepository repository;
    final categoriesResponse = [
      Category(
        name: "Medication",
        description: "Prescribe medication",
        color: Colors.black,
        icon: "Pill",
      ),
      Category(
        name: "Treatment",
        description: "Treat patient",
        color: Colors.black,
        icon: "Treatment",
      ),
    ];

    setUp(() async {
      repository = MockCategoriesRepository();
      categoriesBloc = CategoriesCubit(categoryRepository: repository);
    });

    test('Initial State is CategoriesInitial', () {
      expect(categoriesBloc.state, CategoriesInitial());
    });

    group('Get Categories', () {
      blocTest<CategoriesCubit, CategoriesState>(
        'emits [CategoriesLoading, CategoriesLoaded] when successful',
        setUp: () => when(repository.getCategories).thenAnswer((_) async => categoriesResponse),
        build: () => categoriesBloc,
        act: (bloc) {
          bloc.getCategories();
        },
        expect: () => <CategoriesState>[
          CategoriesLoading(),
          CategoriesLoaded(categories: categoriesResponse),
        ],
      );
      blocTest<CategoriesCubit, CategoriesState>(
        'emits [loading, failure] '
        'when getCategories fails',
        setUp: () => when(repository.getCategories).thenThrow(Exception()),
        build: () => categoriesBloc,
        act: (bloc) {
          bloc.getCategories();
        },
        expect: () => <CategoriesState>[
          CategoriesLoading(),
          CategoriesFailure(),
        ],
      );
    });
  });
}
