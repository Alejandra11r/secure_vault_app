import 'package:flutter/material.dart';
import 'package:secure_vault_app/modules/vault/presentation/provider/vault_provider.dart';

class ListNotesWidget extends StatelessWidget {
  const ListNotesWidget({
    super.key,
    required this.vault,
  });

  final VaultProvider vault;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: vault.notes.length,
        itemBuilder: (context, index) {
          final item = vault.notes[index];
          return ListTile(
            title: Text('Nota ${item['id']}'),
            subtitle: FutureBuilder<String>(
              future: vault.decrypt(item),
              builder: (context, snap) {
                if (!snap.hasData) return const Text('Cargando...');
                return Text(snap.data ?? '');
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await vault.remove(item['id']!);
              },
            ),
          );
        },
      ),
    );
  }
}