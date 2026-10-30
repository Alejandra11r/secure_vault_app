import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' as d;
import 'package:secure_vault_app/core/security/encryption_service.dart';
import 'package:secure_vault_app/modules/vault/data/database/vault_database.dart';

/// SQLite guarda identificadores y texto cifrado autenticado.
/// Las claves de notas heredadas se conservan.
class VaultLocalDataSource {
  VaultLocalDataSource(this.database, this.encryptionService);

  static const int maxNoteBytes = 1 << 20;
  static const int maxFileBytes = 50 << 20;
  static const int maxAccountFileBytes = 500 << 20;
  final VaultDatabase database;
  final EncryptionService encryptionService;

  Future<void> saveNote({
    required String accountId,
    required String id,
    required String plainText,
    required List<int> vaultKey,
    String? categoryId,
  }) async {
    final text = plainText.trim();
    if (text.isEmpty || utf8.encode(text).length > maxNoteBytes) {
      throw const FormatException('La nota está vacía o supera 1 MiB.');
    }
    await database.reserveEncryption(accountId);
    final encrypted = await encryptionService.encryptContent(
      plainText: jsonEncode({'text': text, 'categoryId': categoryId}),
      vaultKey: vaultKey,
      associatedData: _aad('note', accountId, id),
    );
    await database.into(database.vaultNotes).insertOnConflictUpdate(
          VaultNotesCompanion.insert(
            id: id,
            accountId: accountId,
            nonce: Uint8List.fromList(encrypted.nonce),
            cipherText: Uint8List.fromList(encrypted.cipherText),
            mac: Uint8List.fromList(encrypted.mac),
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<List<Map<String, String>>> getNotes(String accountId) async {
    final rows = await (database.select(database.vaultNotes)
          ..where((row) => row.accountId.equals(accountId))
          ..orderBy([(row) => d.OrderingTerm.desc(row.createdAt)]))
        .get();
    return rows
        .map((row) => {
              'id': row.id,
              'nonce': base64UrlEncode(row.nonce),
              'cipherText': base64UrlEncode(row.cipherText),
              'mac': base64UrlEncode(row.mac),
            },)
        .toList(growable: false);
  }

  Future<String> decryptNote({
    required String accountId,
    required Map<String, String> note,
    required List<int> vaultKey,
  }) async {
    final json = await _decryptJson(
      type: 'note',
      accountId: accountId,
      id: note['id']!,
      nonce: note['nonce']!,
      cipherText: note['cipherText']!,
      mac: note['mac']!,
      vaultKey: vaultKey,
    );
    return json['text'] as String;
  }

  Future<String?> decryptNoteCategoryId({
    required String accountId,
    required Map<String, String> note,
    required List<int> vaultKey,
  }) async {
    final json = await _decryptJson(
        type: 'note',
        accountId: accountId,
        id: note['id']!,
        nonce: note['nonce']!,
        cipherText: note['cipherText']!,
        mac: note['mac']!,
        vaultKey: vaultKey,);
    return json['categoryId'] as String?;
  }

  Future<void> deleteNote(String accountId, String id) async {
    await (database.delete(database.vaultNotes)
          ..where((row) => row.accountId.equals(accountId) & row.id.equals(id)))
        .go();
  }

  Future<void> saveCategory({
    required String accountId,
    required String id,
    required String name,
    required List<int> vaultKey,
  }) async {
    final normalized = name.trim();
    if (normalized.isEmpty || normalized.length > 64) {
      throw const FormatException(
          'El nombre debe tener entre 1 y 64 caracteres.',);
    }
    await database.reserveEncryption(accountId);
    final encrypted = await encryptionService.encryptContent(
      plainText: jsonEncode({'name': normalized}),
      vaultKey: vaultKey,
      associatedData: _aad('category', accountId, id),
    );
    await database.into(database.vaultCategories).insertOnConflictUpdate(
          VaultCategoriesCompanion.insert(
              id: id,
              accountId: accountId,
              nonce: Uint8List.fromList(encrypted.nonce),
              cipherText: Uint8List.fromList(encrypted.cipherText),
              mac: Uint8List.fromList(encrypted.mac),),
        );
  }

  Future<List<Map<String, String>>> getCategories(String accountId) async {
    final rows = await (database.select(database.vaultCategories)
          ..where((row) => row.accountId.equals(accountId)))
        .get();
    return rows
        .map((r) => {
              'id': r.id,
              'nonce': base64UrlEncode(r.nonce),
              'cipherText': base64UrlEncode(r.cipherText),
              'mac': base64UrlEncode(r.mac),
            },)
        .toList();
  }

  Future<String> decryptCategory(
      String accountId, Map<String, String> item, List<int> key,) async {
    final json = await _decryptJson(
        type: 'category',
        accountId: accountId,
        id: item['id']!,
        nonce: item['nonce']!,
        cipherText: item['cipherText']!,
        mac: item['mac']!,
        vaultKey: key,);
    return json['name'] as String;
  }

  Future<void> deleteCategory(
      String accountId, String id, List<int> vaultKey,) async {
    final noteRows = await (database.select(database.vaultNotes)
          ..where((row) => row.accountId.equals(accountId)))
        .get();
    for (final row in noteRows) {
      final note = {
        'id': row.id,
        'nonce': base64UrlEncode(row.nonce),
        'cipherText': base64UrlEncode(row.cipherText),
        'mac': base64UrlEncode(row.mac),
      };
      final content = await _decryptJson(
        type: 'note',
        accountId: accountId,
        id: row.id,
        nonce: note['nonce']!,
        cipherText: note['cipherText']!,
        mac: note['mac']!,
        vaultKey: vaultKey,
      );
      if (content['categoryId'] != id) continue;
      content['categoryId'] = null;
      await database.reserveEncryption(accountId);
      final encrypted = await encryptionService.encryptContent(
        plainText: jsonEncode(content),
        vaultKey: vaultKey,
        associatedData: _aad('note', accountId, row.id),
      );
      await (database.update(database.vaultNotes)
            ..where((item) =>
                item.accountId.equals(accountId) & item.id.equals(row.id),))
          .write(VaultNotesCompanion(
        nonce: d.Value(Uint8List.fromList(encrypted.nonce)),
        cipherText: d.Value(Uint8List.fromList(encrypted.cipherText)),
        mac: d.Value(Uint8List.fromList(encrypted.mac)),
      ),);
    }
    final fileRows = await (database.select(database.vaultFiles)
          ..where((row) => row.accountId.equals(accountId)))
        .get();
    for (final row in fileRows) {
      final file = {
        'id': row.id,
        'metadataNonce': base64UrlEncode(row.metadataNonce),
        'metadataCipherText': base64UrlEncode(row.metadataCipherText),
        'metadataMac': base64UrlEncode(row.metadataMac),
        'nonce': base64UrlEncode(row.nonce),
        'cipherText': base64UrlEncode(row.cipherText),
        'mac': base64UrlEncode(row.mac),
        'size': row.plainSize,
      };
      final metadata = await decryptFileMetadata(accountId, file, vaultKey);
      if (metadata['categoryId'] != id) continue;
      metadata.remove('categoryId');
      await database.reserveEncryption(accountId);
      final encrypted = await encryptionService.encryptContent(
        plainText: jsonEncode(metadata),
        vaultKey: vaultKey,
        associatedData: _aad('file-metadata', accountId, row.id),
      );
      await (database.update(database.vaultFiles)
            ..where((item) =>
                item.accountId.equals(accountId) & item.id.equals(row.id),))
          .write(VaultFilesCompanion(
        metadataNonce: d.Value(Uint8List.fromList(encrypted.nonce)),
        metadataCipherText: d.Value(Uint8List.fromList(encrypted.cipherText)),
        metadataMac: d.Value(Uint8List.fromList(encrypted.mac)),
      ),);
    }
    await (database.delete(database.vaultCategories)
          ..where((row) => row.accountId.equals(accountId) & row.id.equals(id)))
        .go();
  }

  Future<void> saveFile({
    required String accountId,
    required String id,
    required String name,
    required String mimeType,
    required List<int> bytes,
    required List<int> vaultKey,
    String? categoryId,
  }) async {
    if (bytes.isEmpty || bytes.length > maxFileBytes) {
      throw const FormatException('El archivo debe ocupar como máximo 50 MiB.');
    }
    final used = await (database.selectOnly(database.vaultFiles)
          ..addColumns([database.vaultFiles.plainSize.sum()])
          ..where(database.vaultFiles.accountId.equals(accountId)))
        .getSingle();
    final total = used.read(database.vaultFiles.plainSize.sum()) ?? 0;
    if (total + bytes.length > maxAccountFileBytes) {
      throw const FormatException(
          'La caja fuerte admite hasta 500 MiB en archivos.',);
    }
    await database.reserveEncryption(accountId);
    await database.reserveEncryption(accountId);
    final metadataFields = <String, Object>{
      'name': name,
      'mimeType': mimeType,
    };
    if (categoryId != null) metadataFields['categoryId'] = categoryId;
    final metadata = utf8.encode(jsonEncode(metadataFields));
    final encryptedMetadata = await encryptionService.encryptBytes(
        plainBytes: metadata,
        vaultKey: vaultKey,
        associatedData: _aad('file-metadata', accountId, id),);
    final encryptedContent = await encryptionService.encryptBytes(
        plainBytes: bytes,
        vaultKey: vaultKey,
        associatedData: _aad('file-content', accountId, id),);
    await database.into(database.vaultFiles).insertOnConflictUpdate(
          VaultFilesCompanion.insert(
              id: id,
              accountId: accountId,
              metadataNonce: Uint8List.fromList(encryptedMetadata.nonce),
              metadataCipherText:
                  Uint8List.fromList(encryptedMetadata.cipherText),
              metadataMac: Uint8List.fromList(encryptedMetadata.mac),
              nonce: Uint8List.fromList(encryptedContent.nonce),
              cipherText: Uint8List.fromList(encryptedContent.cipherText),
              mac: Uint8List.fromList(encryptedContent.mac),
              plainSize: bytes.length,),
        );
  }

  Future<List<Map<String, Object>>> getFiles(String accountId) async {
    final rows = await (database.select(database.vaultFiles)
          ..where((row) => row.accountId.equals(accountId)))
        .get();
    return rows
        .map((r) => {
              'id': r.id,
              'metadataNonce': base64UrlEncode(r.metadataNonce),
              'metadataCipherText': base64UrlEncode(r.metadataCipherText),
              'metadataMac': base64UrlEncode(r.metadataMac),
              'nonce': base64UrlEncode(r.nonce),
              'cipherText': base64UrlEncode(r.cipherText),
              'mac': base64UrlEncode(r.mac),
              'size': r.plainSize,
            },)
        .toList();
  }

  Future<Map<String, Object>> decryptFile(
      String accountId, Map<String, Object> item, List<int> key,) async {
    final metadata = await decryptFileMetadata(accountId, item, key);
    final content = await encryptionService.decryptBytes(
        content: _box(item),
        vaultKey: key,
        associatedData: _aad('file-content', accountId, item['id']! as String),);
    metadata['bytes'] = Uint8List.fromList(content);
    return metadata;
  }

  Future<Map<String, Object>> decryptFileMetadata(
      String accountId, Map<String, Object> item, List<int> key,) async {
    final metadata = await _decryptJson(
      type: 'file-metadata',
      accountId: accountId,
      id: item['id']! as String,
      nonce: item['metadataNonce']! as String,
      cipherText: item['metadataCipherText']! as String,
      mac: item['metadataMac']! as String,
      vaultKey: key,
    );
    return metadata.map((key, value) => MapEntry(key, value));
  }

  Future<void> deleteFile(String accountId, String id) async {
    await (database.delete(database.vaultFiles)
          ..where((row) => row.accountId.equals(accountId) & row.id.equals(id)))
        .go();
  }

  Future<Map<String, dynamic>> _decryptJson({
    required String type,
    required String accountId,
    required String id,
    required String nonce,
    required String cipherText,
    required String mac,
    required List<int> vaultKey,
  }) async =>
      jsonDecode(await encryptionService.decryptContent(
          content: EncryptedContent(
              nonce: base64Url.decode(nonce),
              cipherText: base64Url.decode(cipherText),
              mac: base64Url.decode(mac),),
          vaultKey: vaultKey,
          associatedData: _aad(type, accountId, id),),) as Map<String, dynamic>;

  EncryptedContent _box(Map<String, Object> value) => EncryptedContent(
      nonce: base64Url.decode(value['nonce']! as String),
      cipherText: base64Url.decode(value['cipherText']! as String),
      mac: base64Url.decode(value['mac']! as String),);

  List<int> _aad(String type, String accountId, String id) => utf8.encode(
      jsonEncode(['secure-vault', 1, type, accountId, id, 'aes-256-gcm']),);
}
