import '../datasources/vault_local_data_source.dart';

abstract class VaultRepository {
  Future<void> addNote(String id, String content);
  Future<List<Map<String, String>>> getNotes();
  Future<void> deleteNote(String id);
}

class VaultRepositoryImpl implements VaultRepository {
  final VaultLocalDataSource localDataSource;
  VaultRepositoryImpl(this.localDataSource);

  @override
  Future<void> addNote(String id, String content) async {
    return await localDataSource.saveNote(id, content);
  }

  @override
  Future<List<Map<String, String>>> getNotes() async {
    return await localDataSource.getNotes();
  }

  @override
  Future<void> deleteNote(String id) async {
    return await localDataSource.deleteNote(id);
  }
}
