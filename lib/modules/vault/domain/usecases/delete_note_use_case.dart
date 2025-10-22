import '../../data/repositories/vault_repository_impl.dart';

class DeleteNoteUseCase {
  final VaultRepository repository;
  DeleteNoteUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteNote(id);
  }
}
