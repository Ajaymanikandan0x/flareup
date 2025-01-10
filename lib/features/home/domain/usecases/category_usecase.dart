import '../repositories/event_repository.dart';
import '../entities/category_entity.dart';

class CategoriesUseCase {
  final EventRepositoryDomain repository;

  CategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() {
    return repository.getCategories();
  }
}