import '../../data/repositories/vault_repository_impl.dart';

class DeleteNoteUseCase {
  final VaultRepository repository;
  DeleteNoteUseCase(this.repository);

  Future<void> call(String accountId, String id) async {
    await repository.deleteNote(accountId, id);
  }
}
