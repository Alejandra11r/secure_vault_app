import '../../data/repositories/vault_repository_impl.dart';

class AddNoteUseCase {
  final VaultRepository repository;
  AddNoteUseCase(this.repository);

  Future<void> call(String accountId, String id, String content, List<int> key,
      {String? categoryId,}) async {
    await repository.addNote(accountId, id, content, key,
        categoryId: categoryId,);
  }
}
