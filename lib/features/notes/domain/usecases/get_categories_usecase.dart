import '../repositories/notes_repository.dart';

/// Use case for getting all available categories
class GetCategoriesUseCase {
  final NotesRepository _repository;

  /// Creates a new instance of [GetCategoriesUseCase]
  const GetCategoriesUseCase(this._repository);

  /// Execute the use case to get all categories
  Future<List<String>> call() async {
    return await _repository.getCategories();
  }
}
