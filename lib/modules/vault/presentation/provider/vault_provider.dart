import 'package:flutter/material.dart';
import 'package:secure_vault_app/core/security/encryption_service.dart';
import '../../domain/usecases/add_note_use_case.dart';
import '../../domain/usecases/get_notes_use_case.dart';
import '../../domain/usecases/delete_note_use_case.dart';

class VaultProvider extends ChangeNotifier {
  final AddNoteUseCase addNote;
  final GetNotesUseCase getNotesUseCase;
  final DeleteNoteUseCase deleteNote;
  final _enc = EncryptionService();

  List<Map<String, String>> notes = [];

  VaultProvider(
      {required this.addNote,
      required this.getNotesUseCase,
      required this.deleteNote});

  Future<void> loadNotes() async {
    notes = await getNotesUseCase();
    notifyListeners();
  }

  Future<void> addNew(String content) async {
    final id = notes.length.toString();
    await addNote(id, content);
    await loadNotes();
  }

  Future<String> decrypt(Map<String, String> item) async {
    final plain = _enc.decryptText(item['cipher']!, item['key']!, item['iv']!);
    return plain;
  }

  Future<void> remove(String id) async {
    await deleteNote(id);
    await loadNotes();
  }
}
