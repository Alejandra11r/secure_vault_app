import '../../data/repositories/vault_repository_impl.dart';

class GetNotesUseCase {
  final VaultRepository repository;
  GetNotesUseCase(this.repository);

  Future<List<Map<String,String>>> call() async {
    return await repository.getNotes();
  }
}
