import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/usecases/add_note_use_case.dart';
import '../../domain/usecases/get_notes_use_case.dart';
import '../../domain/usecases/delete_note_use_case.dart';
import '../../data/repositories/vault_repository_impl.dart';

class VaultProvider extends ChangeNotifier {
  final AddNoteUseCase addNote;
  final GetNotesUseCase getNotesUseCase;
  final DeleteNoteUseCase deleteNote;
  List<Map<String, String>> notes = [];
  List<Map<String, String>> categories = [];
  List<Map<String, Object>> files = [];
  final VaultRepository repository;
  String? _activeAccountId;
  int _loadGeneration = 0;
  bool _isWriting = false;
  int _externalActivityCount = 0;
  bool get isWriting => _isWriting;
  bool get hasExternalActivity => _externalActivityCount > 0;

  void beginExternalActivity() => _externalActivityCount++;

  void endExternalActivity() {
    if (_externalActivityCount > 0) _externalActivityCount--;
  }

  VaultProvider({
    required this.addNote,
    required this.getNotesUseCase,
    required this.deleteNote,
    required this.repository,
  });

  Future<void> loadNotes(String accountId) async {
    if (_activeAccountId != accountId) return;
    final generation = ++_loadGeneration;
    final result = await getNotesUseCase(accountId);
    final loadedCategories = await repository.getCategories(accountId);
    final loadedFiles = await repository.getFiles(accountId);
    if (generation != _loadGeneration || _activeAccountId != accountId) return;
    notes = result;
    categories = loadedCategories;
    files = loadedFiles;
    notifyListeners();
  }

  void activateAccount(String? accountId) {
    if (_activeAccountId == accountId) return;
    _activeAccountId = accountId;
    _loadGeneration++;
    notes = [];
    categories = [];
    files = [];
  }

  Future<void> addNew(String accountId, List<int> key, String content,
      {String? categoryId,}) async {
    if (_activeAccountId != accountId || _isWriting) return;
    _isWriting = true;
    notifyListeners();
    try {
      final id = const Uuid().v4();
      await addNote(accountId, id, content, key, categoryId: categoryId);
      if (_activeAccountId == accountId) await loadNotes(accountId);
    } finally {
      _isWriting = false;
      notifyListeners();
    }
  }

  Future<void> editNote(
      String accountId, List<int> key, String id, String content,
      {String? categoryId,}) async {
    if (_activeAccountId != accountId || _isWriting) return;
    _isWriting = true;
    notifyListeners();
    try {
      await repository.updateNote(accountId, id, content, key,
          categoryId: categoryId,);
      if (_activeAccountId == accountId) await loadNotes(accountId);
    } finally {
      _isWriting = false;
      notifyListeners();
    }
  }

  Future<String> decrypt(
    String accountId,
    List<int> key,
    Map<String, String> item,
  ) async {
    return getNotesUseCase.decrypt(accountId, item, key);
  }

  Future<String?> noteCategoryId(
          String accountId, List<int> key, Map<String, String> item,) =>
      repository.noteCategoryId(accountId, item, key);

  Future<void> remove(String accountId, String id) async {
    if (_activeAccountId != accountId || _isWriting) return;
    _isWriting = true;
    notifyListeners();
    try {
      await deleteNote(accountId, id);
      if (_activeAccountId == accountId) await loadNotes(accountId);
    } finally {
      _isWriting = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(String accountId, List<int> key, String name) async {
    if (_activeAccountId != accountId || _isWriting) return;
    _isWriting = true;
    notifyListeners();
    try {
      await repository.saveCategory(accountId, const Uuid().v4(), name, key);
      if (_activeAccountId == accountId) await loadNotes(accountId);
    } finally {
      _isWriting = false;
      notifyListeners();
    }
  }

  Future<void> renameCategory(
      String accountId, List<int> key, String id, String name,) async {
    if (_activeAccountId != accountId || _isWriting) return;
    _isWriting = true;
    notifyListeners();
    try {
      await repository.saveCategory(accountId, id, name, key);
      if (_activeAccountId == accountId) await loadNotes(accountId);
    } finally {
      _isWriting = false;
      notifyListeners();
    }
  }

  Future<String> categoryName(
          String accountId, Map<String, String> item, List<int> key,) =>
      repository.decryptCategory(accountId, item, key);

  Future<void> removeCategory(
      String accountId, String id, List<int> key,) async {
    if (_activeAccountId != accountId || _isWriting) return;
    _isWriting = true;
    notifyListeners();
    try {
      await repository.deleteCategory(accountId, id, key);
      if (_activeAccountId == accountId) await loadNotes(accountId);
    } finally {
      _isWriting = false;
      notifyListeners();
    }
  }

  Future<void> addFile(String accountId, List<int> key, String name,
      String mimeType, List<int> bytes,) async {
    if (_activeAccountId != accountId || _isWriting) return;
    _isWriting = true;
    notifyListeners();
    try {
      await repository.saveFile(
          accountId, const Uuid().v4(), name, mimeType, bytes, key,);
      if (_activeAccountId == accountId) await loadNotes(accountId);
    } finally {
      _isWriting = false;
      notifyListeners();
    }
  }

  Future<Map<String, Object>> openFile(
          String accountId, Map<String, Object> item, List<int> key,) =>
      repository.decryptFile(accountId, item, key);

  Future<Map<String, Object>> fileMetadata(
          String accountId, Map<String, Object> item, List<int> key,) =>
      repository.decryptFileMetadata(accountId, item, key);

  Future<void> removeFile(String accountId, String id) async {
    if (_activeAccountId != accountId || _isWriting) return;
    _isWriting = true;
    notifyListeners();
    try {
      await repository.deleteFile(accountId, id);
      if (_activeAccountId == accountId) await loadNotes(accountId);
    } finally {
      _isWriting = false;
      notifyListeners();
    }
  }
}
