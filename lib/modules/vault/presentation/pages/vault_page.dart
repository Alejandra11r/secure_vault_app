import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/provider/auth_provider.dart';
import '../../presentation/provider/vault_provider.dart';
import '../../presentation/widgets/vault_file_actions.dart';
import '../../presentation/widgets/vault_tabs.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key, required this.user});
  final String user;
  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  final _ctrl = TextEditingController();
  String? _loadedAccountId;
  String? _categoryId;
  String? _noteFilter;
  int _selectedTab = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vault = context.read<VaultProvider>();
    final user = context.watch<AuthProvider>().user;
    if (user?.accountId != _loadedAccountId) {
      _loadedAccountId = user?.accountId;
      vault.activateAccount(user?.accountId);
      if (user != null) vault.loadNotes(user.accountId);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _createCategory(
    VaultProvider vault,
    String accountId,
    List<int> key,
  ) async {
    var enteredName = '';
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nueva categoría'),
        content: TextField(
          autofocus: true,
          maxLength: 64,
          onChanged: (value) => enteredName = value,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, enteredName),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (name != null && name.trim().isNotEmpty) {
      await vault.addCategory(accountId, key, name.trim());
    }
  }

  Future<void> _manageCategories(
    VaultProvider vault,
    String accountId,
    List<int> key,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Categorías'),
        content: ListenableBuilder(
          listenable: vault,
          builder: (context, _) => SizedBox(
            width: 420,
            child: vault.categories.isEmpty
                ? const Text('Todavía no hay categorías.')
                : ListView(
                    shrinkWrap: true,
                    children: [
                      for (final item in vault.categories)
                        ListTile(
                          title: FutureBuilder<String>(
                            future: vault.categoryName(accountId, item, key),
                            builder: (context, snapshot) =>
                                Text(snapshot.data ?? 'Categoría'),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Renombrar',
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  final oldName = await vault.categoryName(
                                    accountId,
                                    item,
                                    key,
                                  );
                                  if (!dialogContext.mounted) return;
                                  var renamedCategory = oldName;
                                  final value = await showDialog<String>(
                                    context: dialogContext,
                                    builder: (c) => AlertDialog(
                                      title: const Text(
                                        'Renombrar categoría',
                                      ),
                                      content: TextFormField(
                                        initialValue: oldName,
                                        onChanged: (value) =>
                                            renamedCategory = value,
                                        maxLength: 64,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                            c,
                                          ),
                                          child: const Text(
                                            'Cancelar',
                                          ),
                                        ),
                                        FilledButton(
                                          onPressed: () => Navigator.pop(
                                            c,
                                            renamedCategory,
                                          ),
                                          child: const Text(
                                            'Guardar',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (!mounted || !dialogContext.mounted) {
                                    return;
                                  }
                                  if (value != null &&
                                      value.trim().isNotEmpty) {
                                    await vault.renameCategory(
                                      accountId,
                                      key,
                                      item['id']!,
                                      value.trim(),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                tooltip: 'Eliminar',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: vault.isWriting
                                    ? null
                                    : () async {
                                        await vault.removeCategory(
                                          accountId,
                                          item['id']!,
                                          key,
                                        );
                                        if (mounted) {
                                          setState(() {
                                            if (_noteFilter == item['id']) {
                                              _noteFilter = null;
                                            }
                                            if (_categoryId == item['id']) {
                                              _categoryId = null;
                                            }
                                          });
                                        }
                                      },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final key = auth.vaultKey;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mi Caja Fuerte'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: auth.logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: user == null || key == null
                  ? const Center(
                      child: Text('La caja fuerte está bloqueada.'),
                    )
                  : LayoutBuilder(
                      builder: (context, _) {
                        final dashboard = VaultDashboardTab(
                          vault: vault,
                          accountId: user.accountId,
                          vaultKey: key,
                          controller: _ctrl,
                          categoryId: _categoryId,
                          onCategoryChanged: (value) =>
                              setState(() => _categoryId = value),
                          onSave: () async {
                            try {
                              await vault.addNew(
                                user.accountId,
                                key,
                                _ctrl.text,
                                categoryId: _categoryId,
                              );
                              _ctrl.clear();
                              if (mounted) setState(() {});
                            } catch (_) {
                              if (mounted) {
                                _message("No se pudo guardar la nota.");
                              }
                            }
                          },
                        );
                        final notesPage = VaultNotesTab(
                          vault: vault,
                          accountId: user.accountId,
                          vaultKey: key,
                          categoryFilterId: _noteFilter,
                          onFilterChanged: (value) =>
                              setState(() => _noteFilter = value),
                        );
                        final categoriesPage = VaultCategoriesTab(
                          vault: vault,
                          accountId: user.accountId,
                          vaultKey: key,
                          onCreate: () =>
                              _createCategory(vault, user.accountId, key),
                          onManage: (_) =>
                              _manageCategories(vault, user.accountId, key),
                        );
                        final filesPage = VaultFilesTab(
                          vault: vault,
                          accountId: user.accountId,
                          vaultKey: key,
                          onAdd: () => VaultFileActions(context)
                              .addAttachment(vault, user.accountId, key),
                          onOpen: (item) => VaultFileActions(context)
                              .openFile(vault, user.accountId, item, key),
                        );
                        final profilePage = VaultProfileTab(
                          email: user.email,
                          onLogout: () async {
                            await auth.logout();
                            if (context.mounted) context.go('/login');
                          },
                        );
                        final tab = switch (_selectedTab) {
                          1 => notesPage,
                          2 => categoriesPage,
                          3 => filesPage,
                          4 => profilePage,
                          _ => dashboard,
                        };
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          child: KeyedSubtree(
                            key: ValueKey(_selectedTab),
                            child: tab,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: user == null || key == null
          ? null
          : NavigationBar(
              selectedIndex: _selectedTab,
              onDestinationSelected: (index) =>
                  setState(() => _selectedTab = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.sticky_note_2_outlined),
                  selectedIcon: Icon(Icons.sticky_note_2_rounded),
                  label: 'Notas',
                ),
                NavigationDestination(
                  icon: Icon(Icons.folder_outlined),
                  selectedIcon: Icon(Icons.folder_rounded),
                  label: 'Categorías',
                ),
                NavigationDestination(
                  icon: Icon(Icons.insert_drive_file_outlined),
                  selectedIcon: Icon(Icons.insert_drive_file_rounded),
                  label: 'Archivos',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
            ),
    );
  }
}
