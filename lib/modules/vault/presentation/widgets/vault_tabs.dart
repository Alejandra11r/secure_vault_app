import 'package:flutter/material.dart';

import '../../../../app/theme/vault_theme.dart';
import '../../../../app/widgets/vault_ui.dart';
import '../provider/vault_provider.dart';
import 'list_notes_widget.dart';

class VaultDashboardTab extends StatelessWidget {
  const VaultDashboardTab({
    required this.vault,
    required this.accountId,
    required this.vaultKey,
    required this.controller,
    required this.categoryId,
    required this.onCategoryChanged,
    required this.onSave,
    super.key,
  });

  final VaultProvider vault;
  final String accountId;
  final List<int> vaultKey;
  final TextEditingController controller;
  final String? categoryId;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VaultPanel(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, ${accountId.split('@').first}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 5),
                      const Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            size: 16,
                            color: Color(0xFF68D9B4),
                          ),
                          SizedBox(width: 7),
                          Text('Caja fuerte protegida'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                VaultPanel(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Captura una idea',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        key: const Key('vault_field'),
                        controller: controller,
                        minLines: 2,
                        maxLines: 4,
                        decoration:
                            const InputDecoration(labelText: 'Nueva nota'),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String?>(
                        initialValue: categoryId,
                        decoration:
                            const InputDecoration(labelText: 'Categoría'),
                        items: [
                          const DropdownMenuItem<String?>(
                            child: Text('Sin categoría'),
                          ),
                          ...vault.categories.map(
                            (item) => DropdownMenuItem<String?>(
                              value: item['id'],
                              child: FutureBuilder<String>(
                                future: vault.categoryName(
                                  accountId,
                                  item,
                                  vaultKey,
                                ),
                                builder: (context, snapshot) =>
                                    Text(snapshot.data ?? '…'),
                              ),
                            ),
                          ),
                        ],
                        onChanged: onCategoryChanged,
                      ),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        key: const Key('save_button'),
                        onPressed:
                            vault.isWriting || controller.text.trim().isEmpty
                                ? null
                                : onSave,
                        icon: const Icon(Icons.note_add),
                        label: const Text('Guardar nota'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class VaultNotesTab extends StatelessWidget {
  const VaultNotesTab({
    required this.vault,
    required this.accountId,
    required this.vaultKey,
    required this.categoryFilterId,
    required this.onFilterChanged,
    super.key,
  });

  final VaultProvider vault;
  final String accountId;
  final List<int> vaultKey;
  final String? categoryFilterId;
  final ValueChanged<String?> onFilterChanged;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VaultSectionHeading(
            'Tus notas',
            trailing: Text('${vault.notes.length}'),
          ),
          DropdownButtonFormField<String?>(
            initialValue: categoryFilterId,
            decoration:
                const InputDecoration(labelText: 'Filtrar por categoría'),
            items: [
              const DropdownMenuItem<String?>(child: Text('Todas las notas')),
              ...vault.categories.map(
                (item) => DropdownMenuItem<String?>(
                  value: item['id'],
                  child: FutureBuilder<String>(
                    future: vault.categoryName(accountId, item, vaultKey),
                    builder: (context, snapshot) => Text(snapshot.data ?? '…'),
                  ),
                ),
              ),
            ],
            onChanged: onFilterChanged,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListNotesWidget(
              vault: vault,
              accountId: accountId,
              vaultKey: vaultKey,
              categoryFilterId: categoryFilterId,
            ),
          ),
        ],
      );
}

class VaultCategoriesTab extends StatelessWidget {
  const VaultCategoriesTab({
    required this.vault,
    required this.accountId,
    required this.vaultKey,
    required this.onCreate,
    required this.onManage,
    super.key,
  });

  final VaultProvider vault;
  final String accountId;
  final List<int> vaultKey;
  final VoidCallback onCreate;
  final ValueChanged<Map<String, String>> onManage;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VaultSectionHeading(
            'Tus categorías',
            trailing: IconButton.filledTonal(
              tooltip: 'Crear categoría',
              onPressed: onCreate,
              icon: const Icon(Icons.add),
            ),
          ),
          Expanded(
            child: vault.categories.isEmpty
                ? Center(
                    child: VaultPanel(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.folder_open_outlined,
                            size: 38,
                            color: VaultColors.blue,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Organiza tu caja fuerte',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Crea categorías para encontrar tus notas fácilmente.',
                          ),
                          const SizedBox(height: 14),
                          FilledButton.icon(
                            onPressed: onCreate,
                            icon: const Icon(Icons.add),
                            label: const Text('Nueva categoría'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: vault.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 9),
                    itemBuilder: (context, index) {
                      final item = vault.categories[index];
                      return VaultPanel(
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0x263E7BFA),
                            child: Icon(
                              Icons.folder_rounded,
                              color: VaultColors.blue,
                            ),
                          ),
                          title: FutureBuilder<String>(
                            future:
                                vault.categoryName(accountId, item, vaultKey),
                            builder: (context, snapshot) =>
                                Text(snapshot.data ?? 'Categoría'),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: VaultColors.muted,
                          ),
                          onTap: () => onManage(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
}

class VaultFilesTab extends StatelessWidget {
  const VaultFilesTab({
    required this.vault,
    required this.accountId,
    required this.vaultKey,
    required this.onAdd,
    required this.onOpen,
    super.key,
  });

  final VaultProvider vault;
  final String accountId;
  final List<int> vaultKey;
  final VoidCallback onAdd;
  final ValueChanged<Map<String, Object>> onOpen;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VaultSectionHeading(
            'Archivos protegidos',
            trailing: IconButton.filledTonal(
              tooltip: 'Agregar imagen o documento',
              onPressed: vault.isWriting ? null : onAdd,
              icon: const Icon(Icons.add),
            ),
          ),
          Expanded(
            child: vault.files.isEmpty
                ? const Center(
                    child: VaultPanel(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 38,
                            color: VaultColors.violet,
                          ),
                          SizedBox(height: 12),
                          Text('Aún no hay archivos'),
                          SizedBox(height: 5),
                          Text('Tus documentos e imágenes aparecerán aquí.'),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: vault.files.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 9),
                    itemBuilder: (context, index) {
                      final item = vault.files[index];
                      return VaultPanel(
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0x263E7BFA),
                            child: Icon(
                              Icons.insert_drive_file_outlined,
                              color: VaultColors.blue,
                            ),
                          ),
                          title: FutureBuilder<Map<String, Object>>(
                            future:
                                vault.fileMetadata(accountId, item, vaultKey),
                            builder: (context, snapshot) => Text(
                              snapshot.data?['name'] as String? ??
                                  'Archivo cifrado',
                            ),
                          ),
                          subtitle: Text(
                            '${((item['size']! as int) / 1024).ceil()} KiB · cifrado',
                          ),
                          onTap: () => onOpen(item),
                          trailing: IconButton(
                            tooltip: 'Eliminar archivo',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => vault.removeFile(
                              accountId,
                              item['id']! as String,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
}

class VaultProfileTab extends StatelessWidget {
  const VaultProfileTab({
    required this.email,
    required this.onLogout,
    super.key,
  });
  final String email;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VaultSectionHeading('Perfil y seguridad'),
            VaultPanel(
              child: Column(
                children: [
                  const VaultBrandMark(size: 58),
                  const SizedBox(height: 14),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  const Text('Almacenamiento local cifrado'),
                  const SizedBox(height: 20),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.logout, color: VaultColors.violet),
                    title: const Text('Salir de la sesión'),
                    subtitle: const Text('Desvincula la cuenta de esta sesión'),
                    onTap: onLogout,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
