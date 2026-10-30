import 'package:flutter/material.dart';
import 'package:secure_vault_app/modules/vault/presentation/provider/vault_provider.dart';

import '../../../../app/theme/vault_theme.dart';
import '../../../../app/widgets/vault_panel.dart';

class ListNotesWidget extends StatelessWidget {
  const ListNotesWidget({
    super.key,
    required this.vault,
    required this.accountId,
    required this.vaultKey,
    this.categoryFilterId,
  });

  final VaultProvider vault;
  final String accountId;
  final List<int> vaultKey;
  final String? categoryFilterId;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: vault.notes.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sticky_note_2_outlined,
                    color: VaultColors.muted,
                    size: 34,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tus notas aparecerán aquí',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: VaultColors.muted),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: vault.notes.length,
              itemBuilder: (context, index) {
                final item = vault.notes[index];
                return FutureBuilder<String?>(
                  future: vault.noteCategoryId(accountId, vaultKey, item),
                  builder: (context, snapshot) {
                    if (categoryFilterId != null &&
                        snapshot.data != categoryFilterId) {
                      return const SizedBox.shrink();
                    }
                    return _NoteTile(
                      key: ValueKey(item['id']),
                      vault: vault,
                      accountId: accountId,
                      vaultKey: vaultKey,
                      item: item,
                    );
                  },
                );
              },
            ),
    );
  }
}

class _NoteTile extends StatefulWidget {
  const _NoteTile({
    required this.vault,
    required this.accountId,
    required this.vaultKey,
    required this.item,
    super.key,
  });

  final VaultProvider vault;
  final String accountId;
  final List<int> vaultKey;
  final Map<String, String> item;

  @override
  State<_NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<_NoteTile> {
  late Future<String> _content;

  @override
  void initState() {
    super.initState();
    _content = _decrypt();
  }

  @override
  void didUpdateWidget(covariant _NoteTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accountId != widget.accountId ||
        oldWidget.item != widget.item ||
        !identical(oldWidget.vaultKey, widget.vaultKey)) {
      _content = _decrypt();
    }
  }

  Future<String> _decrypt() => widget.vault.decrypt(
        widget.accountId,
        widget.vaultKey,
        widget.item,
      );

  Future<void> _edit(String id) async {
    final value = await _content;
    if (!mounted) return;
    final categoryId = await widget.vault
        .noteCategoryId(widget.accountId, widget.vaultKey, widget.item);
    if (!mounted) return;
    var editedValue = value;
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar nota'),
        content: TextFormField(
          initialValue: value,
          autofocus: true,
          minLines: 3,
          maxLines: 10,
          onChanged: (text) => editedValue = text,
          decoration: const InputDecoration(labelText: 'Contenido'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, editedValue),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (result != null && result.trim().isNotEmpty) {
      await widget.vault.editNote(
        widget.accountId,
        widget.vaultKey,
        id,
        result,
        categoryId: categoryId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.item['id']!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: VaultPanel(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 19,
              backgroundColor: Color(0x263E7BFA),
              child: Icon(
                Icons.sticky_note_2_outlined,
                color: VaultColors.blue,
                size: 19,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nota ${id.substring(0, id.length < 8 ? id.length : 8)}',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  FutureBuilder<String>(
                    future: _content,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('No se pudo abrir la nota.');
                      }
                      if (!snapshot.hasData) return const Text('Cargando...');
                      return Text(
                        snapshot.data!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: VaultColors.muted),
                      );
                    },
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Editar nota',
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: widget.vault.isWriting ? null : () => _edit(id),
            ),
            IconButton(
              tooltip: 'Eliminar nota',
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: widget.vault.isWriting
                  ? null
                  : () async {
                      await widget.vault.remove(widget.accountId, id);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
