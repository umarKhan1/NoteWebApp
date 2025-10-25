import '../repositories/notes_repository.dart';

/// Use case for getting all available categories
class GetCategoriesUseCase {
  /// Creates a new instance of [GetCategoriesUseCase]
  const GetCategoriesUseCase(this._repository);
  final NotesRepository _repository;

  /// Execute the use case to get all categories
  Future<List<String>> call() async {
    return await _repository.getCategories();
  }
}
