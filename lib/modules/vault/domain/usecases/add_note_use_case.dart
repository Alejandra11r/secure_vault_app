import '../../data/repositories/vault_repository_impl.dart';

class AddNoteUseCase {
  final VaultRepository repository;
  AddNoteUseCase(this.repository);

  Future<void> call(String id, String content) async {
    return await repository.addNote(id, content);
  }
}
