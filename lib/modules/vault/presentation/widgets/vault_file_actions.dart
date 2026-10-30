import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/vault_theme.dart';
import '../provider/vault_provider.dart';

/// Owns the platform picker, preview, import, export and plaintext cleanup flow.
class VaultFileActions {
  VaultFileActions(this.context);

  final BuildContext context;
  final ImagePicker _imagePicker = ImagePicker();

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _pickImage(
    ImageSource source,
    VaultProvider vault,
    String accountId,
    List<int> key,
  ) async {
    final picked = await (() async {
      vault.beginExternalActivity();
      try {
        return await _imagePicker
            .pickImage(source: source, requestFullMetadata: false)
            .catchError((Object _) {
          if (context.mounted) {
            _message('No se pudo acceder a la cámara o galería.');
          }
          return null;
        });
      } finally {
        vault.endExternalActivity();
      }
    })();
    if (picked == null) return;
    if (!context.mounted) {
      try {
        await File(picked.path).delete();
      } catch (_) {}
      return;
    }
    late final Uint8List bytes;
    try {
      bytes = await picked.readAsBytes();
    } catch (_) {
      if (context.mounted) _message('No se pudo leer la imagen seleccionada.');
      try {
        await File(picked.path).delete();
      } catch (_) {}
      return;
    }
    if (!context.mounted) {
      bytes.fillRange(0, bytes.length, 0);
      try {
        await File(picked.path).delete();
      } catch (_) {}
      return;
    }
    if (bytes.length > 50 << 20) {
      bytes.fillRange(0, bytes.length, 0);
      try {
        await File(picked.path).delete();
      } catch (_) {
        // The picker may not provide a filesystem-backed temporary file.
      }
      _message('El archivo supera el límite de 50 MiB.');
      return;
    }
    final mime = _imageMime(picked.name);
    if (!_validSignature(bytes, mime)) {
      bytes.fillRange(0, bytes.length, 0);
      try {
        await File(picked.path).delete();
      } catch (_) {
        // The picker may not provide a filesystem-backed temporary file.
      }
      _message('La imagen debe ser JPEG o PNG.');
      return;
    }
    final preview = ResizeImage(
      MemoryImage(Uint8List.fromList(bytes)),
      width: 1280,
    );
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Guardar imagen cifrada'),
          content: SizedBox(
            height: 280,
            child: Center(
              child: Image(
                image: preview,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.broken_image_outlined, size: 42),
                    SizedBox(height: 8),
                    Text('No se pudo previsualizar esta imagen.'),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      );
      if (confirmed == true && context.mounted) {
        await _saveFile(vault, accountId, key, picked.name, mime, bytes);
      } else {
        bytes.fillRange(0, bytes.length, 0);
      }
    } catch (_) {
      if (context.mounted) _message('No se pudo mostrar o guardar la imagen.');
    } finally {
      try {
        await preview.evict();
      } catch (_) {}
      bytes.fillRange(0, bytes.length, 0);
      try {
        await File(picked.path).delete();
      } catch (_) {
        // Some picker implementations don't expose the temporary file.
      }
    }
  }

  Future<void> _pickDocument(
    VaultProvider vault,
    String accountId,
    List<int> key,
  ) async {
    final result = await (() async {
      vault.beginExternalActivity();
      try {
        return await FilePicker.platform
            .pickFiles(
          type: FileType.custom,
          allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf', 'txt'],
          withData: true,
        )
            .catchError((Object _) {
          if (context.mounted) {
            _message('No se pudo abrir el selector de documentos.');
          }
          return null;
        });
      } finally {
        vault.endExternalActivity();
      }
    })();
    if (result == null || result.files.isEmpty || !context.mounted) return;
    final picked = result.files.single;
    final selectedBytes = picked.bytes;
    if (selectedBytes == null) {
      _message('No se pudo leer el documento seleccionado.');
      try {
        await FilePicker.platform.clearTemporaryFiles();
      } catch (_) {}
      return;
    }
    // FilePicker may own its returned buffer. Work on a writable copy so the
    // secure memory cleanup cannot throw after a successful database write.
    final bytes = Uint8List.fromList(selectedBytes);
    try {
      final ext = (picked.extension ?? '').toLowerCase();
      final mime = switch (ext) {
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'pdf' => 'application/pdf',
        'txt' => 'text/plain',
        _ => '',
      };
      if (mime.isEmpty || !_validSignature(bytes, mime)) {
        _message('Formato no compatible o contenido inválido.');
        return;
      }
      await _saveFile(vault, accountId, key, picked.name, mime, bytes);
    } catch (_) {
      if (context.mounted) _message('No se pudo completar la importación.');
    } finally {
      bytes.fillRange(0, bytes.length, 0);
      try {
        await FilePicker.platform.clearTemporaryFiles();
      } catch (_) {
        // A platform picker can own the temp-file lifecycle itself.
      }
    }
  }

  Future<void> _saveFile(
    VaultProvider vault,
    String accountId,
    List<int> key,
    String name,
    String mime,
    List<int> bytes,
  ) async {
    try {
      await vault.addFile(accountId, key, name, mime, bytes);
      if (context.mounted) _message('Archivo cifrado y guardado.');
    } catch (error) {
      if (context.mounted) _message('No se pudo guardar: $error');
    } finally {
      try {
        bytes.fillRange(0, bytes.length, 0);
      } catch (_) {
        // Avoid reporting failure after data has already been persisted.
      }
    }
  }

  String _imageMime(String name) =>
      name.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
  bool _validSignature(List<int> b, String mime) {
    if (mime == 'image/jpeg') {
      return b.length > 3 && b[0] == 0xff && b[1] == 0xd8 && b[2] == 0xff;
    }
    if (mime == 'image/png') {
      return b.length > 8 && b.take(8).join(',') == '137,80,78,71,13,10,26,10';
    }
    if (mime == 'application/pdf') {
      return utf8.decode(b.take(5).toList(), allowMalformed: true) == '%PDF-';
    }
    if (mime == 'text/plain') {
      try {
        utf8.decode(b, allowMalformed: false);
        return true;
      } on FormatException {
        return false;
      }
    }
    return false;
  }

  Future<void> addAttachment(
    VaultProvider vault,
    String accountId,
    List<int> key,
  ) async {
    final source = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: VaultColors.surfaceRaised,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Agregar a la caja fuerte',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Elegir imagen'),
                onTap: () => Navigator.pop(sheetContext, 0),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Tomar fotografía'),
                onTap: () => Navigator.pop(sheetContext, 1),
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file_outlined),
                title: const Text('Elegir documento'),
                onTap: () => Navigator.pop(sheetContext, 2),
              ),
            ],
          ),
        ),
      ),
    );
    if (!context.mounted || source == null) return;
    switch (source) {
      case 0:
        await _pickImage(ImageSource.gallery, vault, accountId, key);
        break;
      case 1:
        await _pickImage(ImageSource.camera, vault, accountId, key);
        break;
      case 2:
        await _pickDocument(vault, accountId, key);
        break;
    }
  }

  Future<void> openFile(
    VaultProvider vault,
    String accountId,
    Map<String, Object> file,
    List<int> key,
  ) async {
    Uint8List? decoded;
    try {
      final data = await vault.openFile(accountId, file, key);
      final plaintext = data['bytes'] as Uint8List;
      decoded = plaintext;
      final mime = data['mimeType'] as String;
      if (!context.mounted) return;
      if (mime.startsWith('image/')) {
        final preview = ResizeImage(MemoryImage(plaintext), width: 1600);
        await showDialog<void>(
          context: context,
          builder: (c) => Dialog(
            child: InteractiveViewer(
              child: Image(
                image: preview,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image_outlined, size: 48),
                ),
              ),
            ),
          ),
        );
        await preview.evict();
      } else if (mime == 'text/plain') {
        await showDialog<void>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(data['name'] as String),
            content: SingleChildScrollView(
              child: Text(
                utf8.decode(plaintext),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      } else {
        vault.beginExternalActivity();
        String? out;
        try {
          out = await FilePicker.platform
              .saveFile(fileName: data['name'] as String, bytes: plaintext);
        } finally {
          vault.endExternalActivity();
        }
        if (context.mounted && out != null) {
          _message(
            'Copia descifrada exportada. Elimina esa copia cuando termines.',
          );
        }
      }
    } catch (_) {
      if (context.mounted) _message('No se pudo descifrar o abrir el archivo.');
    } finally {
      decoded?.fillRange(0, decoded.length, 0);
    }
  }
}
