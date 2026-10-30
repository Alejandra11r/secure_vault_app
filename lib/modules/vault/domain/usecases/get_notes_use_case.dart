import '../../data/repositories/vault_repository_impl.dart';

class GetNotesUseCase {
  final VaultRepository repository;
  GetNotesUseCase(this.repository);

  Future<List<Map<String, String>>> call(String accountId) async {
    return repository.getNotes(accountId);
  }

  Future<String> decrypt(
    String accountId,
    Map<String, String> note,
    List<int> key,
  ) =>
      repository.decryptNote(accountId, note, key);
}
