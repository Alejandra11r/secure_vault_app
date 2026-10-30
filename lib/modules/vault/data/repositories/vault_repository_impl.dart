import '../datasources/vault_local_data_source.dart';

abstract class VaultRepository {
  Future<void> addNote(
      String accountId, String id, String content, List<int> key,
      {String? categoryId,});
  Future<void> updateNote(
      String accountId, String id, String content, List<int> key,
      {String? categoryId,});
  Future<List<Map<String, String>>> getNotes(String accountId);
  Future<String> decryptNote(
    String accountId,
    Map<String, String> note,
    List<int> key,
  );
  Future<String?> noteCategoryId(
      String accountId, Map<String, String> note, List<int> key,);
  Future<void> deleteNote(String accountId, String id);
  Future<void> saveCategory(
      String accountId, String id, String name, List<int> key,);
  Future<List<Map<String, String>>> getCategories(String accountId);
  Future<String> decryptCategory(
      String accountId, Map<String, String> category, List<int> key,);
  Future<void> deleteCategory(String accountId, String id, List<int> key);
  Future<void> saveFile(String accountId, String id, String name,
      String mimeType, List<int> bytes, List<int> key,);
  Future<List<Map<String, Object>>> getFiles(String accountId);
  Future<Map<String, Object>> decryptFile(
      String accountId, Map<String, Object> item, List<int> key,);
  Future<Map<String, Object>> decryptFileMetadata(
      String accountId, Map<String, Object> item, List<int> key,);
  Future<void> deleteFile(String accountId, String id);
}

class VaultRepositoryImpl implements VaultRepository {
  final VaultLocalDataSource localDataSource;
  VaultRepositoryImpl(this.localDataSource);

  @override
  Future<void> addNote(
      String accountId, String id, String content, List<int> key,
      {String? categoryId,}) async {
    await localDataSource.saveNote(
      accountId: accountId,
      id: id,
      plainText: content,
      vaultKey: key,
      categoryId: categoryId,
    );
  }

  @override
  Future<void> updateNote(
          String accountId, String id, String content, List<int> key,
          {String? categoryId,}) =>
      addNote(accountId, id, content, key, categoryId: categoryId);

  @override
  Future<List<Map<String, String>>> getNotes(String accountId) async {
    return localDataSource.getNotes(accountId);
  }

  @override
  Future<String> decryptNote(
    String accountId,
    Map<String, String> note,
    List<int> key,
  ) =>
      localDataSource.decryptNote(
        accountId: accountId,
        note: note,
        vaultKey: key,
      );

  @override
  Future<String?> noteCategoryId(
          String accountId, Map<String, String> note, List<int> key,) =>
      localDataSource.decryptNoteCategoryId(
          accountId: accountId, note: note, vaultKey: key,);

  @override
  Future<void> deleteNote(String accountId, String id) async {
    await localDataSource.deleteNote(accountId, id);
  }

  @override
  Future<void> saveCategory(
          String accountId, String id, String name, List<int> key,) =>
      localDataSource.saveCategory(
          accountId: accountId, id: id, name: name, vaultKey: key,);
  @override
  Future<List<Map<String, String>>> getCategories(String accountId) =>
      localDataSource.getCategories(accountId);
  @override
  Future<String> decryptCategory(
          String accountId, Map<String, String> item, List<int> key,) =>
      localDataSource.decryptCategory(accountId, item, key);
  @override
  Future<void> deleteCategory(String accountId, String id, List<int> key) =>
      localDataSource.deleteCategory(accountId, id, key);
  @override
  Future<void> saveFile(String accountId, String id, String name,
          String mimeType, List<int> bytes, List<int> key,) =>
      localDataSource.saveFile(
          accountId: accountId,
          id: id,
          name: name,
          mimeType: mimeType,
          bytes: bytes,
          vaultKey: key,);
  @override
  Future<List<Map<String, Object>>> getFiles(String accountId) =>
      localDataSource.getFiles(accountId);
  @override
  Future<Map<String, Object>> decryptFile(
          String accountId, Map<String, Object> item, List<int> key,) =>
      localDataSource.decryptFile(accountId, item, key);
  @override
  Future<Map<String, Object>> decryptFileMetadata(
          String accountId, Map<String, Object> item, List<int> key,) =>
      localDataSource.decryptFileMetadata(accountId, item, key);
  @override
  Future<void> deleteFile(String accountId, String id) =>
      localDataSource.deleteFile(accountId, id);
}
