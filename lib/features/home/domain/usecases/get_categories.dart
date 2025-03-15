import 'package:flareup/features/home/domain/entities/category_entity.dart';
import 'package:flareup/features/home/domain/repositories/event_repository.dart';

class GetCategories {
  final EventRepositoryDomain repository;

  GetCategories(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}
