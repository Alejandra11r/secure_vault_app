import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:secure_vault_app/modules/vault/presentation/widgets/list_notes_widget.dart';
import '../../presentation/provider/vault_provider.dart';
import '../../../auth/presentation/provider/auth_provider.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key, required this.user});
  final String user;
  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vault = Provider.of<VaultProvider>(context, listen: false);
    vault.loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final vault = Provider.of<VaultProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Caja Fuerte'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                final myMap = {'id': 1, 'name': 'Alejandra', 'role': 'admin'};
                final encodedMap = Uri.encodeComponent(jsonEncode(myMap));
                context.go('/login?data=$encodedMap');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.user),
            TextField(
              key: const Key('vault_field'),
              controller: _ctrl,
              decoration: const InputDecoration(labelText: 'Nueva nota'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              key: const Key('save_button'),
              onPressed: () async {
                if (_ctrl.text.trim().isEmpty) return;
                await vault.addNew(_ctrl.text.trim());
                _ctrl.clear();
              },
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 20),
            ListNotesWidget(vault: vault),
          ],
        ),
      ),
    );
  }
}


